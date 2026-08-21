import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar

PanelWindow {
    id: root
    property bool barVisible: true

    anchors {
        top: true
        left: true
        right: true
    }
    color: "transparent"
    focusable: false

    implicitHeight: barVisible ? topBar.height : 0

    Item {
        id: topBar

        visible: root.barVisible

        implicitHeight: 34
        anchors.left: parent.left
        anchors.right: parent.right
        focus: true

        y: root.barVisible ? 0 : -height

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
            Keyboard {}
            Clock {}
        }

        RowLayout {
            MediaPill {}

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
            spacing: 8
            Battery {}
            // Network {}
            // Bluetooth {}
            Cpu {}
            Memory {}
            Volume {}
            SystemTray {}
            Rectangle {
                implicitWidth: 8
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.InOutQuad
            }
        }
    }
    mask: Region {
        x: topBar.x
        y: Math.max(0, topBar.y)
        width: topBar.width
        height: topBar.height + Math.min(0, topBar.y)
    }
}
