import QtQuick
import Quickshell
import qs.modules
import qs.modules.control
import Quickshell.Io
import qs.services as Services
import Quickshell.Wayland
import Quickshell.Hyprland

ShellRoot {
    id: root
    property bool barVisible: true
    Notifications {}
    PanelWindow {
        id: rootPanel
        exclusionMode: ExclusionMode.Ignore
        implicitHeight: screen.height
        implicitWidth: screen.width
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        color: "transparent"
        focusable: false

        PanelWindow {
            implicitHeight: barVisible ? topBar.height : 0
            // implicitHeight: 0
            implicitWidth: 0
            anchors {
                top: true
            }
            color: "transparent"
            mask: rootPanel.mask
            focusable: false
        }

        TopBar {
            id: topBar
            y: root.barVisible ? 0 : -height
            opacity: root.barVisible ? 1 : 0

            Behavior on y {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutCubic
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Loader {
            id: controlCenterLoader
            active: false
            anchors.fill: parent
            sourceComponent: ControlCenter {
                id: controlCenter
            }
            focus: true
        }

        mask: Region {
            Region {
                x: topBar.x
                y: Math.max(0, topBar.y)
                width: topBar.width
                height: topBar.height + Math.min(0, topBar.y)
            }

            Region {
                item: controlCenterLoader.item && controlCenterLoader.item.visible ? controlCenterLoader.item : null
            }
        }
    }

    IpcHandler {
        target: "ctrl"
        function toggle(): void {
            if (!controlCenterLoader.active) {
                controlCenterLoader.active = true;
                controlCenterLoader.item.opened = true;
            } else {
                controlCenterLoader.item.opened = !controlCenterLoader.item.opened;
            }
        }
    }

    IpcHandler {
        target: "bar"
        function toggle(): void {
            root.barVisible = !root.barVisible;
        }
        function show(): void {
            root.barVisible = true;
        }
        function hide(): void {
            root.barVisible = false;
        }
    }
}
