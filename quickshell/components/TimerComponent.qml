import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.theme

Item {
    id: root

    property bool finished: false
    property real progress: totalSeconds > 0 ? (1 - remainingSeconds / totalSeconds) : 0
    property int remainingSeconds: 0
    property bool running: false
    property int totalSeconds: 0

    function displayTime(secs) {
        var h = Math.floor(secs / 3600)
        var m = Math.floor((secs % 3600) / 60)
        var s = secs % 60
        return pad(h) + ":" + pad(m) + ":" + pad(s)
    }

    function pad(n) {
        return n < 10 ? "0" + n : "" + n
    }

    function resetTimer() {
        running = false
        finished = false
        remainingSeconds = 0
        totalSeconds = 0
        hoursField.text = ""
        minutesField.text = ""
        secondsField.text = ""
    }

    function sendNotification() {
        var msg = notifField.text.trim() !== "" ? notifField.text : "Timer finished!"
        Quickshell.execDetached(["notify-send", "-a", "Quickshell Timer", "\u23f0 Timer Done", msg])
    }

    function startTimer() {
        var h = parseInt(hoursField.text) || 0
        var m = parseInt(minutesField.text) || 0
        var s = parseInt(secondsField.text) || 0
        var total = h * 3600 + m * 60 + s
        if (total <= 0)
            return
        totalSeconds = total
        remainingSeconds = total
        finished = false
        running = true
    }

    focus: true
    implicitHeight: 310
    implicitWidth: 740

    Timer {
        interval: Config.secondInterval
        repeat: true
        running: root.running

        onTriggered: {
            if (root.remainingSeconds > 0) {
                root.remainingSeconds--
            } else {
                root.running = false
                root.finished = true
                root.sendNotification()
            }
        }
    }

    // Background glow effect when finished
    Rectangle {
        anchors.fill: parent
        border.width: 0
        color: "transparent"
        radius: 24

        Rectangle {
            anchors.fill: parent
            color: root.finished ? Qt.rgba(Theme.tertiary.r, Theme.tertiary.g, Theme.tertiary.b, 0.05) : "transparent"
            radius: 24

            Behavior on color {
                ColorAnimation {
                    duration: Theme.durationMedium
                }
            }
        }
    }
    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 32

        Item {
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredHeight: 200
            Layout.preferredWidth: 200

            // Outer glow ring for finished state
            Rectangle {
                anchors.centerIn: parent
                border.color: Qt.rgba(Theme.tertiary.r, Theme.tertiary.g, Theme.tertiary.b, 0.3)
                border.width: root.finished ? 2 : 0
                color: "transparent"
                height: 192
                opacity: root.finished ? 0.5 : 0
                radius: 96
                width: 192

                Behavior on border.width {
                    NumberAnimation {
                        duration: Theme.durationMedium
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.durationMedium
                    }
                }
            }

            // Background track with subtle gradient
            Canvas {
                anchors.fill: parent

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    ctx.beginPath()
                    ctx.arc(width / 2, height / 2, 88, 0, Math.PI * 2)
                    ctx.strokeStyle = Theme.surface_container_highest
                    ctx.lineWidth = 6
                    ctx.stroke()

                    // Add subtle inner track
                    ctx.beginPath()
                    ctx.arc(width / 2, height / 2, 82, 0, Math.PI * 2)
                    ctx.strokeStyle = Qt.rgba(Theme.surface_container_highest.r, Theme.surface_container_highest.g, Theme.surface_container_highest.b, 0.3)
                    ctx.lineWidth = 1
                    ctx.stroke()
                }
            }

            // Progress arc with glow effect
            Canvas {
                id: arcCanvas

                anchors.fill: parent

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    if (root.progress <= 0 && !root.finished)
                        return

                    // Draw glow for finished state
                    if (root.finished) {
                        ctx.beginPath()
                        ctx.arc(width / 2, height / 2, 94, 0, Math.PI * 2)
                        ctx.strokeStyle = Qt.rgba(Theme.tertiary.r, Theme.tertiary.g, Theme.tertiary.b, 0.2)
                        ctx.lineWidth = 12
                        ctx.stroke()
                    }

                    ctx.beginPath()
                    ctx.arc(width / 2, height / 2, 88, -Math.PI / 2, -Math.PI / 2 + (root.finished ? Math.PI * 2 : root.progress * Math.PI * 2))
                    ctx.strokeStyle = root.finished ? Theme.tertiary : Theme.primary
                    ctx.lineWidth = root.finished ? 8 : 6
                    ctx.lineCap = "round"
                    ctx.stroke()
                }

                Connections {
                    function onFinishedChanged() {
                        arcCanvas.requestPaint()
                    }

                    function onProgressChanged() {
                        arcCanvas.requestPaint()
                    }

                    target: root
                }
            }
            Text {
                anchors.centerIn: parent
                color: root.finished ? Theme.tertiary : Theme.on_surface
                font.family: Theme.timerMono
                font.pixelSize: 32
                font.weight: Font.Light
                text: (root.running || root.finished || root.remainingSeconds > 0) ? root.displayTime(root.remainingSeconds) : "00:00:00"
            }
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Theme.spacingWide
                anchors.horizontalCenter: parent.horizontalCenter
                color: Qt.rgba(Theme.tertiary.r, Theme.tertiary.g, Theme.tertiary.b, 0.15)
                height: 24
                radius: Theme.radiusLarge
                visible: root.finished
                width: 60

                Text {
                    anchors.centerIn: parent
                    color: Theme.tertiary
                    font.letterSpacing: Theme.letterSpacingWide
                    font.pixelSize: Theme.fontCaption
                    font.weight: Font.Medium
                    text: "DONE"
                }
            }
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            spacing: 20

            // Timer label with subtle divider
            RowLayout {
                Layout.fillWidth: true

                Text {
                    color: Theme.primary
                    font.letterSpacing: 6
                    font.pixelSize: Theme.fontSmall
                    font.weight: Font.Medium
                    text: "TIMER"
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.leftMargin: 12
                    color: Theme.outline_variant
                    implicitHeight: 1
                }
            }
            RowLayout {
                enabled: !root.running && !root.finished
                spacing: Theme.spacingNormal

                TimeInput {
                    id: hoursField

                    maximum: 99
                    unit: "HH"

                    onCompleted: minutesField.focusInput()
                }
                TimeSeparator {}
                TimeInput {
                    id: minutesField

                    unit: "MM"

                    onCompleted: secondsField.focusInput()
                }
                TimeSeparator {}
                TimeInput {
                    id: secondsField

                    unit: "SS"
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingNormal

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        color: Theme.outline
                        font.letterSpacing: Theme.letterSpacingWide
                        font.pixelSize: Theme.fontMicro
                        text: "NOTIFICATION"
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.leftMargin: Theme.spacingNormal
                        color: Theme.outline_variant
                        implicitHeight: 1
                        opacity: 0.5
                    }
                }
                TextField {
                    id: notifField

                    Layout.fillWidth: true
                    color: Theme.on_surface
                    font.pixelSize: Theme.size
                    implicitHeight: 42
                    leftPadding: Theme.spacingSection
                    placeholderText: "Timer finished!"
                    placeholderTextColor: Theme.outline
                    selectByMouse: true

                    background: Rectangle {
                        border.color: notifField.activeFocus ? Theme.secondary : Theme.outline_variant
                        border.width: notifField.activeFocus ? Theme.borderEmphasis : 1
                        color: notifField.activeFocus ? Theme.surface_container_high : Theme.surface_container_low
                        radius: Theme.radiusMedium

                        Behavior on border.color {
                            ColorAnimation {
                                duration: Theme.durationQuick
                            }
                        }
                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.durationQuick
                            }
                        }
                    }
                }
            }

            // Action buttons with improved design
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingLarge

                Rectangle {
                    Layout.fillWidth: true
                    color: primaryBtn.containsMouse || root.running || root.remainingSeconds > 0 ? Theme.primary : Theme.primary_container
                    implicitHeight: Theme.buttonHeight
                    radius: Theme.radiusLarge

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.durationFast
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        color: root.running || root.remainingSeconds > 0 ? Theme.on_primary : Theme.on_primary_container
                        font.letterSpacing: 1.5
                        font.pixelSize: Theme.size
                        font.weight: Font.Medium
                        text: {
                            if (root.finished)
                                return "FINISHED"
                            if (root.running)
                                return "PAUSE"
                            if (root.remainingSeconds > 0)
                                return "RESUME"
                            return "START"
                        }
                    }
                    MouseArea {
                        id: primaryBtn

                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onClicked: {
                            if (root.finished)
                                return
                            if (!root.running && root.remainingSeconds === 0) {
                                root.startTimer()
                            } else if (root.running) {
                                root.running = false
                            } else {
                                root.running = true
                            }
                        }
                    }
                }
                Rectangle {
                    border.color: resetBtn.containsMouse ? Theme.outline : Theme.outline_variant
                    border.width: 1
                    color: resetBtn.containsMouse ? Theme.surface_container_highest : Theme.surface_container_high
                    implicitHeight: Theme.buttonHeight
                    implicitWidth: 90
                    radius: Theme.radiusLarge

                    Behavior on border.color {
                        ColorAnimation {
                            duration: Theme.durationFast
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.durationFast
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        color: Theme.on_surface_variant
                        font.letterSpacing: 1
                        font.pixelSize: Theme.fontBody
                        font.weight: Font.Medium
                        text: "RESET"
                    }
                    MouseArea {
                        id: resetBtn

                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onClicked: root.resetTimer()
                    }
                }
            }
        }
    }

    component TimeInput: ColumnLayout {
        id: input

        property int maximum: 59
        property alias text: field.text
        required property string unit

        signal completed

        function focusInput() {
            field.forceActiveFocus()
        }

        spacing: Theme.spacingSmall

        TextField {
            id: field

            Layout.preferredHeight: Theme.timerInputHeight
            Layout.preferredWidth: Theme.timerInputWidth
            color: Theme.on_surface
            font.family: Theme.timerMono
            font.pixelSize: Theme.fontLarge
            font.weight: Font.Light
            horizontalAlignment: Text.AlignHCenter
            inputMethodHints: Qt.ImhDigitsOnly
            maximumLength: 2
            placeholderText: input.unit
            placeholderTextColor: Theme.outline
            selectByMouse: true

            background: Rectangle {
                border.color: field.activeFocus ? Theme.primary : field.text.length > 0 ? Theme.outline : Theme.outline_variant
                border.width: field.activeFocus ? 2 : field.text.length > 0 ? 1.5 : 1
                color: field.activeFocus ? Theme.surface_container_highest : Theme.surface_container_low
                radius: Theme.radiusMedium

                Behavior on border.color {
                    ColorAnimation {
                        duration: Theme.durationQuick
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: Theme.durationQuick
                    }
                }
            }
            validator: IntValidator {
                bottom: 0
                top: input.maximum
            }

            onTextChanged: {
                if (text.length === maximumLength)
                    input.completed()
            }
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            color: field.activeFocus || field.text.length > 0 ? Theme.primary : Theme.outline
            font.letterSpacing: 2
            font.pixelSize: Theme.fontTiny
            font.weight: Font.Medium
            text: input.unit

            Behavior on color {
                ColorAnimation {
                    duration: Theme.durationQuick
                }
            }
        }
    }
    component TimeSeparator: Text {
        Layout.alignment: Qt.AlignVCenter
        bottomPadding: Theme.spacingSection
        color: Theme.outline
        font.pixelSize: Theme.fontDisplay
        font.weight: Font.Thin
        text: ":"
    }
}
