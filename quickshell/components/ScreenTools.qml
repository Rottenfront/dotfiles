import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
import qs.theme

Item {
    property var colors: Theme
    property bool hoveredRecord: false
    property bool hoveredScreenshot: false
    property bool recording: false

    height: 110
    width: 340

    Component.onCompleted: {
        checkRecordingProc.running = true
    }

    Process {
        id: checkRecordingProc

        command: ["pgrep", "-x", "wf-recorder"]

        onExited: (exitCode, exitStatus) => {
            recording = (exitCode === 0)
        }
    }
    Rectangle {
        anchors.fill: parent
        anchors.margins: 6
        border.color: colors.outline_variant
        border.width: 1
        color: colors.surface_container
        radius: Theme.radiusLarge

        Rectangle {
            id: recordingIndicator

            anchors.margins: 12
            anchors.right: parent.right
            anchors.top: parent.top
            color: colors.error
            height: 8
            radius: 4
            visible: recording
            width: 8

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: recording

                NumberAnimation {
                    duration: 700
                    easing.type: Easing.InOutQuad
                    from: 1.0
                    to: 0.2
                }
                NumberAnimation {
                    duration: 700
                    easing.type: Easing.InOutQuad
                    from: 0.2
                    to: 1.0
                }
            }
        }
        Column {
            anchors.centerIn: parent
            spacing: Theme.spacingLarge

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                color: recording ? colors.error : colors.on_surface_variant
                font.pixelSize: Theme.fontSmall
                font.weight: Font.Medium
                opacity: 0.7
                text: recording ? "● Recording" : "Capture"
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.spacingLarge

                Rectangle {
                    border.color: recording ? colors.error : colors.primary
                    border.width: hoveredRecord ? 1.5 : 1
                    color: recording ? (hoveredRecord ? Qt.lighter(colors.error_container, 1.15) : colors.error_container) : (hoveredRecord ? Qt.lighter(colors.primary_container, 1.2) : colors.primary_container)
                    height: 52
                    radius: Theme.radiusMedium
                    scale: hoveredRecord ? 1.03 : 1.0
                    width: 140

                    Behavior on border.width {
                        NumberAnimation {
                            duration: Theme.durationShort
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.durationColor
                        }
                    }
                    Behavior on scale {
                        NumberAnimation {
                            duration: Theme.durationShort
                            easing.type: Easing.OutCubic
                        }
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: Theme.spacingNormal

                        Rectangle {
                            anchors.verticalCenter: parent.verticalCenter
                            color: recording ? colors.error : colors.primary
                            height: 18
                            radius: recording ? 3 : 9
                            width: Theme.fontIconMedium

                            Behavior on radius {
                                NumberAnimation {
                                    duration: Theme.durationColor
                                }
                            }
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            color: recording ? colors.on_error_container : colors.on_primary_container
                            font.pixelSize: Theme.size
                            font.weight: Font.DemiBold
                            text: recording ? "Stop" : "Record"
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onClicked: {
                            if (!recording) {
                                recordProc.running = true
                                recording = true
                            } else {
                                stopProc.running = true
                                recording = false
                            }
                        }
                        onEntered: hoveredRecord = true
                        onExited: hoveredRecord = false
                    }
                }
                Rectangle {
                    border.color: colors.tertiary
                    border.width: hoveredScreenshot ? 1.5 : 1
                    color: hoveredScreenshot ? Qt.lighter(colors.tertiary_container, 1.2) : colors.tertiary_container
                    height: 52
                    radius: Theme.radiusMedium
                    scale: hoveredScreenshot ? 1.03 : 1.0
                    width: 140

                    Behavior on border.width {
                        NumberAnimation {
                            duration: Theme.durationShort
                        }
                    }
                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.durationColor
                        }
                    }
                    Behavior on scale {
                        NumberAnimation {
                            duration: Theme.durationShort
                            easing.type: Easing.OutCubic
                        }
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: Theme.spacingNormal

                        // Camera icon
                        Item {
                            anchors.verticalCenter: parent.verticalCenter
                            height: 18
                            width: Theme.fontIconMedium

                            Rectangle {
                                anchors.centerIn: parent
                                border.color: colors.tertiary
                                border.width: 1.5
                                color: "transparent"
                                height: 14
                                radius: 3
                                width: Theme.fontIconMedium

                                Rectangle {
                                    anchors.centerIn: parent
                                    color: colors.tertiary
                                    height: 4
                                    radius: 2
                                    width: 4
                                }
                                Rectangle {
                                    anchors.bottom: parent.top
                                    anchors.bottomMargin: -1
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    color: colors.tertiary
                                    height: 3
                                    radius: 1
                                    width: 6
                                }
                            }
                        }
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            color: colors.on_tertiary_container
                            font.pixelSize: Theme.size
                            font.weight: Font.DemiBold
                            text: "Screenshot"
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true

                        onClicked: {
                            screenshotProc.running = true
                            screenshotFlash.opacity = 1.0
                        }
                        onEntered: hoveredScreenshot = true
                        onExited: hoveredScreenshot = false
                    }
                }
            }
        }
        Rectangle {
            id: screenshotFlash

            anchors.fill: parent
            color: "white"
            opacity: 0
            radius: Theme.radiusLarge

            Behavior on opacity {
                SequentialAnimation {
                    NumberAnimation {
                        duration: 80
                    }
                    PauseAnimation {
                        duration: 40
                    }
                    NumberAnimation {
                        duration: Theme.durationColor
                        to: 0
                    }
                }
            }
        }
    }
    Process {
        id: recordProc

        command: ["sh", "-c", Config.recordingCommand, "recording", Config.recordingDirectory]
    }
    Process {
        id: stopProc

        command: ["pkill", "wf-recorder"]
    }
    Process {
        id: screenshotProc

        command: ["sh", "-c", Config.screenshotCommand, "screenshot", Config.screenshotDirectory, String(Quickshell.processId)]
    }
}
