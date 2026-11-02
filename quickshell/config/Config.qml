pragma Singleton

import QtQuick
import Quickshell

QtObject {
    readonly property string batteryPath: "/sys/class/power_supply/BAT0"
    readonly property int batteryPollInterval: 5000
    readonly property int brightnessPollInterval: 500
    readonly property int cavaAsciiMaxRange: 1000
    readonly property int cavaBarsCount: 100
    readonly property int cavaFramerate: 30
    readonly property real cavaMonstercat: 1.5
    readonly property int cavaRetryInterval: 5000
    readonly property real cavaSmoothingFactor: 0.3
    readonly property int cavaStopTimeout: 1000
    readonly property int clockPollInterval: 100
    readonly property var commandEnvironment: ({
            LANG: "C.UTF-8",
            LC_ALL: "C.UTF-8"
        })
    readonly property int criticalNotificationTimeout: 10000
    readonly property string dateTimeFormat: "d MMM yyyy | hh:mm:ss"
    readonly property string lockScreen: Quickshell.env("HOME") + "/.config/quickshell/Lock.qml"
    readonly property int minimumWorkspacePages: 20
    readonly property int notificationTimeout: 5000
    readonly property int osdTimeout: 1000
    readonly property real powerActionDelay: 0.35
    readonly property string recordingCommand: "nohup wf-recorder -f \"$1/recording_$(date +%Y%m%d_%H%M%S).mp4\" >/dev/null 2>&1 &"
    readonly property string recordingDirectory: Quickshell.env("HOME") + "/Videos/recordings"
    readonly property string screenshotCommand: "qs ipc --pid \"$2\" call ctrl toggle && mkdir -p -- \"$1\" && hyprshot -m region -o \"$1\" -f \"screenshot_$(date +%Y%m%d_%H%M%S).png\""
    readonly property string screenshotDirectory: Quickshell.env("HOME") + "/Pictures/screenshots"
    readonly property int secondInterval: 1000
    readonly property int statCriticalThreshold: 80
    readonly property int statWarningThreshold: 60
    readonly property int systemPollInterval: 2000
    readonly property list<string> toggleControlCenter: ["qs", "ipc", "--pid", String(Quickshell.processId), "call", "ctrl", "toggle"]
    readonly property string wallpaper: Quickshell.env("HOME") + "/Pictures/wallpapers/ae70fvoe.jpg"
    readonly property int workspacesPerPage: 10
}
