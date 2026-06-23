import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import qs.theme

PanelWindow {
    id: musicVis

    property bool anchorBottom: false
    property bool flipped: !anchorBottom

    implicitHeight: 500
    visible: false
    color: "transparent"

    WlrLayershell.layer: WlrLayer.Bottom
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        left: true
        right: true
        bottom: anchorBottom
        top: !anchorBottom
    }

    Process {
        id: cavaProc
        running: musicVis.visible

        command: ["sh", "-c", `
            cava -p /dev/stdin <<EOF
[general]
bars = 100
framerate = 30
autosens = 1

[input]
method = pipewire

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 1000
bar_delimiter = 59

[smoothing]
monstercat = 1.5
waves = 0
gravity = 100
noise_reduction = 0.20
EOF
        `]

        stdout: SplitParser {
            onRead: data => {
                let newPoints = data.split(";")
                    .map(p => parseFloat(p.trim()) / 1000)
                    .filter(p => !isNaN(p))

                let smoothFactor = 0.3

                if (canvas.cavaData.length === 0 ||
                    canvas.cavaData.length !== newPoints.length) {
                    canvas.cavaData = newPoints
                } else {
                    let smoothed = []
                    for (let i = 0; i < newPoints.length; i++) {
                        let oldVal = canvas.cavaData[i]
                        let newVal = newPoints[i]
                        smoothed.push(oldVal + (newVal - oldVal) * smoothFactor)
                    }
                    canvas.cavaData = smoothed
                }

                canvas.requestPaint()
            }
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        property var cavaData: []

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            drawBars(ctx, cavaData, true)
            drawBars(ctx, cavaData, false)
        }

        function drawBars(ctx, data, isShadow) {
            if (data.length === 0) return

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

            for (var i = 0; i < data.length; i++) {
                var barHeight = data[i] * height
                var x = i * (barWidth + gap)
                
                // Calculate Y position and height depending on orientation
                var y = flipped ? 0 : height - barHeight

                // Optional: Round the corners of the bars for a modern look
                // Replace ctx.fillRect with custom rounded rect logic if preferred
                ctx.fillRect(x, y, barWidth, barHeight)
            }

            ctx.restore()
        }
    }
}
