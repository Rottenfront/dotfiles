import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.services
import Quickshell.Io
import "../../theme"
import qs.components

Rectangle {
    id: pill
    property var media: Media

    property int maxWidth: 1000
    visible: media.activePlayer !== null

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
        x: 10
        y: 5
        // anchors.centerIn: parent
        text: (media.isPlaying ? "▶ " : "⏸ ") + (media.artist ? media.artist + " — " + media.title : media.title)

        color: Theme.on_surface
        font.pixelSize: Theme.size
        font.family: Theme.mono
        font.italic: !media.isPlaying
    }

    MouseArea {
        anchors.fill: parent
        onClicked: playPause.running = true
    }
    Process {
        id: playPause
        command: ["playerctl", "play-pause"]
    }
}
