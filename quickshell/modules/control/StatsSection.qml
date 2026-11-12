import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services as Services
import qs.theme

ColumnLayout {
    Layout.fillWidth: true
    Layout.leftMargin: Theme.paddingSection
    Layout.rightMargin: Theme.paddingSection
    Layout.topMargin: Theme.paddingSection
    spacing: Theme.spacingSection

    RowLayout {
        Layout.fillWidth: true

        Text {
            Layout.fillWidth: true
            color: Theme.on_surface
            font.letterSpacing: Theme.sectionLetterSpacing
            font.pixelSize: Theme.fontHeading
            font.weight: Font.DemiBold
            text: "System Resources"
        }
        Text {
            color: Theme.primary
            font.family: Theme.icons
            font.pixelSize: Theme.fontIcon
            opacity: Theme.opacityMuted
            text: "󰍛"
        }
    }
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: statsColumn.implicitHeight + 28
        border.color: Theme.outline_variant
        border.width: 1
        color: Theme.surface_container
        radius: Theme.radiusCard

        ColumnLayout {
            id: statsColumn

            anchors.fill: parent
            anchors.margins: 18
            spacing: Theme.spacingSection

            StatBar {
                icon: "󰻠"
                label: "CPU · busiest thread"
                value: Services.System.cpuPeak
            }
            StatBar {
                icon: "󰻠"
                label: "CPU · all"
                value: Services.System.cpu
            }
            Rectangle {
                Layout.fillWidth: true
                color: Theme.outline_variant
                implicitHeight: 1
            }
            StatBar {
                icon: "󰍛"
                label: "RAM"
                value: Services.System.ram
            }
            Rectangle {
                Layout.fillWidth: true
                color: Theme.outline_variant
                implicitHeight: 1
            }
            StatBar {
                icon: "󰋊"
                label: "Disk"
                value: Services.System.disk
            }
            Rectangle {
                Layout.fillWidth: true
                color: Theme.outline_variant
                implicitHeight: 1
            }
            StatBar {
                icon: "󰔏"
                label: "Temp"
                maxValue: 100
                suffix: "°C"
                value: Services.System.temp
            }
        }
    }
}
