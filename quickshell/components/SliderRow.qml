pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.theme

Item {
    id: root

    property color accentColor: Theme.primary
    property int animFast: Theme.durationPress
    property int animSmall: Theme.durationShort
    property int fontLarge: Theme.fontLarge
    property int fontMedium: Theme.fontMedium
    property real from: 0
    property real handleGap: 6
    property string icon: ""
    property int iconSize: fontLarge
    property string label: ""
    property color labelColor: Theme.on_surface
    property int moveFast: Theme.durationQuick
    property int rounding: Theme.radiusCompact
    property bool showValue: true
    property int snapMode: stepSize > 0 ? Slider.SnapAlways : Slider.NoSnap
    property real stepSize: 0
    property real to: 100
    property color trackColor: Theme.surface_container_high
    property real trackHeightDiff: 30
    property bool useAnim: true
    property real value: 0
    property color valueColor: Theme.on_surface_variant
    property int valuePrecision: 0
    property string valuePrefix: ""
    property string valueSuffix: ""

    signal moved(real value)

    Layout.fillWidth: true
    implicitHeight: label !== "" ? 60 : 40
    implicitWidth: 200

    ColumnLayout {
        anchors.fill: parent
        spacing: Theme.spacingNormal

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: root.label !== "" ? 20 : 0
            visible: root.label !== ""

            RowLayout {
                anchors.fill: parent
                spacing: Theme.spacingLarge

                Text {
                    color: root.accentColor
                    font.family: Theme.materialIcons
                    font.pixelSize: root.iconSize
                    text: root.icon
                    visible: root.icon !== ""
                }
                Text {
                    Layout.fillWidth: true
                    color: root.labelColor
                    elide: Text.ElideRight
                    font.pixelSize: root.fontMedium
                    font.weight: Font.Medium
                    text: root.label
                }
                Text {
                    color: root.valueColor
                    font.family: Theme.sliderMono
                    font.pixelSize: root.fontMedium
                    font.weight: Font.DemiBold
                    text: {
                        const value = root.valuePrecision > 0 ? slider.value.toFixed(root.valuePrecision) : Math.round(slider.value)
                        return root.valuePrefix + value + root.valueSuffix
                    }
                    visible: root.showValue
                }
            }
        }
        Slider {
            id: slider

            Layout.fillWidth: true
            Layout.preferredHeight: 40
            from: root.from
            snapMode: root.snapMode
            stepSize: root.stepSize
            to: root.to
            value: root.value

            background: Item {
                anchors.fill: parent

                Rectangle {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.accentColor
                    height: slider.height - root.trackHeightDiff
                    radius: height / 2
                    width: slider.visualPosition * slider.width

                    Behavior on width {
                        NumberAnimation {
                            duration: root.useAnim ? root.animSmall : 0
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                /* ===== Unfilled ===== */
                Rectangle {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    color: root.trackColor
                    height: slider.height - root.trackHeightDiff
                    radius: height / 2
                    width: (1 - slider.visualPosition) * slider.width

                    Behavior on width {
                        NumberAnimation {
                            duration: root.useAnim ? root.animSmall : 0
                            easing.type: Easing.OutCubic
                        }
                    }
                }
            }
            handle: Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                color: root.accentColor
                height: width
                radius: width / 2
                width: slider.pressed ? Theme.paddingLarge : Theme.paddingSection
                x: slider.visualPosition * (slider.width - width)

                Behavior on width {
                    NumberAnimation {
                        duration: root.animFast
                    }
                }
                Behavior on x {
                    NumberAnimation {
                        duration: root.moveFast
                        easing.type: Easing.OutCubic
                    }
                }
            }

            onMoved: root.moved(value)
        }
    }
}
