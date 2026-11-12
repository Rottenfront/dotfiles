pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
import qs.services
import "CpuUsage.js" as CpuUsage

Singleton {
    id: stats

    property int brightness: 0
    property real cpu: 0
    property real cpuPeak: 0
    property var cpuCores: []
    property var previousCpuSample: ({})
    property real disk: 0
    property int lastBrightness: -1
    property real ram: 0
    property real temp: 0
    property string uptime: "0h 0m"

    function setBrightness(v) {
        setBrightnessProc.command = ["brightnessctl", "set", v + "%"]
        setBrightnessProc.running = true
        stats.brightness = v
        Osd.showBrightness()
    }

    onBrightnessChanged: {
        if (lastBrightness !== -1 && brightness !== lastBrightness) {
            Osd.showBrightness()
        }
        lastBrightness = brightness
    }

    Timer {
        interval: Config.systemPollInterval
        repeat: true
        running: true

        onTriggered: {
            ramProc.running = true
            diskProc.running = true
            tempProc.running = true
            uptimeProc.running = true
        }
    }
    Timer {
        interval: Config.cpuPollInterval
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: cpuProc.running = true
    }
    Timer {
        interval: Config.brightnessPollInterval
        repeat: true
        running: true

        onTriggered: {
            brightnessProc.running = true
        }
    }
    Process {
        id: cpuProc

        command: ["cat", "/proc/stat"]
        environment: Config.commandEnvironment

        stdout: StdioCollector {
            onStreamFinished: {
                const sample = CpuUsage.parse(text)
                if (!sample.cpu)
                    return
                const result = CpuUsage.measure(stats.previousCpuSample, sample)
                stats.previousCpuSample = sample
                if (result.all !== null) {
                    stats.cpu = result.all
                    stats.cpuPeak = result.peak
                    stats.cpuCores = result.cores
                }
            }
        }
    }
    Process {
        id: ramProc

        command: ["bash", "-c", "free | awk '/Mem:/ {print $3/$2 * 100.0}'"]
        environment: Config.commandEnvironment

        stdout: StdioCollector {
            onStreamFinished: stats.ram = parseFloat(text) || 0
        }
    }
    Process {
        id: diskProc

        command: ["bash", "-c", "df -h / | awk 'NR==2 {print $5}' | sed 's/%//'"]
        environment: Config.commandEnvironment

        stdout: StdioCollector {
            onStreamFinished: stats.disk = parseFloat(text) || 0
        }
    }
    Process {
        id: tempProc

        command: ["bash", "-c", "sensors | grep 'temp1:' | awk '{print $2}' | sed 's/+//;s/°C//' || echo '0'"]
        environment: Config.commandEnvironment

        stdout: StdioCollector {
            onStreamFinished: stats.temp = parseFloat(text) || 0
        }
    }
    Process {
        id: uptimeProc

        command: ["bash", "-c", "cat /proc/uptime | awk '{print int($1)}'"]
        environment: Config.commandEnvironment

        stdout: StdioCollector {
            onStreamFinished: {
                let seconds = parseInt(text) || 0
                let hours = Math.floor(seconds / 3600)
                let minutes = Math.floor((seconds % 3600) / 60)
                stats.uptime = hours + "h " + minutes + "m"
            }
        }
    }
    Process {
        id: brightnessProc

        command: ["bash", "-c", "brightnessctl -m | cut -d, -f4 | tr -d '%'"]
        environment: Config.commandEnvironment

        stdout: StdioCollector {
            onStreamFinished: {
                let v = parseInt(text) || 0
                stats.brightness = v
            }
        }
    }
    Process {
        id: setBrightnessProc
    }
}
