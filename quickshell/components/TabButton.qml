import QtQuick
import qs.theme

Rectangle {
    id: root

    property bool active: false
    property string text

    signal clicked

    color: active ? Theme.primary_container : Theme.secondary_container
    height: 32
    radius: Theme.radiusNormal
    width: 90

    Text {
        anchors.centerIn: parent
        color: Theme.on_surface
        text: root.text
    }
    MouseArea {
        anchors.fill: parent

        onClicked: root.clicked()
    }
}
