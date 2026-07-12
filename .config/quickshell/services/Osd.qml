pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property bool volVisible: false

    Timer {
        id: volHideTimer
        interval: 1000
        onTriggered: volVisible = false
    }

    function showVolume() {
        volVisible = true
        volHideTimer.restart()
    }
    property bool brightnessVisible: false

    Timer {
        id: brightnessHideTimer
        interval: 1000
        onTriggered: brightnessVisible = false
    }

    function showBrightness() {
        brightnessVisible = true
        brightnessHideTimer.restart()
    }
}
