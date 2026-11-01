import QtQuick
import QtQuick.Layouts
import qs.theme

Rectangle {
    id: root

    required property color buttonColor
    property bool hovered: false
    required property string icon
    required property string label
    property bool pressed: false

    signal clicked

    Layout.fillWidth: true
    Layout.preferredHeight: 56
    border.color: Theme.outline_variant
    border.width: 1
    color: buttonColor
    opacity: hovered ? 0.95 : 1
    radius: Theme.radiusCard
    scale: pressed ? 0.96 : (hovered ? 0.98 : 1)

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.durationPress
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: Theme.durationPress
            easing.type: Easing.OutCubic
        }
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: Theme.spacingLarge

        Text {
            color: Theme.on_surface
            font.family: Theme.icons
            font.pixelSize: Theme.fontLarge
            text: root.icon
        }
        Text {
            color: Theme.on_surface
            font.family: Theme.sans
            font.pixelSize: Theme.fontMedium
            font.weight: Font.DemiBold
            text: root.label
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
}
