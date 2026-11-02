import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services as Services
import qs.theme

PanelWindow {
    id: root

    property string layoutName: ""

    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "keyboard-osd"
    anchors.top: true
    color: "transparent"
    implicitHeight: label.implicitHeight + Theme.paddingLarge * 2
    implicitWidth: Math.min(label.implicitWidth + Theme.paddingLarge * 2, (screen?.width ?? 640) - Theme.paddingLarge * 2)
    margins.top: Theme.barHeight + Theme.spacingLarge
    screen: Quickshell.screens.find(screen => screen.name === Services.Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0] ?? null
    visible: false

    mask: Region {}

    Rectangle {
        anchors.fill: parent
        border.color: Theme.outline_variant
        border.width: 1
        color: Theme.surface_container
        radius: Theme.radiusPanel

        Text {
            id: label

            anchors.centerIn: parent
            color: Theme.on_surface
            font.family: Theme.mono
            font.pixelSize: Theme.fontTitle
            horizontalAlignment: Text.AlignHCenter
            text: root.layoutName
            textFormat: Text.PlainText
            width: parent.width - Theme.paddingLarge * 2
            wrapMode: Text.Wrap
        }
    }
    Timer {
        id: hideTimer

        interval: Config.osdTimeout

        onTriggered: root.visible = false
    }
    Connections {
        function onLayoutChanged(layoutName: string): void {
            root.layoutName = layoutName
            root.visible = true
            hideTimer.restart()
        }

        target: Services.Hyprland
    }
}
