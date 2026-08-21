import QtQuick
import Quickshell
import qs.modules
import Quickshell.Io
import qs.services as Services
import Quickshell.Wayland
import Quickshell.Hyprland

ShellRoot {
    id: root
    NotificationWidget {}

    Visualizer {
        id: musicVis
    }

    OsdWindow {}

    TopBar {
        id: topBar
    }

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
            item: controlCenterLoader.item && controlCenterLoader.item.visible ? controlCenterLoader.item : null
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
        target: "musicVis"
        function toggle(): void {
            musicVis.visible = !musicVis.visible;
        }
    }

    IpcHandler {
        target: "bar"
        function toggle(): void {
            topBar.barVisible = !topBar.barVisible;
        }
        function show(): void {
            topBar.barVisible = true;
        }
        function hide(): void {
            topBar.barVisible = false;
        }
    }
}
