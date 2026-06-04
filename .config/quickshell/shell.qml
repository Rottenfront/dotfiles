import QtQuick
import Quickshell
import qs.modules
import Quickshell.Io
import qs.services as Services
import Quickshell.Wayland
import Quickshell.Hyprland

ShellRoot {
    id: root
    Notifications {}
    PanelWindow {
        focusable: true
        WlrLayershell.layer: WlrLayer.Bottom
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        color: "transparent"
        anchors {
            left: true
            right: true
            top: true
            bottom: true
        }
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

        mask: Region {
            Region {
                item: topBar
            }
        }
    }
}
