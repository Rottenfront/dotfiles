import QtQuick
import QtQuick.Layouts
import qs.services as Services
import qs.theme

ColumnLayout {
    id: root

    Layout.fillWidth: true
    spacing: 0

    Item {
        Layout.fillWidth: true
        Layout.topMargin: Theme.spacingNormal
        implicitHeight: 36

        Text {
            anchors.left: parent.left
            anchors.leftMargin: Theme.paddingSection
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.on_surface_variant
            font.letterSpacing: 1.2
            font.pixelSize: Theme.fontSmall
            font.weight: Font.Medium
            text: "Audio Output"
        }
    }
    ColumnLayout {
        Layout.bottomMargin: Theme.spacingLarge
        Layout.fillWidth: true
        Layout.leftMargin: Theme.spacingLarge
        Layout.rightMargin: Theme.spacingLarge
        spacing: 3

        Repeater {
            model: Services.Volume.sinks

            delegate: Item {
                id: delegate

                property string description: modelData?.audio?.description ?? modelData?.description ?? ""
                property string displayName: {
                    let name = sinkName
                    name = name.replace(/^alsa_output\./, "")
                    name = name.replace(/\.(analog-stereo|stereo|mono|surround.*)$/, "")
                    name = name.replace(/\./g, " ")
                    return name.charAt(0).toUpperCase() + name.slice(1)
                }
                property bool isDefault: modelData === Services.Volume.defaultSink
                property string label: description !== "" ? description : displayName
                required property var modelData
                property string sinkName: modelData?.name ?? ""

                Layout.fillWidth: true
                implicitHeight: 48

                Rectangle {
                    anchors.fill: parent
                    color: delegate.isDefault ? Qt.rgba(Theme.primary_container.r, Theme.primary_container.g, Theme.primary_container.b, 0.85) : hoverHandler.hovered ? Theme.surface_container_high : Theme.surface_container
                    radius: 8

                    Behavior on color {
                        ColorAnimation {
                            duration: Theme.durationFast
                        }
                    }

                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        anchors.verticalCenter: parent.verticalCenter
                        color: Theme.primary
                        height: parent.height * 0.55
                        opacity: delegate.isDefault ? 1 : 0
                        radius: 1.5
                        width: Theme.accentWidth

                        Behavior on opacity {
                            NumberAnimation {
                                duration: Theme.durationFast
                            }
                        }
                    }
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 10

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1

                            Text {
                                Layout.fillWidth: true
                                color: delegate.isDefault ? Theme.on_primary_container : Theme.on_surface
                                elide: Text.ElideRight
                                font.pixelSize: Theme.size
                                font.weight: delegate.isDefault ? Font.Medium : Font.Normal
                                text: delegate.label

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Theme.durationFast
                                    }
                                }
                            }
                            Text {
                                Layout.fillWidth: true
                                color: delegate.isDefault ? Qt.rgba(Theme.on_primary_container.r, Theme.on_primary_container.g, Theme.on_primary_container.b, 0.55) : Theme.on_surface_variant
                                elide: Text.ElideRight
                                font.pixelSize: Theme.fontCaption
                                opacity: 0.85
                                text: delegate.sinkName
                                visible: delegate.description !== ""

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Theme.durationFast
                                    }
                                }
                            }
                        }
                        Text {
                            color: Theme.primary
                            font.pixelSize: Theme.size
                            font.weight: Font.Bold
                            opacity: delegate.isDefault ? 1 : 0
                            text: "✓"

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: Theme.durationFast
                                }
                            }
                        }
                    }
                    HoverHandler {
                        id: hoverHandler
                    }
                    TapHandler {
                        onTapped: {
                            if (!delegate.isDefault)
                                Services.Volume.setDefaultSink(delegate.modelData)
                        }
                    }
                }
            }
        }
    }
    Rectangle {
        Layout.fillWidth: true
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        color: Theme.outline_variant
        implicitHeight: 1
        opacity: 0.4
    }
}
