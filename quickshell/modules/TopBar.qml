import QtQuick
import QtQuick.Layouts
import qs.modules.bar
import qs.theme

Item {
    id: topBar

    anchors.left: parent.left
    anchors.right: parent.right
    focus: true
    implicitHeight: Theme.barHeight

    Item {
        anchors.fill: parent

        RowLayout {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.spacingNormal

            Item {
                implicitWidth: Theme.spacingNormal
            }
            Workspaces {}
            Keyboard {}
            Clock {}
        }
        RowLayout {
            anchors.centerIn: parent

            MediaPill {}
        }
        RowLayout {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.spacingMedium

            Battery {}
            Cpu {}
            Memory {}
            Volume {}
            SystemTray {}
            Item {
                implicitWidth: Theme.spacingNormal
            }
        }
    }
}
