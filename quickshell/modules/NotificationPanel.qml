import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.services as Services
import qs.theme

PanelWindow {
    contentItem.opacity: Theme.windowOpacity
    id: root

    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: Services.Panels.notificationsOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "notification-center"
    color: "transparent"
    screen: Quickshell.screens.find(screen => screen.name === Services.Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0] ?? null
    visible: center.opened || center.slideProgress > 0

    anchors {
        bottom: true
        left: true
        right: true
        top: true
    }
    NotificationCenter {
        id: center
    }
}
