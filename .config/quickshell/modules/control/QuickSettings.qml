import Quickshell
import qs.components
import QtQuick.Layouts
import Quickshell.Io
import QtQuick
import qs.theme
import qs.services as Services

ColumnLayout {
    id: quickSettings
    Layout.fillWidth: true
    Layout.leftMargin: 20
    Layout.rightMargin: 20
    Layout.topMargin: 20
    spacing: 14

    property bool dndEnabled: false
    property bool nightLightEnabled: false
    property bool airplaneModeEnabled: false

    RowLayout {
        Layout.fillWidth: true
        Text {
            Layout.fillWidth: true
            text: "Quick Settings"
            font.family: Theme.sans
            font.pixelSize: 15
            font.weight: Font.DemiBold
            font.letterSpacing: 0.3
            color: Theme.on_surface
        }

        Text {
            text: "󰒓"
            font.family: "Material Design Icons"
            font.pixelSize: 16
            color: Theme.primary
            opacity: 0.6
        }
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 3
        columnSpacing: 12
        rowSpacing: 12

        ToggleTile {
            label: "Wi-Fi"
            icon: Services.Network.icon
            active: Services.Network.wifiEnabled
            onClicked: Services.Network.toggleWifi()
        }

        ToggleTile {
            label: "Bluetooth"
            icon: "󰂯"
            active: Services.Bluetooth.defaultAdapter?.enabled ?? false
            onClicked: Services.Bluetooth.defaultAdapter.enabled = !Services.Bluetooth.defaultAdapter.enabled
        }

        ToggleTile {
            label: "DND"
            icon: "󰂛"
            active: dndEnabled
            onClicked: {
                quickSettings.dndEnabled = !dndEnabled
                Services.Notifications.dnd = !Services.Notifications.dnd
            }
        }
    }
}
