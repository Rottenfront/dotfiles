import configparser
import ctypes
import io
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import tempfile
import threading
import uuid


TERMUSIC_NODE = "alsa_playback.termusic-server"
STOP = threading.Event()
LIBC = ctypes.CDLL(None, use_errno=True)


def spawn(command, **kwargs):
    parent = os.getpid()

    def child_setup():
        if LIBC.prctl(1, signal.SIGKILL, 0, 0, 0) != 0:
            os._exit(1)
        if os.getppid() != parent:
            os._exit(1)

    return subprocess.Popen(command, preexec_fn=child_setup, **kwargs)


def run(command):
    with spawn(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True) as process:
        try:
            output, error = process.communicate(timeout=2)
        except subprocess.TimeoutExpired:
            process.kill()
            process.communicate()
            raise RuntimeError(f"{command[0]} timed out")
        if process.returncode:
            raise RuntimeError(f"{command[0]}: {error.strip()}")
        return output


def props(obj):
    return obj.get("info", {}).get("props", {})


def update_links(name):
    graph = json.loads(run(["pw-dump", "-N"]))
    nodes = [obj for obj in graph if obj["type"] == "PipeWire:Interface:Node"]
    captures = [node for node in nodes if props(node).get("node.name") == name]
    if not captures:
        return
    capture = captures[0]
    if props(capture).get("node.autoconnect") is not False:
        raise RuntimeError("capture node does not have autoconnect disabled")
    sources = [
        node for node in nodes
        if props(node).get("node.name") == TERMUSIC_NODE
        and props(node).get("media.class") == "Stream/Output/Audio"
    ]
    source = sources[0] if len(sources) == 1 else None
    ports = [obj for obj in graph if obj["type"] == "PipeWire:Interface:Port"]
    inputs = {
        props(port).get("audio.channel"): port for port in ports
        if props(port).get("node.id") == capture["id"]
        and props(port).get("port.direction") == "in"
    }
    outputs = {
        props(port).get("audio.channel"): port for port in ports
        if source and props(port).get("node.id") == source["id"]
        and props(port).get("port.direction") == "out"
    }
    desired = {}
    if source and source["info"].get("state") == "running":
        for channel in ("FL", "FR"):
            output = outputs.get(channel, outputs.get("MONO"))
            if channel not in inputs or output is None:
                desired = {}
                break
            desired[(output["id"], inputs[channel]["id"])] = (
                f"{TERMUSIC_NODE}:{props(output)['port.name']}",
                f"{name}:{props(inputs[channel])['port.name']}",
            )
    existing = set()
    for link in graph:
        info = link.get("info", {})
        if link["type"] != "PipeWire:Interface:Link" or info.get("input-node-id") != capture["id"]:
            continue
        if not source or info.get("output-node-id") != source["id"]:
            raise RuntimeError("unexpected capture source; refusing mixed audio")
        pair = (info["output-port-id"], info["input-port-id"])
        existing.add(pair)
        if pair not in desired:
            output = next(port for port in ports if port["id"] == pair[0])
            input_port = next(port for port in ports if port["id"] == pair[1])
            run(["pw-link", "-d", f"{TERMUSIC_NODE}:{props(output)['port.name']}",
                 f"{name}:{props(input_port)['port.name']}"])
    for pair, endpoints in desired.items():
        if pair not in existing and not STOP.is_set():
            run(["pw-link", "-P", *endpoints])


def stop_children(children):
    for process in children:
        if process.poll() is None:
            process.terminate()
    for process in children:
        try:
            process.wait(timeout=0.25)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()


def main():
    signal.signal(signal.SIGTERM, lambda *_: STOP.set())
    signal.signal(signal.SIGINT, lambda *_: STOP.set())
    config = configparser.ConfigParser(interpolation=None)
    config.read_string(sys.stdin.read())
    with tempfile.TemporaryDirectory(prefix="quickshell-cava-") as directory:
        fifo = Path(directory) / "audio.fifo"
        os.mkfifo(fifo, 0o600)
        config["input"] = {
            "method": "fifo", "source": str(fifo),
            "sample_rate": "44100", "sample_bits": "16",
        }
        rendered = io.StringIO()
        config.write(rendered)
        env = dict(os.environ, XDG_CONFIG_HOME=directory)
        name = f"quickshell.cava.termusic.{uuid.uuid4().hex}"
        children = []
        keeper = os.open(fifo, os.O_RDWR | os.O_NONBLOCK)
        try:
            cava = spawn(["cava", "-p", "/dev/stdin"], stdin=subprocess.PIPE, env=env, text=True)
            children.append(cava)
            cava.stdin.write(rendered.getvalue())
            cava.stdin.close()
            with fifo.open("wb", buffering=0) as audio:
                capture = spawn([
                    "pw-cat", "--record", "--target=0", "--raw", "--format=s16",
                    "--rate=44100", "--channels=2", "--channel-map=FL,FR",
                    "--properties=" + json.dumps({
                        "node.name": name, "node.autoconnect": False,
                        "node.dont-reconnect": True, "node.passive": True,
                        "state.restore-props": False, "media.role": "DSP",
                        "application.name": "Quickshell Cava Termusic",
                    }), "-",
                ], stdout=audio)
            children.append(capture)
            while not STOP.is_set():
                for process in children:
                    if process.poll() is not None:
                        raise RuntimeError(f"{process.args[0]} exited with status {process.returncode}")
                try:
                    update_links(name)
                except (RuntimeError, json.JSONDecodeError) as error:
                    if not STOP.is_set():
                        raise RuntimeError(f"Termusic capture stopped: {error}") from error
                STOP.wait(0.5)
        finally:
            stop_children(children)
            os.close(keeper)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except (OSError, RuntimeError, configparser.Error) as error:
        print(f"Cava: {error}", file=sys.stderr)
        sys.exit(1)
