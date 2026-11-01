import QtQuick
import QtQuick.Layouts
import qs.theme

Rectangle {
    id: root

    required property string icon
    required property real maxValue
    required property real value

    border.color: Theme.outline
    border.width: 1
    clip: true
    color: Theme.background
    implicitHeight: mainLayout.implicitHeight + 25
    implicitWidth: 40
    radius: width / 2

    Behavior on opacity {
        NumberAnimation {
            duration: Theme.durationNormal
        }
    }
    Behavior on x {
        NumberAnimation {
            duration: Theme.durationNormal
        }
    }

    ColumnLayout {
        id: mainLayout

        spacing: Theme.spacingLarge
        width: parent.width
        y: Theme.spacingMedium

        Text {
            Layout.alignment: Qt.AlignHCenter
            color: Theme.on_surface
            font.family: Theme.icons
            font.pixelSize: Theme.fontIconMedium
            text: root.icon
        }
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 100
            color: Theme.surface
            implicitWidth: Theme.spacingNormal
            radius: Theme.radiusSmall

            Rectangle {
                color: Theme.primary
                height: Math.min(parent.height * (root.value / root.maxValue), parent.height)
                radius: Theme.radiusSmall
                width: parent.width

                Behavior on height {
                    NumberAnimation {
                        duration: Theme.durationLong
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
}
