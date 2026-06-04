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
    implicitWidth: Math.min(label.implicitWidth + 20, 160)
    clip: true

    Text {
        id: label
        anchors.centerIn: parent
        text: " " + Math.round(Services.Volume.volume*100) + "%"
        color: Theme.on_surface
        elide: Text.ElideRight
        maximumLineCount: 1
        font.pixelSize: Theme.size
        font.family: Theme.mono
    }



}
