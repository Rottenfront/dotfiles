import QtQuick
import Quickshell.Io
import qs.components
import qs.config
import qs.services as Services
import qs.theme

Rectangle {
    border.color: Theme.outline
    border.width: 1
    color: Theme.surface_container
    implicitHeight: Theme.barWidgetHeight
    implicitWidth: cpu.implicitWidth + Theme.barPaddingCompact
    radius: Theme.radiusPill

    MouseArea {
        anchors.fill: parent

        onClicked: toggleProc.running = true
    }
    Text {
        id: cpu

        anchors.centerIn: parent
        color: Theme.on_surface
        font.family: Theme.mono
        font.pixelSize: Theme.size
        text: Icons.system + " " + Math.round(Services.System.cpu) + "%"
    }
    Process {
        id: toggleProc

        command: Config.toggleControlCenter
    }
}
