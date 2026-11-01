import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services as Services
import qs.theme

Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 100
    color: "transparent"

    gradient: Gradient {
        GradientStop {
            color: Theme.primary_container
            position: 0
        }
        GradientStop {
            color: Qt.darker(Theme.primary_container, 1.1)
            position: 1
        }
    }

    Rectangle {
        anchors.right: parent.right
        color: Theme.secondary_container
        height: parent.height
        opacity: 0.1
        width: parent.width * 0.4
    }
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Theme.paddingLarge
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacingWide

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingCompact

                Text {
                    color: Theme.on_primary_container
                    font.letterSpacing: -0.5
                    font.pixelSize: Theme.fontDisplay
                    font.weight: Font.Bold
                    text: "Control Center"
                }
                Text {
                    color: Theme.on_primary_container
                    font.pixelSize: Theme.fontMedium
                    font.weight: Font.Medium
                    opacity: Theme.opacitySecondary
                    text: Services.Time.format(Config.dateTimeFormat)
                }
            }
        }
    }
}
