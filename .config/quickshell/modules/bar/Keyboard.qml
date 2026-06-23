import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.services as Services
import qs.theme

Rectangle {
    readonly property var hypr: Services.Hyprland

    implicitHeight: 28
    implicitWidth: layout.width + 20
    color: Theme.surface_container
    radius: 14
    border.color: Theme.outline
    border.width: 1

    Text {
        id: layout
        anchors.centerIn: parent
        text: hypr.keyboardLayout
        font.bold: true
        color: Theme.on_surface
        font.pixelSize: Theme.size
        font.family: Theme.mono
    }
}
