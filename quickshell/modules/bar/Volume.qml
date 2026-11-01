import QtQuick
import qs.services as Services
import qs.theme

Rectangle {
    border.color: Theme.outline
    border.width: 1
    clip: true
    color: Theme.surface_container
    implicitHeight: Theme.barWidgetHeight
    implicitWidth: Math.min(label.implicitWidth + Theme.barPadding, 160)
    radius: Theme.radiusPill

    Text {
        id: label

        anchors.centerIn: parent
        color: Theme.on_surface
        elide: Text.ElideRight
        font.family: Theme.mono
        font.pixelSize: Theme.size
        maximumLineCount: 1
        text: " " + Math.round(Services.Volume.volume * 100) + "%"
    }
}
