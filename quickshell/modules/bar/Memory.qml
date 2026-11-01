import QtQuick
import Quickshell.Io
import qs.config
import qs.services as Services
import qs.theme

Rectangle {
    border.color: Theme.outline
    border.width: 1
    color: Theme.surface_container
    implicitHeight: Theme.barWidgetHeight
    implicitWidth: memory.implicitWidth + Theme.barPadding
    radius: Theme.radiusPill

    MouseArea {
        anchors.fill: parent

        onClicked: toggleProc.running = true
    }
    Text {
        id: memory

        anchors.centerIn: parent
        color: Theme.on_surface
        font.family: Theme.mono
        font.pixelSize: Theme.size
        text: " " + Math.round(Services.System.ram) + "%"
    }
    Process {
        id: toggleProc

        command: Config.toggleControlCenter
    }
}
