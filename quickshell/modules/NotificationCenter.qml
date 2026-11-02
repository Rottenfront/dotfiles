import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.theme

Item {
    id: root

    property int notificationCenterWidth: Theme.controlCenterWidth
    readonly property bool opened: Panels.notificationsOpen
    readonly property Item panelItem: panel
    property real slideProgress: opened ? 1 : 0

    function close() {
        Panels.closeAll()
    }

    function iconSource(entry) {
        if (entry.image.length > 0)
            return entry.image
        const icon = entry.appIcon
        if (!icon || (icon.includes(":") && !icon.startsWith("file://")))
            return ""
        return icon.startsWith("/") || icon.startsWith("file://") ? icon : Quickshell.iconPath(icon, true)
    }

    anchors.fill: parent
    clip: true
    visible: opened || slideProgress > 0

    Behavior on slideProgress {
        NumberAnimation {
            duration: root.opened ? Theme.durationMedium : Theme.durationExit
            easing.type: Easing.OutCubic
        }
    }

    onOpenedChanged: {
        if (opened)
            panel.forceActiveFocus()
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.opened

        onClicked: root.close()
    }
    Rectangle {
        id: panel

        border.color: Theme.outline_variant
        border.width: 1
        color: Theme.surface_container_low
        height: parent.height
        width: Math.min(root.notificationCenterWidth, parent.width)
        x: parent.width - width * root.slideProgress

        Keys.onEscapePressed: root.close()

        MouseArea {
            anchors.fill: parent
        }
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            color: Theme.primary
            width: Theme.accentWidth
        }
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.paddingSection
            spacing: Theme.spacingLarge

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingNormal

                Text {
                    Layout.fillWidth: true
                    color: Theme.on_surface
                    elide: Text.ElideRight
                    font.family: Theme.sans
                    font.pixelSize: Theme.fontTitle
                    font.weight: Font.DemiBold
                    text: "Notifications"
                    textFormat: Text.PlainText
                }
                CenterButton {
                    accessibleLabel: "Close notification center"
                    text: "✕"

                    onClicked: root.close()
                }
            }
            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.spacingNormal

                Text {
                    Layout.fillWidth: true
                    color: Theme.on_surface_variant
                    font.family: Theme.mono
                    font.pixelSize: Theme.fontCaption
                    text: Notifications.history.length + " saved this session"
                    textFormat: Text.PlainText
                }
                CenterButton {
                    accessibleLabel: "Clear notification history"
                    enabled: Notifications.history.length > 0
                    text: "Clear all"

                    onClicked: Notifications.clearHistory()
                }
            }
            Rectangle {
                Layout.fillWidth: true
                color: Theme.surface_container
                implicitHeight: dndRow.implicitHeight + Theme.spacingLarge * 2
                radius: Theme.radiusNormal

                RowLayout {
                    id: dndRow

                    anchors.fill: parent
                    anchors.margins: Theme.spacingLarge
                    spacing: Theme.spacingNormal

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: Theme.spacingSmall

                        Text {
                            color: Theme.on_surface
                            font.family: Theme.sans
                            font.pixelSize: Theme.fontMedium
                            text: "Do not disturb"
                        }
                        Text {
                            Layout.fillWidth: true
                            color: Theme.on_surface_variant
                            font.family: Theme.sans
                            font.pixelSize: Theme.fontSmall
                            text: "Hide popups; keep notification history"
                            wrapMode: Text.WordWrap
                        }
                    }
                    Switch {
                        id: dndSwitch

                        Accessible.name: "Do not disturb"
                        checked: Notifications.dnd

                        indicator: Rectangle {
                            border.color: dndSwitch.checked ? Theme.primary : Theme.outline
                            border.width: 1
                            color: dndSwitch.checked ? Theme.primary_container : Theme.surface_container_highest
                            implicitHeight: Theme.fontIconLarge
                            implicitWidth: Theme.buttonHeight
                            radius: height / 2
                            x: dndSwitch.leftPadding
                            y: (dndSwitch.height - height) / 2

                            Rectangle {
                                color: dndSwitch.checked ? Theme.primary : Theme.on_surface_variant
                                height: parent.height - Theme.spacingNormal
                                radius: height / 2
                                width: height
                                x: dndSwitch.checked ? parent.width - width - Theme.spacingSmall : Theme.spacingSmall
                                y: Theme.spacingSmall

                                Behavior on x {
                                    NumberAnimation {
                                        duration: Theme.durationFast
                                    }
                                }
                            }
                        }

                        onToggled: Notifications.dnd = checked
                    }
                }
            }
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                ListView {
                    id: historyList

                    anchors.fill: parent
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true
                    model: Notifications.history
                    spacing: Theme.spacingLarge

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }
                    delegate: Rectangle {
                        id: entryCard

                        readonly property string imageSource: root.iconSource(modelData)
                        required property var modelData

                        border.color: modelData.urgency === 2 ? Theme.error : Theme.outline_variant
                        border.width: 1
                        color: Theme.surface_container
                        implicitHeight: entryColumn.implicitHeight + Theme.spacingLarge * 2
                        radius: Theme.radiusNormal
                        width: historyList.width

                        ColumnLayout {
                            id: entryColumn

                            anchors.left: parent.left
                            anchors.margins: Theme.spacingLarge
                            anchors.right: parent.right
                            anchors.top: parent.top
                            spacing: Theme.spacingNormal

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Theme.spacingNormal

                                Text {
                                    Layout.fillWidth: true
                                    color: Theme.on_surface_variant
                                    elide: Text.ElideRight
                                    font.family: Theme.mono
                                    font.pixelSize: Theme.fontCaption
                                    text: entryCard.modelData.appName
                                    textFormat: Text.PlainText
                                }
                                Text {
                                    color: Theme.on_surface_variant
                                    font.family: Theme.mono
                                    font.pixelSize: Theme.fontCaption
                                    text: Qt.formatDateTime(new Date(entryCard.modelData.timestamp), "d MMM hh:mm")
                                    textFormat: Text.PlainText
                                }
                                CenterButton {
                                    accessibleLabel: "Delete notification from " + entryCard.modelData.appName
                                    text: "✕"

                                    onClicked: Notifications.removeHistory(entryCard.modelData.id)
                                }
                            }
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Theme.spacingLarge

                                Image {
                                    Layout.alignment: Qt.AlignTop
                                    Layout.preferredHeight: Theme.buttonHeight
                                    Layout.preferredWidth: Theme.buttonHeight
                                    asynchronous: true
                                    fillMode: Image.PreserveAspectFit
                                    source: entryCard.imageSource
                                    sourceSize.height: Theme.buttonHeight * 2
                                    sourceSize.width: Theme.buttonHeight * 2
                                    visible: source.toString().length > 0 && status !== Image.Error
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: Theme.spacingSmall

                                    Text {
                                        Layout.fillWidth: true
                                        color: entryCard.modelData.urgency === 2 ? Theme.error : Theme.on_surface
                                        font.family: Theme.sans
                                        font.pixelSize: Theme.fontHeading
                                        font.weight: Font.DemiBold
                                        text: entryCard.modelData.summary
                                        textFormat: Text.PlainText
                                        visible: text.length > 0
                                        wrapMode: Text.Wrap
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        color: Theme.on_surface_variant
                                        font.family: Theme.sans
                                        font.pixelSize: Theme.fontBody
                                        text: entryCard.modelData.body
                                        textFormat: Text.PlainText
                                        visible: text.length > 0
                                        wrapMode: Text.Wrap
                                    }
                                }
                            }
                        }
                    }
                }
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: Theme.spacingMedium
                    visible: Notifications.history.length === 0
                    width: parent.width

                    Text {
                        Layout.fillWidth: true
                        color: Theme.on_surface
                        font.family: Theme.sans
                        font.pixelSize: Theme.fontHeading
                        horizontalAlignment: Text.AlignHCenter
                        text: "No notifications"
                    }
                    Text {
                        Layout.fillWidth: true
                        color: Theme.on_surface_variant
                        font.family: Theme.sans
                        font.pixelSize: Theme.fontBody
                        horizontalAlignment: Text.AlignHCenter
                        text: "New notifications will appear here.\nHistory is cleared when the shell reloads."
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }

    component CenterButton: Button {
        id: button

        property string accessibleLabel: text

        Accessible.name: accessibleLabel
        hoverEnabled: true
        implicitHeight: Theme.barWidgetHeight
        implicitWidth: Math.max(Theme.barWidgetHeight, contentItem.implicitWidth + Theme.spacingWide)
        opacity: enabled ? 1 : Theme.opacityMuted

        background: Rectangle {
            border.color: button.activeFocus ? Theme.primary : Theme.outline_variant
            border.width: 1
            color: button.down ? Theme.primary_container : button.hovered ? Theme.surface_container_highest : Theme.surface_container_high
            radius: Theme.radiusCompact
        }
        contentItem: Text {
            color: Theme.on_surface
            font.family: Theme.sans
            font.pixelSize: Theme.fontSmall
            horizontalAlignment: Text.AlignHCenter
            text: button.text
            textFormat: Text.PlainText
            verticalAlignment: Text.AlignVCenter
        }
    }
}
