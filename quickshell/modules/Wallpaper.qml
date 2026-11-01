import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config

PanelWindow {
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.layer: WlrLayer.Background
    exclusionMode: ExclusionMode.Ignore

    anchors {
        bottom: true
        left: true
        right: true
        top: true
    }
    Image {
        fillMode: Image.PreserveAspectFit
        source: Config.wallpaper
        verticalAlignment: Image.AlignBottom
    }
}
