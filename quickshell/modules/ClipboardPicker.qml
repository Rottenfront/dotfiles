pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.theme

PanelWindow {
    contentItem.opacity: Theme.windowOpacity
    id: popup

    property bool confirmWipe: false
    readonly property var filteredEntries: {
        const query = search.text.toLocaleLowerCase()
        return Clipboard.entries.filter(entry => !query || entry.text.toLocaleLowerCase().includes(query))
    }

    function clearHistory() {
        if (confirmWipe) {
            Clipboard.wipe()
            confirmWipe = false
        } else {
            confirmWipe = true
        }
    }

    function handleKey(event) {
        if (event.key === Qt.Key_Escape) {
            if (confirmWipe)
                confirmWipe = false
            else
                Panels.clipboardOpen = false
        } else if (event.key === Qt.Key_Down || event.key === Qt.Key_Up || event.key === Qt.Key_PageDown || event.key === Qt.Key_PageUp) {
            const direction = event.key === Qt.Key_Down || event.key === Qt.Key_PageDown ? 1 : -1
            const step = event.key === Qt.Key_PageDown || event.key === Qt.Key_PageUp ? 5 : 1
            history.currentIndex = history.count ? Math.max(0, Math.min(history.count - 1, history.currentIndex + direction * step)) : -1
            if (history.currentIndex >= 0)
                history.positionViewAtIndex(history.currentIndex, ListView.Contain)
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (confirmWipe)
                clearHistory()
            else
                selectCurrent(Boolean(event.modifiers & Qt.ControlModifier))
        } else if (event.key === Qt.Key_D && (event.modifiers & Qt.ControlModifier)) {
            if (history.currentIndex >= 0 && history.currentIndex < filteredEntries.length)
                Clipboard.remove(filteredEntries[history.currentIndex].id)
        } else if (event.key === Qt.Key_R && (event.modifiers & Qt.ControlModifier)) {
            Clipboard.refresh()
        } else if (event.key === Qt.Key_Delete && (event.modifiers & Qt.ControlModifier) && (event.modifiers & Qt.ShiftModifier)) {
            clearHistory()
        } else {
            return
        }
        event.accepted = true
    }

    function selectCurrent(copyOnly) {
        if (history.currentIndex >= 0 && history.currentIndex < filteredEntries.length)
            Clipboard.activate(filteredEntries[history.currentIndex].id, copyOnly)
    }

    function syncOpen() {
        confirmWipe = false
        search.text = ""
        if (Panels.clipboardOpen)
            Clipboard.beginSession()
        else
            Clipboard.endSession()
    }

    WlrLayershell.keyboardFocus: visible && Clipboard.focusReady ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-clipboard"
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    screen: Quickshell.screens.find(screen => screen.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]
    visible: Panels.clipboardOpen

    Component.onCompleted: {
        if (Panels.clipboardOpen)
            syncOpen()
    }

    anchors {
        bottom: true
        left: true
        right: true
        top: true
    }
    Connections {
        function onClipboardOpenChanged() {
            popup.syncOpen()
        }

        target: Panels
    }
    Connections {
        function onCopied() {
            Panels.clipboardOpen = false
        }

        function onEntriesChanged() {
            history.currentIndex = popup.filteredEntries.length ? 0 : -1
        }

        function onFocusReadyChanged() {
            if (Clipboard.focusReady && popup.visible)
                search.forceActiveFocus()
        }

        target: Clipboard
    }
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.35)

        MouseArea {
            anchors.fill: parent

            onClicked: Panels.clipboardOpen = false
        }
    }
    Rectangle {
        id: card

        anchors.centerIn: parent
        border.color: Theme.outline_variant
        border.width: 1
        color: Theme.surface_container
        height: Math.min(640, popup.height - Theme.paddingLarge * 2)
        radius: Theme.radiusDialog
        width: Math.min(760, popup.width - Theme.paddingLarge * 2)

        MouseArea {
            anchors.fill: parent

            onClicked: search.forceActiveFocus()
        }
        FocusScope {
            anchors.fill: parent
            anchors.margins: Theme.paddingLarge
            focus: true

            Keys.onPressed: event => popup.handleKey(event)

            ColumnLayout {
                anchors.fill: parent
                spacing: Theme.spacingLarge

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        color: Theme.on_surface
                        font.bold: true
                        font.family: Theme.sans
                        font.pixelSize: Theme.fontTitle
                        text: "Clipboard history"
                    }
                    PickerButton {
                        enabled: !Clipboard.loading && !Clipboard.busy
                        label: "Refresh"

                        onClicked: Clipboard.refresh()
                    }
                    PickerButton {
                        label: "Close"

                        onClicked: Panels.clipboardOpen = false
                    }
                }
                TextField {
                    id: search

                    Layout.fillWidth: true
                    color: Theme.on_surface
                    enabled: Clipboard.focusReady
                    font.family: Theme.sans
                    font.pixelSize: Theme.fontMedium
                    padding: Theme.spacingLarge
                    placeholderText: "Search clipboard history…"
                    placeholderTextColor: Theme.on_surface_variant
                    selectByMouse: true
                    selectedTextColor: Theme.on_primary_container
                    selectionColor: Theme.primary_container

                    background: Rectangle {
                        border.color: search.activeFocus ? Theme.primary : Theme.outline_variant
                        border.width: 1
                        color: Theme.surface_container_low
                        radius: Theme.radiusNormal
                    }

                    Keys.onPressed: event => popup.handleKey(event)
                    onTextChanged: {
                        popup.confirmWipe = false
                        history.currentIndex = popup.filteredEntries.length ? 0 : -1
                    }
                }
                Text {
                    Layout.fillWidth: true
                    color: Theme.error
                    font.family: Theme.sans
                    font.pixelSize: Theme.fontBody
                    text: Clipboard.error
                    textFormat: Text.PlainText
                    visible: Boolean(Clipboard.error)
                    wrapMode: Text.Wrap
                }
                ListView {
                    id: history

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true
                    currentIndex: count ? 0 : -1
                    model: popup.filteredEntries
                    reuseItems: true
                    spacing: Theme.spacingCompact

                    ScrollBar.vertical: ScrollBar {}
                    delegate: Rectangle {
                        id: row

                        required property int index
                        required property var modelData

                        border.color: history.currentIndex === index ? Theme.primary : "transparent"
                        border.width: 1
                        color: history.currentIndex === index ? Theme.secondary_container : Theme.surface_container_low
                        height: modelData.image ? 96 : 68
                        radius: Theme.radiusNormal
                        width: history.width

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.spacingLarge
                            spacing: Theme.spacingLarge

                            Rectangle {
                                Layout.fillHeight: true
                                Layout.preferredWidth: 112
                                clip: true
                                color: Theme.surface_container_lowest
                                radius: Theme.radiusCompact
                                visible: row.modelData.image

                                Image {
                                    id: preview

                                    anchors.fill: parent
                                    anchors.margins: Theme.spacingSmall
                                    asynchronous: true
                                    cache: false
                                    fillMode: Image.PreserveAspectFit
                                    source: row.modelData.preview
                                    sourceSize.height: 144
                                    sourceSize.width: 224
                                }
                                Text {
                                    anchors.centerIn: parent
                                    color: Theme.on_surface_variant
                                    font.family: Theme.sans
                                    font.pixelSize: Theme.fontBody
                                    text: preview.status === Image.Loading ? "Loading…" : "Image"
                                    visible: preview.status !== Image.Ready
                                }
                            }
                            Text {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                color: Theme.on_surface
                                elide: Text.ElideRight
                                font.family: row.modelData.image ? Theme.sans : Theme.mono
                                font.pixelSize: Theme.fontBody
                                maximumLineCount: 2
                                text: row.modelData.text
                                textFormat: Text.PlainText
                                verticalAlignment: Text.AlignVCenter
                                wrapMode: Text.Wrap
                            }
                            Text {
                                color: Theme.on_surface_variant
                                font.family: Theme.sans
                                font.pixelSize: Theme.fontMicro
                                text: row.modelData.image ? "IMAGE" : "TEXT"
                            }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            enabled: !Clipboard.busy && Clipboard.focusReady
                            hoverEnabled: true

                            onClicked: mouse => Clipboard.activate(row.modelData.id, Boolean(mouse.modifiers & Qt.ControlModifier))
                            onEntered: history.currentIndex = row.index
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        color: Theme.on_surface_variant
                        font.family: Theme.sans
                        font.pixelSize: Theme.fontMedium
                        horizontalAlignment: Text.AlignHCenter
                        text: Clipboard.loading ? "Loading history…" : (search.text ? "No matching entries" : "Clipboard history is empty")
                        visible: history.count === 0
                        width: parent.width
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLarge

                    Text {
                        Layout.fillWidth: true
                        color: popup.confirmWipe ? Theme.error : Theme.on_surface_variant
                        font.family: Theme.sans
                        font.pixelSize: Theme.fontSmall
                        text: popup.confirmWipe ? "Delete all history? Enter confirms · Esc cancels" : (Clipboard.busy ? "Working…" : popup.filteredEntries.length + " entries · ↑↓ select · Enter " + (Clipboard.targetAddress ? "paste" : "copy") + " · Ctrl+Enter copy only\nCtrl+D delete · Ctrl+R refresh · Esc close")
                        textFormat: Text.PlainText
                        wrapMode: Text.Wrap
                    }
                    PickerButton {
                        enabled: !Clipboard.busy && Clipboard.entries.length > 0
                        label: popup.confirmWipe ? "Confirm clear" : "Clear all"

                        onClicked: popup.clearHistory()
                    }
                }
            }
        }
    }

    component PickerButton: Button {
        id: button

        required property string label

        font.family: Theme.sans
        font.pixelSize: Theme.fontBody
        opacity: enabled ? 1 : Theme.opacityMuted
        padding: Theme.spacingNormal
        text: label

        background: Rectangle {
            border.color: button.activeFocus ? Theme.primary : "transparent"
            border.width: 1
            color: button.down ? Theme.primary_container : (button.hovered ? Theme.surface_container_highest : Theme.surface_container_high)
            radius: Theme.radiusCompact
        }
        contentItem: Text {
            color: Theme.on_surface
            font: button.font
            horizontalAlignment: Text.AlignHCenter
            text: button.text
            verticalAlignment: Text.AlignVCenter
        }

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                button.clicked()
                event.accepted = true
            } else {
                popup.handleKey(event)
            }
        }
    }
}
