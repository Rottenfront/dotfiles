import QtQuick
import QtQuick.Layouts
import "../theme"

RowLayout {
    required property string icon
    required property string label
    required property string value

    Layout.fillWidth: true
    spacing: 14

    Rectangle {
        Layout.preferredWidth: 36
        Layout.preferredHeight: 36
        radius: 8
        color: Theme.tertiary_container

        Text {
            anchors.centerIn: parent
            text: icon
            font.family: "Material Design Icons"
            font.pixelSize: 18
            color: Theme.on_tertiary_container
        }
    }

    Text {
        Layout.fillWidth: true
        text: label
        color: Theme.on_surface_variant
        font.pixelSize: 14
        font.weight: Font.Medium
    }

    Text {
        text: value
        color: Theme.on_surface
        font.pixelSize: 14
        font.weight: Font.Bold
    }
}
