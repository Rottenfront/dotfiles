import QtQuick
import qs.services as Services
import qs.components
import Quickshell.Io
import qs.theme

Rectangle {
    radius: 14
    color: Theme.surface_container
    border.color: Theme.outline
    border.width: 1

    implicitHeight: 28
    implicitWidth: cpu.implicitWidth + 16

    MouseArea {
        anchors.fill: parent
        onClicked: toggleProc.running = true
    }

    Text {
        id: cpu
        anchors.centerIn: parent
        text: Icons.system + " " + Math.round(Services.System.cpu) + "%"
        color: Theme.on_surface
        font.pixelSize: Theme.size
        font.family: Theme.mono
    }

    Process {
        id: toggleProc
        command: ["qs", "ipc", "call", "systemPanel", "toggle"]
    }
}
