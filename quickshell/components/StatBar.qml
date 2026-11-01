import QtQuick
import QtQuick.Layouts
import qs.config
import qs.theme

ColumnLayout {
    id: root

    readonly property bool critical: value > Config.statCriticalThreshold
    required property string icon
    required property string label
    property real maxValue: 100
    readonly property color stateColor: critical ? Theme.statCritical : warning ? Theme.statWarning : Theme.primary
    property string suffix: "%"
    required property real value
    readonly property bool warning: value > Config.statWarningThreshold

    Layout.fillWidth: true
    spacing: Theme.spacingMedium

    RowLayout {
        Layout.fillWidth: true
        spacing: Theme.spacingLarge

        Rectangle {
            Layout.preferredHeight: Theme.iconBadgeSize
            Layout.preferredWidth: Theme.iconBadgeSize
            color: Qt.rgba(root.stateColor.r, root.stateColor.g, root.stateColor.b, 0.2)
            radius: Theme.radiusNormal

            Behavior on color {
                ColorAnimation {
                    duration: Theme.durationMedium
                }
            }

            Text {
                anchors.centerIn: parent
                color: root.stateColor
                font.family: Theme.icons
                font.pixelSize: Theme.fontIconMedium
                text: root.icon
            }
        }
        Text {
            Layout.fillWidth: true
            color: Theme.on_surface
            font.family: Theme.sans
            font.pixelSize: Theme.fontMedium
            font.weight: Font.Medium
            text: root.label
        }
        Text {
            color: root.stateColor
            font.family: Theme.mono
            font.pixelSize: Theme.fontHeading
            font.weight: Font.Bold
            text: Math.round(root.value) + root.suffix
        }
    }
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.spacingNormal
        color: Theme.surface_container_high
        radius: Theme.radiusSmall

        Rectangle {
            height: parent.height
            radius: Theme.radiusSmall
            width: Math.min(parent.width * (root.value / root.maxValue), parent.width)

            gradient: Gradient {
                orientation: Gradient.Horizontal

                GradientStop {
                    color: root.stateColor
                    position: 0
                }
                GradientStop {
                    color: root.critical ? Theme.statCriticalEnd : root.warning ? Theme.statWarningEnd : Theme.secondary
                    position: 1
                }
            }
            Behavior on width {
                NumberAnimation {
                    duration: Theme.durationLong
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
