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
        text: {
            const characters = ((pill.media.isPlaying ? "> " : "⏸ ") + (pill.media.artist ? pill.media.artist + " — " + pill.media.title : pill.media.title)).match(/[\s\S]/gu)
            return characters.length > 100 ? characters.slice(0, 99).join("") + "…" : characters.join("")
        }
    }
    MouseArea {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.fill: parent

        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                Services.Panels.toggleMusic()
            else
                pill.media.playPause()
        }
    }
}
