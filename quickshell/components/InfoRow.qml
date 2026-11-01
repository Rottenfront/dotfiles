import QtQuick
import QtQuick.Layouts
import qs.theme

RowLayout {
    id: root

    required property string icon
    required property string label
    required property string value

    Layout.fillWidth: true
    spacing: Theme.spacingSection

    Rectangle {
        Layout.preferredHeight: Theme.iconBadgeSize
        Layout.preferredWidth: Theme.iconBadgeSize
        color: Theme.tertiary_container
        radius: Theme.radiusNormal

        Text {
            anchors.centerIn: parent
            color: Theme.on_tertiary_container
            font.family: Theme.icons
            font.pixelSize: Theme.fontIconMedium
            text: root.icon
        }
    }
    Text {
        Layout.fillWidth: true
        color: Theme.on_surface_variant
        font.pixelSize: Theme.fontMedium
        font.weight: Font.Medium
        text: root.label
    }
    Text {
        color: Theme.on_surface
        font.pixelSize: Theme.fontMedium
        font.weight: Font.Bold
        text: root.value
    }
}
