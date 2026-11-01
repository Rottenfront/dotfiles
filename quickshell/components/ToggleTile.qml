import QtQuick
import QtQuick.Layouts
import qs.theme

Rectangle {
    id: root

    required property bool active
    required property string icon
    required property string label

    signal clicked

    Layout.fillWidth: true
    Layout.preferredHeight: 82
    border.color: active ? "transparent" : Theme.outline_variant
    border.width: active ? 0 : 1
    color: active ? Theme.primary_container : Theme.surface_container_high
    layer.enabled: active
    radius: Theme.radiusCard

    Behavior on border.color {
        ColorAnimation {
            duration: Theme.durationNormal
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: Theme.durationNormal
        }
    }
    Behavior on scale {
        NumberAnimation {
            duration: Theme.durationFast
            easing.type: Easing.OutCubic
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: Theme.spacingMedium

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            color: root.active ? Theme.primary_container : Theme.surface_container_high
            implicitHeight: 40
            implicitWidth: 40
            radius: width / 2

            Behavior on color {
                ColorAnimation {
                    duration: Theme.durationNormal
                }
            }

            Text {
                anchors.centerIn: parent
                color: root.active ? Qt.rgba(1, 1, 1, 1) : Theme.on_surface_variant
                font.family: Theme.icons
                font.pixelSize: Theme.fontIconLarge
                text: root.icon
            }
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            color: root.active ? Qt.rgba(1, 1, 1, 0.95) : Theme.on_surface_variant
            font.family: Theme.sans
            font.pixelSize: Theme.fontBody
            font.weight: Font.Medium
            text: root.label
        }
    }
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: root.clicked()
        onEntered: root.scale = 0.96
        onExited: root.scale = 1
    }
}
