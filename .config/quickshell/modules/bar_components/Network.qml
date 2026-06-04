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
    z: 100

    implicitWidth: Math.min(label.implicitWidth + 20, 200)

    clip: true

    MouseArea {
        anchors.fill: parent
        onClicked: toggleProc.running = true
    }

    Text {
        id: label
        anchors.centerIn: parent

        text: Services.Network.icon + " " + Services.Network.wifiLabel
        color: Theme.on_surface

        elide: Text.ElideRight
        maximumLineCount: 1
        font.pixelSize: Theme.size
        font.family: Theme.mono
    }

    Process {
        id: toggleProc
        command: ["qs", "ipc", "call", "networkPanel", "changeVisible", "wifi"]
    }
}
