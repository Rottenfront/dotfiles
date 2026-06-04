import QtQuick
import Quickshell.Io
import "../../theme"
import qs.services as Services

Rectangle {
    radius: 14
    border.width: 1
    border.color: Theme.outline
    color: Theme.surface_container
    implicitHeight: 28
    implicitWidth: clock.implicitWidth + 16

    MouseArea {
        onClicked: toggleProc.running = true
        anchors.fill: parent
    }

    Text {
        id: clock
        anchors.centerIn: parent

        font.family: Theme.mono
        font.pixelSize: Theme.size

        text: Services.Time.format("hh:mm:ss")
        color: Theme.on_surface
    }

    // Process {
    //     id: toggleProc
    //     command: ["qs", "ipc", "call", "calendarWindow", "toggle"]
    // }
}
