import QtQuick
import QtQuick.Layouts
import qs.theme

Rectangle {
    id: root

    required property string icon
    required property string label
    required property color buttonColor
    signal clicked

    Layout.fillWidth: true
    Layout.preferredHeight: 56

    radius: 16
    border.width: 1
    border.color: Theme.outline_variant

    property bool hovered: false
    property bool pressed: false
    color: buttonColor

    scale: pressed ? 0.96 : (hovered ? 0.98 : 1)
    opacity: hovered ? 0.95 : 1

    RowLayout {
        anchors.centerIn: parent
        spacing: 12

        Text {
            text: icon
            font.family: "Material Design Icons"
            font.pixelSize: 22
            color: Theme.on_surface
        }

        Text {
            text: label
            font.pixelSize: 14
            font.family: Theme.sans
            font.weight: Font.DemiBold
            color: Theme.on_surface
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: root.clicked()
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onPressed: root.pressed = true
        onReleased: root.pressed = false
    }

    Behavior on scale { NumberAnimation { duration: 90; easing.type: Easing.OutCubic } }
    Behavior on opacity { NumberAnimation { duration: 90 } }
}
