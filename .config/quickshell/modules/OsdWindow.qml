import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar
import qs.components
import qs.services
import Quickshell.Wayland

PanelWindow {
    id: topBar

    required property ShellScreen modelData
    screen: modelData

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "osd"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    color: "transparent"

    anchors {
        top: true
        left: true
        bottom: true
    }

    mask: Region {
        Region {
            item: volBar
        }
        Region {
            item: brightnessBar
        }
    }

    VerticalBar {
        id: volBar
        opacity: Osd.volVisible ? 1 : 0
        x: Osd.volVisible ? 4 : -width
        y: (parent.height - height) / 2
        value: Volume.volume
        maxValue: 1
        icon: Volume.muted ? Icons.volumeMuted : Volume.volume > 0.4 ? Icons.volumeMedium : Icons.volumeLow
    }

    VerticalBar {
        id: brightnessBar
        opacity: Osd.brightnessVisible ? 1 : 0
        x: Osd.brightnessVisible ? 4 : -width
        y: (parent.height - height) / 2
        value: System.brightness
        maxValue: 100
        icon: Icons.brightness
    }
}
