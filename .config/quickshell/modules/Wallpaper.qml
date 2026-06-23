import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import qs.theme

PanelWindow {
    id: wallpaper

    WlrLayershell.layer: WlrLayer.Background
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        left: true
        right: true
        bottom: true
        top: true
    }

    Image {
        // anchors {
        //     left: true
        //     right: true
        //     bottom: true
        //     top: true
        // }
        fillMode: Image.PreserveAspectFit
        verticalAlignment: Image.AlignBottom
        source: Theme.wallpaper
    }
}
