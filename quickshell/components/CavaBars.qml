import QtQuick
import qs.services as Services
import qs.theme

Item {
    id: root

    property int barCount: Services.Cava.barsCount
    property real corner: 2
    property bool enableShadow: true
    property real spacing: 3

    implicitHeight: 42
    implicitWidth: 320

    Services.CavaRequest {
        active: root.visible
    }
    Row {
        anchors.fill: parent
        spacing: root.spacing

        Repeater {
            model: Services.Cava.values

            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                height: Math.max(2, modelData * root.height)
                radius: root.corner
                width: Math.max(2, root.width / barCount - root.spacing)

                // Simplified gradient (slightly faster)
                gradient: Gradient {
                    GradientStop {
                        color: Theme.primary_container
                        position: 0
                    }
                    GradientStop {
                        color: Theme.primary
                        position: 1
                    }
                }

                // Disable height animations - they cause repaints
                // The values update fast enough that animation isn't needed
            }
        }
    }
}
