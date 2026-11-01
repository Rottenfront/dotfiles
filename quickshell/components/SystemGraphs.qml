import QtQuick
import qs.components
import qs.services as Services
import qs.theme

Item {
    height: 120
    width: 380

    Row {
        anchors.centerIn: parent
        spacing: Theme.spacingLarge

        Repeater {
            model: [
                {
                    label: "CPU",
                    value: Services.System.cpu,
                    color: Theme.error
                },
                {
                    label: "RAM",
                    value: Services.System.ram,
                    color: Theme.primary
                },
                {
                    label: "DISK",
                    value: Services.System.disk,
                    color: Theme.tertiary
                }
            ]

            Rectangle {
                required property var modelData

                color: Theme.surface_container_high
                height: Theme.statCardHeight
                radius: Theme.radiusLarge
                width: Theme.statCardWidth

                SemiCircularGraph {
                    anchors.centerIn: parent
                    fillColor: parent.modelData.color
                    height: Theme.statGraphHeight
                    label: parent.modelData.label
                    value: parent.modelData.value
                    width: Theme.statGraphWidth
                }
            }
        }
    }
}
