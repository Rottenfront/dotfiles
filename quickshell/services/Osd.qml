pragma Singleton

import QtQuick
import Quickshell
import qs.config

Singleton {
    id: root

    property bool brightnessVisible: false
    property bool volVisible: false

    function showBrightness() {
        brightnessVisible = true
        brightnessHideTimer.restart()
    }

    function showVolume() {
        volVisible = true
        volHideTimer.restart()
    }

    Timer {
        id: volHideTimer

        interval: Config.osdTimeout

        onTriggered: root.volVisible = false
    }
    Timer {
        id: brightnessHideTimer

        interval: Config.osdTimeout

        onTriggered: root.brightnessVisible = false
    }
}
