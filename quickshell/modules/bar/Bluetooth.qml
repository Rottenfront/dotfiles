import QtQuick
import Quickshell.Io
import qs.components
import qs.services as Services
import qs.theme

Rectangle {
    property string bluetoothLabel: {
        const adapter = Services.Bluetooth.defaultAdapter
        const device = Services.Bluetooth.activeDevice

        if (!adapter?.enabled)
            return "Off"

        if (device)
            return device.name

        return "Bluetooth"
    }

    border.color: Theme.outline
    border.width: 1
    clip: true
    color: Theme.surface_container
    implicitHeight: Theme.barWidgetHeight
    implicitWidth: Math.min(label.implicitWidth + Theme.barPadding, 200)
    radius: Theme.radiusPill
    z: 100

    Text {
        id: label

        anchors.centerIn: parent
        color: Theme.on_surface
        elide: Text.ElideRight
        font.family: Theme.mono
        font.pixelSize: Theme.size
        maximumLineCount: 1
        text: Icons.bluetooth + " " + bluetoothLabel
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
