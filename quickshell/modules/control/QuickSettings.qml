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
            font.family: Theme.sans
            font.letterSpacing: Theme.sectionLetterSpacing
            font.pixelSize: Theme.fontHeading
            font.weight: Font.DemiBold
            text: "Quick Settings"
        }
        Text {
            color: Theme.primary
            font.family: Theme.icons
            font.pixelSize: Theme.fontIcon
            opacity: Theme.opacityMuted
            text: "󰒓"
        }
    }
    GridLayout {
        Layout.fillWidth: true
        columnSpacing: Theme.spacingLarge
        columns: 3
        rowSpacing: Theme.spacingLarge

        ToggleTile {
            active: Services.Network.wifiEnabled
            icon: Services.Network.icon
            label: "Wi-Fi"

            onClicked: Services.Network.toggleWifi()
        }
        ToggleTile {
            active: Services.Bluetooth.defaultAdapter?.enabled ?? false
            icon: "󰂯"
            label: "Bluetooth"

            onClicked: {
                const adapter = Services.Bluetooth.defaultAdapter
                if (adapter)
                    adapter.enabled = !adapter.enabled
            }
        }
        ToggleTile {
            active: Services.Notifications.dnd
            icon: "󰂛"
            label: "DND"

            onClicked: Services.Notifications.dnd = !Services.Notifications.dnd
        }
    }
}
