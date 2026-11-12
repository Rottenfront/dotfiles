import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services as Services
import qs.theme

PanelWindow {
    contentItem.opacity: Theme.windowOpacity
    id: musicVis

    property bool anchorBottom: false
    property bool flipped: !anchorBottom

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.layer: WlrLayer.Bottom
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    implicitHeight: 500
    visible: false

    anchors {
        bottom: anchorBottom
        left: true
        right: true
        top: !anchorBottom
    }
    Services.CavaRequest {
        active: musicVis.visible
    }
    Connections {
        function onValuesChanged() {
            const points = Services.Cava.values
            const factor = Math.max(0, Math.min(1, Config.cavaSmoothingFactor))
            if (canvas.cavaData.length !== points.length) {
                canvas.cavaData = points
            } else {
                canvas.cavaData = points.map((value, index) => canvas.cavaData[index] + (value - canvas.cavaData[index]) * factor)
            }
            canvas.requestPaint()
        }

        enabled: musicVis.visible
        target: Services.Cava
    }
    Canvas {
        id: canvas

        property var cavaData: []

        function drawBars(ctx, data, isShadow) {
            if (data.length === 0)
                return
            var gradient = ctx.createLinearGradient(0, 0, width, height)
            gradient.addColorStop(0.0, Theme.primary)
            gradient.addColorStop(0.5, Theme.tertiary)
            gradient.addColorStop(1.0, Theme.secondary)

            ctx.save()

            if (isShadow) {
                ctx.globalAlpha = 0.25
                ctx.translate(0, flipped ? 10 : -10)
                // A subtle upscale for the shadow layout
                ctx.scale(1.01, 1.0)
            } else {
                ctx.globalAlpha = 1.0
            }

            ctx.fillStyle = gradient

            // CONFIGURATION: Adjust spacing between bars
            var gap = 2
            var totalGapsWidth = gap * (data.length - 1)
            var barWidth = (width - totalGapsWidth) / data.length

            for (let i = 0; i < data.length; i++) {
                const barHeight = data[i] * height
                const x = i * (barWidth + gap)
                const y = flipped ? 0 : height - barHeight

                ctx.fillRect(x, y, barWidth, barHeight)
            }

            ctx.restore()
        }

        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            drawBars(ctx, cavaData, true)
            drawBars(ctx, cavaData, false)
        }
    }
}
