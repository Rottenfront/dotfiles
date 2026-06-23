import QtQuick
import Quickshell
import Quickshell.Io
import qs.components
import qs.services as Services
import qs.theme

Rectangle {
    radius: 14
    border.width: 1
    border.color: Theme.outline
    color: Theme.surface_container
    implicitHeight: 28
    z: 100

    implicitWidth: Math.min(label.implicitWidth + 20, 200)

    clip: true


    Text {
        id: label
        anchors.centerIn: parent

        text: Icons.bluetooth  + " " + bluetoothLabel
        color: Theme.on_surface

        elide: Text.ElideRight
        maximumLineCount: 1
        font.pixelSize: Theme.size
        font.family: Theme.mono
    }

    property string bluetoothLabel: {
        const adapter = Services.Bluetooth.defaultAdapter
        const device = Services.Bluetooth.activeDevice

        if (!adapter?.enabled)
        return "Off"

        if (device)
            return device.name

        return "Bluetooth"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: toggleProc.running = true
    }
    Process {
        id: toggleProc
        command: ["qs", "ipc", "call", "networkPanel", "changeVisible", "bluetooth"]
    }
}
