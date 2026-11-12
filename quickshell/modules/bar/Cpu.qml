import QtQuick
import QtQuick.Controls as Controls
import Quickshell.Io
import qs.components
import qs.config
import qs.services as Services
import qs.theme

Rectangle {
    id: root

    border.color: Theme.outline
    border.width: 1
    color: Theme.surface_container
    implicitHeight: Theme.barWidgetHeight
    implicitWidth: cpu.implicitWidth + Theme.barPaddingCompact
    radius: Theme.radiusPill

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: toggleProc.running = true
    }
    Controls.ToolTip {
        parent: root
        x: (root.width - implicitWidth) / 2
        y: root.height + Theme.spacingSmall
        visible: mouseArea.containsMouse
        delay: 400
        timeout: -1
        padding: Theme.spacingLarge

        contentItem: Text {
            color: Theme.on_surface
            font.family: Theme.mono
            font.pixelSize: Theme.fontBody
            textFormat: Text.PlainText
            text: "Logical CPU usage\n" + (Services.System.cpuCores.length === 0
                ? "Collecting samples…"
                : Services.System.cpuCores.map(function(core) {
                    return "CPU " + core.id + ": " + (core.usage === null ? "—" : Math.round(core.usage) + "%")
                }).join("\n"))
        }
        background: Rectangle {
            color: Theme.surface_container
            opacity: Theme.windowOpacity
            border.color: Theme.outline
            border.width: 1
            radius: Theme.radiusCompact
        }
    }
    Text {
        id: cpu

        anchors.centerIn: parent
        color: Theme.on_surface
        font.family: Theme.mono
        font.pixelSize: Theme.size
        text: "CPU S " + Math.round(Services.System.cpuPeak) + "% | ALL " + Math.round(Services.System.cpu) + "%"
    }
    Process {
        id: toggleProc

        command: Config.toggleControlCenter
    }
}
