pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    readonly property bool active: running || requests.length > 0
    readonly property int barsCount: Math.max(2, Math.min(512, Config.cavaBarsCount - Config.cavaBarsCount % 2))
    readonly property string configuration: ["[general]", "bars = " + barsCount, "framerate = " + Math.max(1, Config.cavaFramerate), "autosens = 1", "[output]", "method = raw", "raw_target = /dev/stdout", "data_format = ascii", "ascii_max_range = " + maxRange, "bar_delimiter = 59", "frame_delimiter = 10", "[smoothing]", "monstercat = " + Config.cavaMonstercat, "waves = 0", ""].join("\n")
    readonly property int maxRange: Math.max(1, Config.cavaAsciiMaxRange)
    property int nextRequest: 0
    readonly property bool processRunning: cavaProc.running
    property var requests: []
    property bool running: false
    property var values: Array(barsCount).fill(0)

    function acquire(): int {
        const request = nextRequest++;
        requests = requests.concat([request])
        return request
    }

    function parseFrame(data: string): void {
        if (!active)
            return
        const parts = data.trim().split(";")
        if (parts[parts.length - 1] === "")
            parts.pop()
        if (parts.length !== barsCount)
            return
        const frame = []
        for (const part of parts) {
            if (part.trim() === "")
                return
            const value = Number(part)
            if (!isFinite(value))
                return
            frame.push(Math.max(0, Math.min(1, value / maxRange)))
        }
        values = frame
    }

    function release(request: int): void {
        requests = requests.filter(value => value !== request)
    }

    function start(): void {
        if (!active)
            return
        cavaProc.stdinEnabled = true
        cavaProc.running = true
    }

    onActiveChanged: {
        if (active) {
            start()
        } else {
            cavaProc.running = false
            values = Array(barsCount).fill(0)
        }
    }

    Timer {
        interval: Config.cavaRetryInterval
        repeat: true
        running: root.active && !cavaProc.running

        onTriggered: root.start()
    }
    Timer {
        interval: Config.cavaStopTimeout
        running: !root.active && cavaProc.running

        onTriggered: cavaProc.signal(9)
    }
    Process {
        id: cavaProc

        command: ["python3", decodeURIComponent(Qt.resolvedUrl("../scripts/cava_capture.py").toString().replace(/^file:\/\//, ""))]
        environment: Config.commandEnvironment

        stderr: SplitParser {
            onRead: data => console.warn("Cava: " + data)
        }
        stdout: SplitParser {
            onRead: data => root.parseFrame(data)
        }

        onExited: root.values = Array(root.barsCount).fill(0)
        onStarted: {
            write(root.configuration)
            stdinEnabled = false
        }
    }
}
