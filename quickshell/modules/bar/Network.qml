import QtQuick
import Quickshell.Io
import qs.services as Services
import qs.theme

Rectangle {
    border.color: Theme.outline
    border.width: 1
    clip: true
    color: Theme.surface_container
    implicitHeight: Theme.barWidgetHeight
    implicitWidth: Math.min(label.implicitWidth + Theme.barPadding, 200)
    radius: Theme.radiusPill
    z: 100

    MouseArea {
        anchors.fill: parent

        onClicked: toggleProc.running = true
    }
    Text {
        id: label

        anchors.centerIn: parent
        color: Theme.on_surface
        elide: Text.ElideRight
        font.family: Theme.mono
        font.pixelSize: Theme.size
        maximumLineCount: 1
        text: Services.Network.icon + " " + Services.Network.wifiLabel
    }
    Process {
        id: toggleProc

        command: ["qs", "ipc", "call", "networkPanel", "changeVisible", "wifi"]
    }
}
