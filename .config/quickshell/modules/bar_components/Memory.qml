import QtQuick
import Quickshell
import Quickshell.Io
import qs.services as Services
import "../../theme"

Rectangle {
    radius: 14
    color: Theme.surface_container
    border.color: Theme.outline
    border.width: 1
    implicitHeight: 28
    implicitWidth: memory.implicitWidth + 20

    MouseArea {
        anchors.fill: parent
        onClicked: toggleProc.running = true
    }

    Text {
        id: memory
        text: " " + Math.round(Services.System.ram) + "%"
        color: Theme.on_surface
        anchors.centerIn: parent
        font.pixelSize: Theme.size
        font.family: Theme.mono
    }

    Process {
        id: toggleProc
        command: ["qs","ipc","call","controlCenter","changeVisible"]
    }

}
