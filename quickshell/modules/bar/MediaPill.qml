import QtQuick
import qs.services as Services
import qs.theme

Rectangle {
    id: pill

    property int maxWidth: 1000
    property var media: Services.Media

    border.color: Theme.outline
    border.width: 1
    clip: true
    color: Theme.background
    height: Theme.barWidgetHeight
    implicitHeight: Theme.barWidgetHeight
    implicitWidth: Math.min(mediaText.implicitWidth + Theme.barPadding, maxWidth)
    radius: height / 2
    visible: media.active

    Text {
        id: mediaText

        anchors.centerIn: parent
        color: Theme.on_surface
        font.family: Theme.mono
        font.pixelSize: Theme.size
        text: (pill.media.isPlaying ? "> " : "⏸ ") + (pill.media.artist ? pill.media.artist + " — " + pill.media.title : pill.media.title)
    }
    MouseArea {
        anchors.fill: parent

        onClicked: pill.media.playPause()
    }
}
