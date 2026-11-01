import QtQuick
import QtQuick.Layouts
import qs.components
import qs.theme

ColumnLayout {
    id: root

    signal commandRequested(var command)

    Layout.bottomMargin: 30
    Layout.fillWidth: true
    Layout.leftMargin: Theme.paddingSection
    Layout.rightMargin: Theme.paddingSection
    Layout.topMargin: Theme.paddingSection
    spacing: Theme.spacingSection

    RowLayout {
        Layout.fillWidth: true

        Text {
            Layout.fillWidth: true
            color: Theme.error
            font.letterSpacing: Theme.sectionLetterSpacing
            font.pixelSize: Theme.fontHeading
            font.weight: Font.DemiBold
            text: "Power Options"
        }
        Text {
            color: Theme.on_primary_container
            font.family: Theme.icons
            font.pixelSize: Theme.fontIcon
            opacity: Theme.opacityMuted
            text: "󰐥"
        }
    }
    GridLayout {
        Layout.fillWidth: true
        columnSpacing: Theme.spacingSection
        columns: 2
        rowSpacing: Theme.spacingSection

        ActionButton {
            buttonColor: Theme.error_container
            icon: "󰐥"
            label: "Power Off"

            onClicked: root.commandRequested(["systemctl", "poweroff"])
        }
        ActionButton {
            buttonColor: Theme.primary_container
            icon: "󰜉"
            label: "Restart"

            onClicked: root.commandRequested(["systemctl", "reboot"])
        }
        ActionButton {
            buttonColor: Theme.secondary_container
            icon: "󰒲"
            label: "Sleep"

            onClicked: root.commandRequested(["systemctl", "suspend"])
        }
        ActionButton {
            buttonColor: Theme.tertiary_container
            icon: "󰍃"
            label: "Log Out"

            onClicked: root.commandRequested(["sh", "-c", "loginctl terminate-user \"$USER\""])
        }
    }
}
