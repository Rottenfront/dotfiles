import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs.modules.control
import qs.theme

Item {
    id: controlCenter

    property int controlCenterWidth: Theme.controlCenterWidth
    property bool opened: false

    function close() {
        opened = false
    }

    anchors.fill: parent
    visible: false

    onOpenedChanged: {
        if (opened) {
            closeAnim.stop()
            visible = true
            panel.x = -panel.width
            openAnim.restart()
        } else {
            openAnim.stop()
            closeAnim.restart()
        }
    }

    Process {
        id: proc
    }
    Rectangle {
        id: panel

        color: Theme.surface_container_low
        height: parent.height
        layer.enabled: true
        width: controlCenter.controlCenterWidth
        x: -width

        Rectangle {
            anchors.fill: parent

            gradient: Gradient {
                GradientStop {
                    color: "transparent"
                    position: 0
                }
                GradientStop {
                    color: Qt.rgba(0, 0, 0, 0.15)
                    position: 1
                }
            }
        }
        Rectangle {
            anchors.left: parent.left
            height: parent.height
            width: Theme.accentWidth

            gradient: Gradient {
                GradientStop {
                    color: Theme.primary
                    position: 0
                }
                GradientStop {
                    color: Theme.secondary
                    position: 0.5
                }
                GradientStop {
                    color: Theme.tertiary
                    position: 1
                }
            }
        }
        FocusScope {
            anchors.fill: parent
            focus: controlCenter.opened

            Keys.onEscapePressed: controlCenter.close()

            Flickable {
                id: flickable

                anchors.fill: parent
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                contentHeight: mainColumn.height + 30

                ColumnLayout {
                    id: mainColumn

                    spacing: 0
                    width: parent.width

                    Header {}
                    QuickSettings {}
                    SliderSection {}
                    SinkSelector {
                        Layout.alignment: Qt.AlignCenter
                    }
                    StatsSection {}
                    PowerSection {
                        onCommandRequested: command => proc.exec(command)
                    }
                }
            }
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.margins: Theme.spacingCompact
                anchors.right: parent.right
                anchors.top: parent.top
                color: Theme.surface_container_high
                opacity: flickable.moving ? 0.4 : 0
                radius: width / 2
                width: 5

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.durationFade
                    }
                }

                Rectangle {
                    color: Theme.primary
                    height: Math.max(30, (flickable.height / flickable.contentHeight) * parent.height)
                    opacity: Theme.opacityStrong
                    radius: width / 2
                    width: parent.width
                    y: (flickable.contentY / flickable.contentHeight) * parent.height

                    Behavior on y {
                        NumberAnimation {
                            duration: Theme.durationQuick
                        }
                    }
                }
            }
        }
    }
    NumberAnimation {
        id: openAnim

        duration: 320
        easing.type: Easing.OutCubic
        property: "x"
        target: panel
        to: 0
    }
    NumberAnimation {
        id: closeAnim

        duration: 260
        easing.type: Easing.InCubic
        property: "x"
        target: panel
        to: -panel.width

        onFinished: controlCenter.visible = false
    }
}
