import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.modules.bar
import qs.services

PanelWindow {
    id: topBar

    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "osd"
    color: "transparent"

    mask: Region {
        Region {
            item: volBar
        }
        Region {
            item: brightnessBar
        }
    }

    anchors {
        bottom: true
        left: true
        top: true
    }
    VerticalBar {
        id: volBar

        icon: Volume.muted ? Icons.volumeMuted : Volume.volume > 0.4 ? Icons.volumeMedium : Icons.volumeLow
        maxValue: 1
        opacity: Osd.volVisible ? 1 : 0
        value: Volume.volume
        x: Osd.volVisible ? 4 : -width
        y: (parent.height - height) / 2
    }
    VerticalBar {
        id: brightnessBar

        icon: Icons.brightness
        maxValue: 100
        opacity: Osd.brightnessVisible ? 1 : 0
        value: System.brightness
        x: Osd.brightnessVisible ? 4 : -width
        y: (parent.height - height) / 2
    }
}
