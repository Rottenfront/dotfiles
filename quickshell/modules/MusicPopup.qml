pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.services as Services
import qs.theme

PanelWindow {
    id: root

    property var media: Services.Media
    readonly property bool opened: Services.Panels.musicOpen
    readonly property real progress: media.lengthSupported && media.positionSupported && media.length > 0 ? Math.max(0, Math.min(1, media.position / media.length)) : 0
    property real slideProgress: opened ? 1 : 0

    function close(): void {
        Services.Panels.musicOpen = false
    }

    function formatTime(seconds: real): string {
        const total = Math.max(0, Math.floor(Number.isFinite(seconds) ? seconds : 0))
        const hours = Math.floor(total / 3600)
        const minutes = Math.floor(total / 60) % 60
        const remainder = String(total % 60).padStart(2, "0")
        return hours > 0 ? hours + ":" + String(minutes).padStart(2, "0") + ":" + remainder : minutes + ":" + remainder
    }

    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.keyboardFocus: opened ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "music-popup"
    anchors.top: true
    color: "transparent"
    implicitHeight: content.implicitHeight + Theme.paddingLarge * 2
    implicitWidth: Math.min(440, (screen?.width ?? 640) - Theme.paddingLarge * 2)
    margins.top: Theme.barHeight + Theme.spacingLarge
    screen: Quickshell.screens.find(screen => screen.name === Services.Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0] ?? null
    visible: opened || slideProgress > 0

    contentItem.transform: Translate {
        id: slide

        y: -root.height * (1 - root.slideProgress)
    }
    mask: Region {
        height: root.height
        width: root.width
        y: slide.y
    }
    Behavior on slideProgress {
        NumberAnimation {
            duration: root.opened ? Theme.durationMedium : Theme.durationExit
            easing.type: Easing.OutCubic
        }
    }

    onOpenedChanged: {
        if (opened) {
            Qt.callLater(() => {
                if (root.opened)
                    focusScope.forceActiveFocus()
            })
        }
    }

    HyprlandFocusGrab {
        active: root.opened
        windows: [root]

        onCleared: root.close()
    }
    Rectangle {
        anchors.fill: parent
        border.color: Theme.outline_variant
        border.width: 1
        color: Theme.surface_container
        radius: Theme.radiusPanel
    }
    FocusScope {
        id: focusScope

        anchors.fill: parent
        focus: true

        Keys.onEscapePressed: root.close()

        ColumnLayout {
            id: content

            anchors.left: parent.left
            anchors.margins: Theme.paddingLarge
            anchors.right: parent.right
            anchors.top: parent.top
            spacing: Theme.spacingLarge

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingNormal

                Text {
                    Layout.fillWidth: true
                    color: Theme.on_surface_variant
                    elide: Text.ElideRight
                    font.family: Theme.mono
                    font.pixelSize: Theme.fontBody
                    text: root.media.currentPlayerName || "Music"
                    textFormat: Text.PlainText
                }
                TransportButton {
                    Accessible.name: "Close music popup"
                    implicitHeight: Theme.barWidgetHeight
                    implicitWidth: Theme.barWidgetHeight
                    text: "×"

                    onClicked: root.close()
                }
            }
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 180
                Layout.preferredWidth: 180
                clip: true
                color: Theme.surface_container_high
                radius: Theme.radiusLarge

                Image {
                    id: cover

                    anchors.fill: parent
                    asynchronous: true
                    fillMode: Image.PreserveAspectCrop
                    source: root.media.artUrl
                    sourceSize.height: 360
                    sourceSize.width: 360
                    visible: status === Image.Ready
                }
                Shape {
                    anchors.centerIn: parent
                    height: Theme.fontDisplay * 2
                    visible: cover.status !== Image.Ready
                    width: height

                    ShapePath {
                        fillColor: Theme.on_surface
                        startX: 8
                        startY: 0
                        strokeWidth: -1

                        PathLine {
                            x: Theme.fontDisplay * 2
                            y: Theme.fontDisplay
                        }
                        PathLine {
                            x: 8
                            y: Theme.fontDisplay * 2
                        }
                        PathLine {
                            x: 8
                            y: 0
                        }
                    }
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingSmall

                Text {
                    Layout.fillWidth: true
                    color: Theme.on_surface
                    elide: Text.ElideRight
                    font.bold: true
                    font.family: Theme.mono
                    font.pixelSize: Theme.fontTitle
                    horizontalAlignment: Text.AlignHCenter
                    maximumLineCount: 2
                    text: root.media.title
                    textFormat: Text.PlainText
                    wrapMode: Text.Wrap
                }
                Text {
                    Layout.fillWidth: true
                    color: Theme.on_surface_variant
                    elide: Text.ElideRight
                    font.family: Theme.mono
                    font.pixelSize: Theme.fontMedium
                    horizontalAlignment: Text.AlignHCenter
                    maximumLineCount: 2
                    text: root.media.artist || "Unknown artist"
                    textFormat: Text.PlainText
                    wrapMode: Text.Wrap
                }
                Text {
                    Layout.fillWidth: true
                    color: Theme.on_surface_variant
                    elide: Text.ElideRight
                    font.family: Theme.mono
                    font.pixelSize: Theme.fontBody
                    horizontalAlignment: Text.AlignHCenter
                    maximumLineCount: 2
                    text: root.media.album || "Unknown album"
                    textFormat: Text.PlainText
                    wrapMode: Text.Wrap
                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingCompact

                Rectangle {
                    Layout.fillWidth: true
                    color: Theme.surface_container_highest
                    implicitHeight: Theme.spacingCompact
                    radius: height / 2

                    Rectangle {
                        color: Theme.primary
                        height: parent.height
                        radius: height / 2
                        width: parent.width * root.progress
                    }
                }
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        color: Theme.on_surface_variant
                        font.family: Theme.mono
                        font.pixelSize: Theme.fontSmall
                        text: root.media.positionSupported ? root.formatTime(root.media.position) : "--:--"
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    Text {
                        color: Theme.on_surface_variant
                        font.family: Theme.mono
                        font.pixelSize: Theme.fontSmall
                        text: root.media.lengthSupported ? root.formatTime(root.media.length) : "--:--"
                    }
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.spacingWide

                TransportButton {
                    Accessible.name: "Previous track"
                    enabled: root.media.activePlayer?.canGoPrevious ?? false
                    text: "⏮"

                    onClicked: root.media.previous()
                }
                TransportButton {
                    Accessible.name: root.media.isPlaying ? "Pause" : "Play"
                    enabled: root.media.activePlayer?.canTogglePlaying ?? false
                    text: root.media.isPlaying ? "⏸" : "▶"

                    onClicked: root.media.playPause()
                }
                TransportButton {
                    Accessible.name: "Next track"
                    enabled: root.media.activePlayer?.canGoNext ?? false
                    text: "⏭"

                    onClicked: root.media.next()
                }
            }
        }
    }

    component TransportButton: Button {
        id: button

        implicitHeight: Theme.buttonHeight
        implicitWidth: Theme.buttonHeightLarge
        opacity: enabled ? 1 : Theme.opacitySubtle

        background: Rectangle {
            border.color: button.activeFocus ? Theme.primary : Theme.outline_variant
            border.width: 1
            color: button.down ? Theme.primary_container : button.hovered ? Theme.surface_container_highest : Theme.surface_container_high
            radius: Theme.radiusNormal
        }
        contentItem: Text {
            color: Theme.on_surface
            font.family: Theme.mono
            font.pixelSize: Theme.fontIconLarge
            horizontalAlignment: Text.AlignHCenter
            text: button.text
            verticalAlignment: Text.AlignVCenter
        }
    }
}
