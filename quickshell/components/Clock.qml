import QtQuick
import qs.config
import qs.theme

Rectangle {
    id: root

    property bool showSeconds: true
    property bool smoothTransition: true

    /* ---------- helper functions for angle calculations ---------- */
    function getHourAngle() {
        var hours = timeTracker.currentTime.getHours() % 12
        var minutes = timeTracker.currentTime.getMinutes()
        var seconds = timeTracker.currentTime.getSeconds()
        return (hours + minutes / 60 + seconds / 3600) * 30
    }

    function getMinuteAngle() {
        var minutes = timeTracker.currentTime.getMinutes()
        var seconds = timeTracker.currentTime.getSeconds()
        return (minutes + seconds / 60) * 6
    }

    function getSecondAngle() {
        var seconds = timeTracker.currentTime.getSeconds()
        var milliseconds = timeTracker.currentTime.getMilliseconds()
        return (seconds + milliseconds / 1000) * 6
    }

    border.color: Theme.outline_variant
    border.width: Theme.borderEmphasis

    /* ---------- matugen colors ---------- */
    color: Theme.surface_container
    height: width
    radius: width / 2

    /* ---------- sizing ---------- */
    width: 200

    /* ---------- time tracking for smooth updates ---------- */
    QtObject {
        id: timeTracker

        property date currentTime: new Date()
    }
    Timer {
        interval: Config.clockPollInterval
        repeat: true
        running: true

        onTriggered: {
            timeTracker.currentTime = new Date()
        }
    }

    /* ---------- clock face ---------- */
    Item {
        anchors.fill: parent
        anchors.margins: 20

        // Hour markers with improved design
        Repeater {
            model: 12

            Rectangle {
                color: index % 3 === 0 ? Theme.primary : Theme.on_surface_variant
                height: index % 3 === 0 ? 16 : 10
                layer.enabled: true
                layer.samples: Theme.antialiasingSamples
                opacity: index % 3 === 0 ? 1.0 : 0.7
                radius: width / 2
                width: index % 3 === 0 ? 4 : 2
                x: parent.width / 2 - width / 2
                y: 0

                transform: Rotation {
                    angle: index * 30
                    origin.x: width / 2
                    origin.y: parent.height / 2
                }

                // Small glow effect for primary markers
                Rectangle {
                    anchors.centerIn: parent
                    border.color: Theme.primary
                    border.width: 1
                    color: "transparent"
                    height: parent.height + 2
                    opacity: parent.opacity * 0.3
                    radius: width / 2
                    visible: index % 3 === 0
                    width: parent.width + 2
                }
            }
        }

        // Minute markers (small dots between hour markers)
        Repeater {
            model: 60

            Rectangle {
                color: Theme.on_surface_variant
                height: 4
                opacity: Theme.opacitySubtle
                radius: width / 2
                visible: index % 5 !== 0  // Don't show where hour markers are

                width: 2
                x: parent.width / 2 - width / 2
                y: 6

                transform: Rotation {
                    angle: index * 6
                    origin.x: width / 2
                    origin.y: parent.height / 2 - 6
                }
            }
        }

        // Hour hand with improved design
        Rectangle {
            id: hourHand

            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: -8
            anchors.horizontalCenter: parent.horizontalCenter
            antialiasing: true
            color: Theme.primary
            height: parent.height * 0.3
            layer.enabled: true
            layer.samples: Theme.antialiasingSamples
            radius: width / 2
            width: 6

            // Gradient effect
            gradient: Gradient {
                GradientStop {
                    color: Theme.primary
                    position: 0.0
                }
                GradientStop {
                    color: Qt.darker(Theme.primary, 1.2)
                    position: 0.8
                }
            }
            transform: Rotation {
                id: hourRotation

                angle: getHourAngle()
                origin.x: hourHand.width / 2
                origin.y: hourHand.height + 8

                Behavior on angle {
                    enabled: root.smoothTransition

                    SpringAnimation {
                        damping: 0.2
                        modulus: Theme.clockAngleModulus
                        spring: 2
                    }
                }
            }
        }

        // Minute hand with improved design
        Rectangle {
            id: minuteHand

            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: -8
            anchors.horizontalCenter: parent.horizontalCenter
            antialiasing: true
            color: Theme.primary
            height: parent.height * 0.4
            layer.enabled: true
            layer.samples: Theme.antialiasingSamples
            radius: width / 2
            width: 4

            // Gradient effect
            gradient: Gradient {
                GradientStop {
                    color: Theme.primary
                    position: 0.0
                }
                GradientStop {
                    color: Qt.darker(Theme.primary, 1.1)
                    position: 0.8
                }
            }
            transform: Rotation {
                id: minuteRotation

                angle: getMinuteAngle()
                origin.x: minuteHand.width / 2
                origin.y: minuteHand.height + 8

                Behavior on angle {
                    enabled: root.smoothTransition

                    SpringAnimation {
                        damping: 0.2
                        modulus: Theme.clockAngleModulus
                        spring: 3
                    }
                }
            }
        }

        // Second hand with improved design
        Rectangle {
            id: secondHand

            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: -8
            anchors.horizontalCenter: parent.horizontalCenter
            antialiasing: true
            color: Theme.tertiary
            height: parent.height * 0.45
            layer.enabled: true
            layer.samples: Theme.antialiasingSamples
            radius: width / 2
            visible: root.showSeconds
            width: 2

            transform: Rotation {
                id: secondRotation

                angle: getSecondAngle()
                origin.x: secondHand.width / 2
                origin.y: secondHand.height + 8

                Behavior on angle {
                    enabled: root.smoothTransition

                    SpringAnimation {
                        damping: 0.15
                        modulus: Theme.clockAngleModulus
                        spring: 4
                    }
                }
            }

            // Small circle at the end of second hand
            Rectangle {
                anchors.bottom: parent.top
                anchors.bottomMargin: -3
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.tertiary
                height: 6
                radius: width / 2
                width: 6
            }
        }

        // Center dot with improved design
        Rectangle {
            anchors.centerIn: parent
            color: Theme.primary
            height: 16
            layer.enabled: true
            layer.samples: Theme.antialiasingSamples
            radius: width / 2
            width: 16

            // Inner dot
            Rectangle {
                anchors.centerIn: parent
                color: Theme.surface_container
                height: 8
                radius: width / 2
                width: 8
            }

            // Outer glow
            Rectangle {
                anchors.centerIn: parent
                border.color: Theme.primary
                border.width: 1
                color: "transparent"
                height: parent.height + 4
                opacity: Theme.opacitySubtle
                radius: width / 2
                width: parent.width + 4
            }
        }

        // Digital time display
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.spacingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.surface_container
            height: 24
            radius: Theme.radiusLarge
            width: digitalTime.width + Theme.spacingWide

            Text {
                id: digitalTime

                anchors.centerIn: parent
                color: Theme.on_surface
                font.bold: true
                font.pixelSize: Theme.fontBody
                text: {
                    var hours = timeTracker.currentTime.getHours()
                    var minutes = timeTracker.currentTime.getMinutes()
                    var ampm = hours >= 12 ? "PM" : "AM"
                    hours = hours % 12
                    hours = hours ? hours : 12
                    // 12-hour format
                    return hours + ":" + (minutes < 10 ? "0" + minutes : minutes) + " " + ampm
                }
            }
        }
    }

    /* ---------- subtle material look ---------- */
    Rectangle {
        anchors.fill: parent
        border.color: Theme.surface_tint
        border.width: 1
        color: "transparent"
        opacity: 0.08
        radius: parent.radius
    }
}
