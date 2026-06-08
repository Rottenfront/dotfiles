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
    Notifications {}
    // PanelWindow {
    //     focusable: true
    //     WlrLayershell.layer: WlrLayer.Bottom
    //     exclusionMode: ExclusionMode.Ignore
    //     WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    //     color: "transparent"
    //     anchors {
    //         left: true
    //         right: true
    //         top: true
    //         bottom: true
    //     }
    // }
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
            implicitHeight: 36
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
        }

        Loader {
            active: false
            id: controlCenterLoader
            anchors.fill: parent
            sourceComponent: ControlCenter {
                id: controlCenter
            }
            focus: true
        }

        mask: Region {
            Region {
                item: topBar
            }

            Region{
                item: controlCenterLoader.item && controlCenterLoader.item.visible ? controlCenterLoader.item : null
            }
        }
    }


    IpcHandler {
        target: "ctrl"
        function changeVisible(): void {
            if (!controlCenterLoader.active) {
                controlCenterLoader.active = true
                controlCenterLoader.item.opened = true
            } else {
                controlCenterLoader.item.opened = !controlCenterLoader.item.opened
            }
        }
    }
}
