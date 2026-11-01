import QtQuick
import qs.theme

Rectangle {
    id: root

    property bool opened: false

    clip: true
    color: "transparent"
    height: opened ? parent.height / 2 : 0
    width: parent.width

    Behavior on height {
        NumberAnimation {
            duration: 1000
            easing.type: Easing.OutCubic
        }
    }

    Repeater {
        model: {
            const min = 20
            const max = 50
            return Math.floor(Math.random() * (max - min + 1)) + min
        }

        Rectangle {
            id: shingle

            // Base height ratio stored at creation time
            property real baseHeightRatio: {
                const min = 70
                const max = root.parent.height / 2 - 40
                const range = max - min
                return (Math.floor(Math.random() * (range - 1)) + 1) / (root.parent.height / 2)
            }

            // Base X position stored once at creation
            property real baseX: {
                const min = 20
                const max = root.width - 10
                return Math.floor(Math.random() * (max - min)) + min
            }
            property real hAmplitude: Math.random() * 6 + 2          // horizontal (px)
            property real hOffset: 0.0

            // Per-shingle random wave characteristics
            property real vAmplitude: Math.random() * 0.07 + 0.03   // vertical (ratio)
            property real vOffset: 0.0

            bottomLeftRadius: width / 2
            bottomRightRadius: width / 2
            color: Theme.surface_container
            height: (baseHeightRatio + vOffset) * root.height
            width: 3
            x: baseX + hOffset

            // ── Continuous horizontal sway ────────────────────────────────
            SequentialAnimation on hOffset {
                id: hWave

                loops: Animation.Infinite
                running: false

                PauseAnimation {
                    duration: Math.random() * 700
                }
                NumberAnimation {
                    duration: 700 + Math.random() * 700
                    easing.type: Easing.InOutSine
                    from: 0
                    to: shingle.hAmplitude
                }
                NumberAnimation {
                    duration: 900 + Math.random() * 600
                    easing.type: Easing.InOutSine
                    from: shingle.hAmplitude
                    to: -shingle.hAmplitude
                }
                NumberAnimation {
                    duration: 600 + Math.random() * 400
                    easing.type: Easing.InOutSine
                    from: -shingle.hAmplitude
                    to: 0
                }
            }

            // ── Continuous vertical wave ──────────────────────────────────
            SequentialAnimation on vOffset {
                id: vWave

                loops: Animation.Infinite
                running: false

                PauseAnimation {
                    duration: Math.random() * 900
                }
                NumberAnimation {
                    duration: 550 + Math.random() * 550
                    easing.type: Easing.InOutSine
                    from: 0
                    to: shingle.vAmplitude
                }
                NumberAnimation {
                    duration: 480 + Math.random() * 480
                    easing.type: Easing.InOutSine
                    from: shingle.vAmplitude
                    to: -shingle.vAmplitude * 0.45
                }
                NumberAnimation {
                    duration: 380 + Math.random() * 380
                    easing.type: Easing.InOutSine
                    from: -shingle.vAmplitude * 0.45
                    to: 0
                }
            }

            // ── One-shot drop ripple on open (vertical bounce + horizontal burst) ──
            SequentialAnimation {
                id: dropRipple

                PauseAnimation {
                    duration: Math.random() * 450
                }
                ParallelAnimation {
                    NumberAnimation {
                        duration: 750 + Math.random() * 400
                        easing.type: Easing.OutBounce
                        from: shingle.vAmplitude * 1.8
                        property: "vOffset"
                        target: shingle
                        to: 0
                    }
                    NumberAnimation {
                        duration: 800 + Math.random() * 400
                        easing.type: Easing.OutElastic
                        from: shingle.hAmplitude * (Math.random() > 0.5 ? 1.5 : -1.5)
                        property: "hOffset"
                        target: shingle
                        to: 0
                    }
                }
                ScriptAction {
                    script: {
                        vWave.start()
                        hWave.start()
                    }
                }
            }
            Connections {
                function onOpenedChanged() {
                    if (root.opened) {
                        dropRipple.start()
                    } else {
                        vWave.stop()
                        hWave.stop()
                        dropRipple.stop()
                        shingle.vOffset = 0
                        shingle.hOffset = 0
                    }
                }

                target: root
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: text === "󰽧" ? -5.6 : 0
                anchors.top: parent.bottom
                anchors.topMargin: text === "󰽧" ? -5 : -3
                color: Theme.primary
                font.family: Theme.symbols
                font.pointSize: text === "󰽧" ? 28 : 25
                rotation: text === "󰽧" ? 45 : 0
                text: {
                    const options = ["󰽧", ""]
                    return options[Math.floor(Math.random() * options.length)]
                }
            }
        }
    }
}
