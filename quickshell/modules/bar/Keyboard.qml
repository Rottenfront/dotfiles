import QtQuick
import qs.services as Services
import qs.theme

Rectangle {
    readonly property var hypr: Services.Hyprland

    border.color: Theme.outline
    border.width: 1
    color: Theme.surface_container
    implicitHeight: Theme.barWidgetHeight
    implicitWidth: layout.width + Theme.barPadding
    radius: Theme.radiusPill

    Text {
        id: layout

        anchors.centerIn: parent
        color: Theme.on_surface
        font.bold: true
        font.family: Theme.mono
        font.pixelSize: Theme.size
        text: hypr.keyboardLayout
    }
}
