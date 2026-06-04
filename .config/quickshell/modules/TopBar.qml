import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar_components

Item {
    id: topBar

    implicitHeight: 42
    anchors.left: parent.left
    anchors.right: parent.right
    focus: true

    Item {
        anchors.fill: parent

        RowLayout {
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            Rectangle {
                implicitWidth: 8
            }
            spacing: 8
            Workspaces {}
            MediaPill {}
        }
        RowLayout {
            Clock {}

            anchors {
                centerIn: parent
                verticalCenter: parent.verticalCenter
            }
        }

        RowLayout {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            spacing: 10
            // Battery {}
            // Network {}
            // Bluetooth {}
            Cpu {}
            Memory {}
            Volume {}
            Keyboard {}
            Date {}
            SystemTray {}
            Rectangle {
                implicitWidth: 8
            }
        }
    }
}
