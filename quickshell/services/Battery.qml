pragma Singleton

import QtQuick
import Quickshell.Io
import qs.components
import qs.config

Item {
    id: root

    property bool charging: false
    property bool full: percentage >= 100
    property real percentage: 0

    function formatTime(seconds) {
        if (seconds <= 0)
            return ""

        const hours = Math.floor(seconds / 3600)
        const minutes = Math.floor((seconds % 3600) / 60)
        if (hours > 0)
            return hours + "h " + minutes + "m"

        return minutes + "m"
    }

    function getIcon(percent, charging, isReady) {
        if (!isReady)
            return Icons.batteryUnknown

        if (charging)
            return Icons.batteryCharging

        const p = Math.round(percent)
        if (p >= 90)
            return Icons.battery100

        if (p >= 80)
            return Icons.battery90

        if (p >= 70)
            return Icons.battery80

        if (p >= 60)
            return Icons.battery70

        if (p >= 50)
            return Icons.battery60

        if (p >= 40)
            return Icons.battery50

        if (p >= 30)
            return Icons.battery40

        if (p >= 20)
            return Icons.battery30

        if (p >= 10)
            return Icons.battery20

        return Icons.battery10
    }

    function getStateColor(percent, charging, full) {
        if (charging)
            return "#a6e3a1"

        if (full)
            return "#89b4fa"

        if (percent <= 20)
            return "#f38ba8"

        if (percent <= 40)
            return "#fab387"

        return "#cdd6f4"
    }

    Process {
        id: batProc

        command: ["sh", "-c", "printf '%s %s\\n' \"$(cat \"$1/capacity\")\" \"$(cat \"$1/status\")\"", "battery", Config.batteryPath]

        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(" ")
                if (parts.length >= 2) {
                    root.percentage = parseInt(parts[0]) || 0
                    root.charging = parts[1] === "Charging"
                }
            }
        }
    }
    Timer {
        interval: Config.batteryPollInterval
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: batProc.running = true
    }
}
