import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import Quickshell.Io
import qs.theme

Rectangle {
    id: pill
    property var media: MpcController

    property int maxWidth: 1000
    visible: media.active

    border.color: Theme.outline
    border.width: 1
    radius: height / 2
    height: 28
    implicitHeight: 28
    color: Theme.background

    clip: true
    implicitWidth: Math.min(mediaText.implicitWidth + 20, maxWidth)

    Text {
        id: mediaText
        anchors.centerIn: parent
        text: (media.playing ? "> " : "⏸ ") + (media.artist ? media.artist + " — " + media.title : media.title)

        color: Theme.on_surface
        font.pixelSize: Theme.size
        font.family: Theme.mono
        // font.italic: !media.playing
        // font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: media.toggle()
    }
}
