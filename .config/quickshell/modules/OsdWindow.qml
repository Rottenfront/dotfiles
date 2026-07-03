import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.bar
import qs.components
import qs.services

Item {
    id: topBar

    implicitWidth: 48
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    focus: false

    VerticalBar {
        opacity: Osd.volVisible ? 1 : 0
        x: Osd.volVisible ? 4 : -width
        y: (parent.height - height) / 2
        value: Volume.volume
        maxValue: 1
        icon: Volume.muted ? Icons.volumeMuted : Volume.volume > 0.4 ? Icons.volumeMedium : Icons.volumeLow
    }

    VerticalBar {
        opacity: Osd.brightnessVisible ? 1 : 0
        x: Osd.brightnessVisible ? 4 : -width
        y: (parent.height - height) / 2
        value: System.brightness
        maxValue: 100
        icon: Icons.brightness
    }
}
