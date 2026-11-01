import QtQuick
import Quickshell.Io
import qs.config
import qs.theme

Item {
    id: root

    function close() {
        backdrop.opacity = 0
        lockOrb.opacity = 0
        logoutOrb.opacity = 0
        rebootOrb.opacity = 0
        powerOrb.opacity = 0
        header.opacity = 0
        hintText.opacity = 0
        closeTimer.restart()
    }

    // ── Open / Close ─────────────────────────────────────────────────────────

    function open() {
        visible = true
        forceActiveFocus()

        // reset
        lockOrb.opacity = 0
        logoutOrb.opacity = 0
        rebootOrb.opacity = 0
        powerOrb.opacity = 0
        hintText.opacity = 0
        header.opacity = 0
        backdrop.opacity = 1

        // staggered entrance
        lockOrb.enter(60)
        logoutOrb.enter(140)
        rebootOrb.enter(220)
        powerOrb.enter(300)

        header.opacity = 1
        hintDelay.restart()
    }

    anchors.fill: parent
    focus: true
    visible: false

    // ── Keyboard ──────────────────────────────────────────────────────────────

    Keys.onEscapePressed: close()

    // ── Process ───────────────────────────────────────────────────────────────

    Process {
        id: proc
    }

    // ── Backdrop ─────────────────────────────────────────────────────────────

    Rectangle {
        id: backdrop

        anchors.fill: parent
        opacity: 0

        gradient: Gradient {
            orientation: Gradient.Vertical

            GradientStop {
                color: Qt.rgba(0, 0, 0, 0.88)
                position: 0.0
            }
            GradientStop {
                color: Qt.rgba(0, 0, 0, 0.74)
                position: 0.42
            }
            GradientStop {
                color: Qt.rgba(0, 0, 0, 0.88)
                position: 1.0
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 260
                easing.type: Easing.OutCubic
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: root.close()
        }
    }

    // ── Header label ─────────────────────────────────────────────────────────

    Column {
        id: header

        anchors.bottom: orbRow.top
        anchors.bottomMargin: 52
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: 0
        spacing: Theme.spacingNormal

        Behavior on opacity {
            NumberAnimation {
                duration: Theme.durationMedium
                easing.type: Easing.OutCubic
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Qt.rgba(1, 1, 1, 0.22)
            font.family: Theme.icons
            font.pixelSize: Theme.fontTitle
            text: "󰐥"
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Qt.rgba(1, 1, 1, 0.25)
            font.letterSpacing: 4.0
            font.pixelSize: Theme.fontSmall
            font.weight: Font.Medium
            text: "POWER MENU"
        }
    }

    // ── Orb row ───────────────────────────────────────────────────────────────

    Row {
        id: orbRow

        anchors.centerIn: parent
        anchors.verticalCenterOffset: -20
        spacing: 44

        PowerOrb {
            id: lockOrb

            glowColor: Theme.secondary
            icon: "󰌾"
            label: "Lock"

            onActivated: {
                root.close()
                proc.exec(["quickshell", "-p", Config.lockScreen])
            }
        }
        PowerOrb {
            id: logoutOrb

            glowColor: Theme.tertiary
            icon: "󰍃"
            label: "Logout"

            onActivated: {
                root.close()
                proc.exec(["bash", "-c", "sleep " + Config.powerActionDelay + " && loginctl terminate-user $USER"])
            }
        }
        PowerOrb {
            id: rebootOrb

            glowColor: Theme.primary
            icon: "󰜉"
            label: "Reboot"

            onActivated: {
                root.close()
                proc.exec(["bash", "-c", "sleep " + Config.powerActionDelay + " && systemctl reboot"])
            }
        }
        PowerOrb {
            id: powerOrb

            glowColor: Theme.error
            icon: "󰐥"
            label: "Power Off"

            onActivated: {
                root.close()
                proc.exec(["bash", "-c", "sleep " + Config.powerActionDelay + " && systemctl poweroff"])
            }
        }
    }

    // ── Hint ─────────────────────────────────────────────────────────────────

    Text {
        id: hintText

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 52
        anchors.horizontalCenter: parent.horizontalCenter
        color: Qt.rgba(1, 1, 1, 0.2)
        font.letterSpacing: 2.5
        font.pixelSize: Theme.fontCaption
        font.weight: Font.Light
        opacity: 0
        text: "ESC TO CANCEL"

        Behavior on opacity {
            NumberAnimation {
                duration: 400
            }
        }
    }

    // ── Hint timer ────────────────────────────────────────────────────────────

    Timer {
        id: hintDelay

        interval: 420

        onTriggered: hintText.opacity = 1
    }

    // ── Close timer ───────────────────────────────────────────────────────────

    Timer {
        id: closeTimer

        interval: 280

        onTriggered: root.visible = false
    }

    // ── Inline orb component ─────────────────────────────────────────────────

    component PowerOrb: Item {
        id: orb

        required property color glowColor
        property bool hovered: false
        required property string icon
        property bool isPressed: false
        required property string label

        signal activated

        function enter(delayMs) {
            enterDelay.interval = delayMs
            enterDelay.start()
        }

        height: 168
        opacity: 0
        width: 124

        Timer {
            id: enterDelay

            onTriggered: {
                orb.y = 24
                slideIn.restart()
            }
        }
        ParallelAnimation {
            id: slideIn

            NumberAnimation {
                duration: 380
                easing.type: Easing.OutCubic
                property: "opacity"
                target: orb
                to: 1
            }
            NumberAnimation {
                duration: 420
                easing.type: Easing.OutCubic
                property: "y"
                target: orb
                to: 0
            }
        }

        // Outer glow ring (visible on hover)
        Rectangle {
            anchors.centerIn: circle
            border.color: Qt.rgba(orb.glowColor.r, orb.glowColor.g, orb.glowColor.b, orb.hovered ? 0.28 : 0)
            border.width: 1
            color: "transparent"
            height: circle.height + 24
            radius: width / 2
            scale: orb.hovered ? 1 : 0.8
            width: circle.width + 24

            Behavior on border.color {
                ColorAnimation {
                    duration: 200
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutCubic
                }
            }
        }

        // Main circle
        Rectangle {
            id: circle

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            border.color: Qt.rgba(orb.glowColor.r, orb.glowColor.g, orb.glowColor.b, orb.hovered ? 0.8 : 0.3)
            border.width: 1.5
            color: Qt.rgba(orb.glowColor.r, orb.glowColor.g, orb.glowColor.b, orb.isPressed ? 0.35 : orb.hovered ? 0.22 : 0.1)
            height: 96
            radius: 48
            scale: orb.isPressed ? 0.86 : orb.hovered ? 1.1 : 1.0
            width: 96

            Behavior on border.color {
                ColorAnimation {
                    duration: Theme.durationHover
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: Theme.durationHover
                }
            }
            Behavior on scale {
                NumberAnimation {
                    duration: Theme.durationHover
                    easing.type: Easing.OutCubic
                }
            }

            // inner top shine
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                height: parent.height * 0.5
                radius: parent.radius

                gradient: Gradient {
                    GradientStop {
                        color: Qt.rgba(1, 1, 1, 0.08)
                        position: 0.0
                    }
                    GradientStop {
                        color: "transparent"
                        position: 1.0
                    }
                }
            }
            Text {
                anchors.centerIn: parent
                color: orb.glowColor
                font.family: Theme.icons
                font.pixelSize: 38
                opacity: orb.hovered ? 1.0 : 0.75
                text: orb.icon

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.durationHover
                    }
                }
            }
        }

        // Label
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: circle.bottom
            anchors.topMargin: 18
            color: Qt.rgba(1, 1, 1, orb.hovered ? 0.88 : 0.38)
            font.letterSpacing: 2.5
            font.pixelSize: Theme.fontCaption
            font.weight: Font.Medium
            text: orb.label.toUpperCase()

            Behavior on color {
                ColorAnimation {
                    duration: 180
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true

            onClicked: orb.activated()
            onEntered: orb.hovered = true
            onExited: {
                orb.hovered = false
                orb.isPressed = false
            }
            onPressed: orb.isPressed = true
            onReleased: orb.isPressed = false
        }
    }
}
