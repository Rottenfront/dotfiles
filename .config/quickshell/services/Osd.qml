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
}
