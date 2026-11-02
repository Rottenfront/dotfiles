import argparse
import fcntl
import json
import os
from pathlib import Path
import re
import shutil
import stat
import subprocess
import tempfile
import time
import unicodedata


MAX_ENTRIES = 750
MAX_PREVIEWS = 40
MAX_PREVIEW_BYTES = 8 * 1024 * 1024
MAX_CACHE_BYTES = 32 * 1024 * 1024
MAX_PAYLOAD_BYTES = 64 * 1024 * 1024
IMAGE_DESCRIPTION = re.compile(r"^\[\[ binary data .+ (png|jpeg|gif|webp|bmp|tiff) (\d+)x(\d+) \]\]$")
TERMINALS = {"kitty", "foot", "footclient", "alacritty", "org.wezfurlong.wezterm",
             "com.mitchellh.ghostty", "ghostty", "wezterm", "org.kde.konsole", "konsole",
             "gnome-terminal-server", "org.gnome.terminal", "xterm", "urxvt", "st"}


class ClipboardError(Exception):
    pass


def run(command, data=None, timeout=10, empty_history=False):
    result = subprocess.run(command, input=data, stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE if empty_history else subprocess.DEVNULL,
                            timeout=timeout, check=False)
    if result.returncode:
        if empty_history and result.stderr.strip().endswith(b"please store something first"):
            return b""
        raise ClipboardError(f"{command[0]} failed")
    return result.stdout


def entry_id(value):
    if not re.fullmatch(r"[1-9][0-9]{0,19}", value) or int(value) > 2**64 - 1:
        raise ClipboardError("Invalid history entry ID")
    return value


def address(value):
    if not re.fullmatch(r"0x[0-9a-fA-F]{1,16}", value) or int(value, 16) == 0:
        raise ClipboardError("No valid application window was captured; copied only")
    return value.lower()


def decode(value, limit=MAX_PAYLOAD_BYTES):
    value = entry_id(value)
    with tempfile.TemporaryFile() as output:
        process = subprocess.Popen(["cliphist", "decode"], stdin=subprocess.PIPE,
                                   stdout=output, stderr=subprocess.DEVNULL)
        try:
            process.communicate(value.encode("ascii"), timeout=10)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()
            raise ClipboardError("Decoding history entry timed out")
        if process.returncode:
            raise ClipboardError("History entry no longer exists; refresh and try again")
        if output.tell() > limit:
            raise ClipboardError("History entry exceeds the size limit")
        output.seek(0)
        return output.read(limit + 1)


def image_type(data):
    if data.startswith(b"\x89PNG\r\n\x1a\n"):
        return "image/png", "png"
    if data.startswith(b"\xff\xd8\xff"):
        return "image/jpeg", "jpg"
    if data.startswith((b"GIF87a", b"GIF89a")):
        return "image/gif", "gif"
    if data.startswith(b"RIFF") and data[8:12] == b"WEBP":
        return "image/webp", "webp"
    if data.startswith(b"BM"):
        return "image/bmp", "bmp"
    if data.startswith((b"II*\x00", b"MM\x00*")):
        return "image/tiff", "tiff"
    return None


def cache_root():
    base = Path(os.environ.get("XDG_CACHE_HOME") or Path.home() / ".cache")
    root = base / "quickshell-clipboard"
    root.mkdir(mode=0o700, parents=True, exist_ok=True)
    info = root.lstat()
    if not stat.S_ISDIR(info.st_mode) or info.st_uid != os.getuid():
        raise ClipboardError("Unsafe clipboard preview cache directory")
    root.chmod(0o700)
    return root


def clear_cache(root):
    for child in root.iterdir():
        if re.fullmatch(r"preview-[a-z0-9_]{8}", child.name):
            if child.is_symlink():
                child.unlink()
            elif child.is_dir():
                shutil.rmtree(child)


def clean_label(value):
    return "".join(c for c in value if not unicodedata.category(c).startswith("C"))[:500]


def list_entries():
    root = cache_root()
    with open(root / ".lock", "a") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        clear_cache(root)
        generation = Path(tempfile.mkdtemp(prefix="preview-", dir=root))
        raw = run(["cliphist", "list"], empty_history=True)
        entries = []
        used_bytes = 0
        previews = 0
        for line in raw.decode("utf-8", "replace").splitlines():
            value, separator, preview = line.partition("\t")
            try:
                entry_id(value)
            except ClipboardError:
                continue
            if not separator:
                continue
            description = IMAGE_DESCRIPTION.fullmatch(preview)
            entry = {"id": value, "text": clean_label(preview), "image": bool(description),
                     "preview": ""}
            if description and previews < MAX_PREVIEWS:
                width, height = int(description[2]), int(description[3])
                if 0 < width <= 16384 and 0 < height <= 16384 and width * height <= 40000000:
                    try:
                        data = decode(value, MAX_PREVIEW_BYTES)
                        kind = image_type(data)
                        if kind and used_bytes + len(data) <= MAX_CACHE_BYTES:
                            path = generation / (value + "." + kind[1])
                            with path.open("xb") as output:
                                os.chmod(path, 0o600)
                                output.write(data)
                            entry["preview"] = path.as_uri()
                            used_bytes += len(data)
                            previews += 1
                    except ClipboardError:
                        pass
            entries.append(entry)
            if len(entries) >= MAX_ENTRIES:
                break
        return {"entries": entries}


def snapshot():
    window = json.loads(run(["hyprctl", "activewindow", "-j"]))
    target = window.get("address", "")
    try:
        target = address(target)
    except ClipboardError:
        target = ""
    terminal = str(window.get("class", "")).lower() in TERMINALS
    return {"address": target, "mods": "CTRL SHIFT" if terminal else "CTRL"}


def dispatch(expression):
    response = run(["hyprctl", "dispatch", expression]).decode("utf-8", "replace").strip()
    if response != "ok":
        raise ClipboardError("Hyprland could not focus or paste into the captured window; copied only")


def paste(target, mods):
    target = address(target)
    selector = "address:" + target
    clients = json.loads(run(["hyprctl", "clients", "-j"]))
    if not any(str(client.get("address", "")).lower() == target for client in clients):
        raise ClipboardError("The original window was closed; copied only")
    dispatch('hl.dsp.focus({ window = "' + selector + '" })')
    for _ in range(15):
        window = json.loads(run(["hyprctl", "activewindow", "-j"]))
        if str(window.get("address", "")).lower() == target:
            break
        time.sleep(0.02)
    else:
        raise ClipboardError("The original window could not regain focus; copied only")
    dispatch('hl.dsp.send_shortcut({ window = "' + selector + '", mods = "' + mods + '", key = "v" })')
    return {}


def main():
    parser = argparse.ArgumentParser()
    commands = parser.add_subparsers(dest="action", required=True)
    for command in ("list", "snapshot", "wipe", "clear-cache"):
        commands.add_parser(command)
    for command in ("copy", "delete"):
        commands.add_parser(command).add_argument("id")
    paste_parser = commands.add_parser("paste")
    paste_parser.add_argument("address")
    paste_parser.add_argument("--mods", choices=("CTRL", "CTRL SHIFT"), default="CTRL")
    args = parser.parse_args()
    os.umask(0o077)
    try:
        result = {}
        if args.action == "list":
            result = list_entries()
        elif args.action == "snapshot":
            result = snapshot()
        elif args.action == "copy":
            data = decode(args.id)
            kind = image_type(data)
            command = ["wl-copy"]
            if kind:
                command += ["--type", kind[0]]
            run(command, data)
        elif args.action == "delete":
            run(["cliphist", "delete"], (entry_id(args.id) + "\n").encode("ascii"))
        elif args.action == "wipe":
            run(["cliphist", "wipe"])
        elif args.action == "paste":
            result = paste(args.address, args.mods)
        if args.action in ("delete", "wipe", "clear-cache"):
            root = cache_root()
            with open(root / ".lock", "a") as lock:
                fcntl.flock(lock, fcntl.LOCK_EX)
                clear_cache(root)
        print(json.dumps({"ok": True, **result}, ensure_ascii=True))
    except (ClipboardError, OSError, ValueError, subprocess.SubprocessError) as error:
        if isinstance(error, ClipboardError):
            message = str(error)
        elif isinstance(error, FileNotFoundError):
            message = "Required clipboard command is not installed"
        elif isinstance(error, subprocess.TimeoutExpired):
            message = "Clipboard command timed out"
        else:
            message = "Clipboard operation failed"
        print(json.dumps({"ok": False, "error": message}))
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
