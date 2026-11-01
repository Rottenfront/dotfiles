import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.services
import qs.theme

Scope {
    id: root

    readonly property int criticalTimeout: Config.criticalNotificationTimeout
    readonly property int defaultTimeout: Config.notificationTimeout
    readonly property int leftMargin: Theme.paddingLarge
    readonly property var notifServer: Notifications
    readonly property int notifSpacing: Theme.spacingMedium
    readonly property int notifWidth: 360
    readonly property int topOffsetPercent: 6
    readonly property var tracked: Notifications.trackedNotifications

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel

            required property ShellScreen modelData

            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "notifications"
            color: "transparent"
            implicitWidth: root.notifWidth + root.leftMargin + 40
            screen: modelData

            mask: Region {
                height: {
                    column.layoutTrigger
                    let h = 0
                    for (let i = 0; i < column.children.length; i++) {
                        const c = column.children[i]
                        if (c && c.isNotifItem === true && c.height > 0) {
                            h += c.height + root.notifSpacing
                        }
                    }
                    return Math.max(0, h - root.notifSpacing)
                }
                width: notifRepeater.count > 0 ? root.notifWidth : 0
                x: column.x
                y: column.y
            }

            anchors {
                bottom: true
                right: true
                top: true
            }
            Item {
                id: column

                property int layoutTrigger: 0

                anchors.left: parent.left
                anchors.leftMargin: root.leftMargin
                anchors.top: parent.top
                anchors.topMargin: parent.height * root.topOffsetPercent / 100
                height: parent.height - anchors.topMargin
                width: root.notifWidth

                Repeater {
                    id: notifRepeater

                    model: root.tracked

                    delegate: NotifItem {
                        required property int index
                        required property var modelData

                        itemIndex: index
                        notification: modelData
                        width: root.notifWidth

                        onHeightChanged: column.layoutTrigger++
                    }

                    onItemAdded: column.layoutTrigger++
                    onItemRemoved: column.layoutTrigger++
                }
            }
        }
    }

    component NotifItem: Item {
        id: notif

        readonly property color bgColor: Theme.background
        readonly property bool isNotifItem: true
        property int itemIndex: 0
        property var notification: null
        readonly property color outlineColor: {
            if (urgency === 2)
                return Theme.error_container
            if (urgency === 0)
                return Theme.surface_variant
            return Theme.outline
        }
        readonly property color textColor: {
            if (urgency === 2)
                return Theme.error
            if (urgency === 0)
                return Theme.on_surface_variant
            return Theme.on_surface
        }
        readonly property int urgency: notification ? notification.urgency : 1
        readonly property string urgencyLabel: {
            if (urgency === 2)
                return "CRITICAL"
            if (urgency === 0)
                return "INFO"
            return "NOTICE"
        }

        height: implicitHeight
        implicitHeight: card.implicitHeight
        state: "entering"
        visible: !Notifications.dnd

        // Stack below preceding notifications, including their animated heights.
        y: {
            let acc = 0
            const parentItem = parent
            if (!parentItem)
                return 0
            for (let i = 0; i < parentItem.children.length; i++) {
                const c = parentItem.children[i]
                if (c === notif)
                    break
                if (c && c.isNotifItem === true) {
                    acc += c.height + root.notifSpacing
                }
            }
            return acc
        }

        states: [
            State {
                name: "entering"

                PropertyChanges {
                    card.cardOpacity: 0
                    card.xOffset: -40
                    scanLine.scanProgress: 0
                }
            },
            State {
                name: "visible"

                PropertyChanges {
                    card.cardOpacity: 1
                    card.xOffset: 0
                    scanLine.scanProgress: 1
                }
            },
            State {
                name: "closing"

                PropertyChanges {
                    card.cardOpacity: 0
                    card.xOffset: 30
                }
            }
        ]
        transitions: [
            Transition {
                from: "entering"
                to: "visible"

                ParallelAnimation {
                    NumberAnimation {
                        duration: 360
                        easing.type: Easing.OutCubic
                        property: "xOffset"
                        target: card
                    }
                    NumberAnimation {
                        duration: 240
                        property: "cardOpacity"
                        target: card
                    }
                    NumberAnimation {
                        duration: 550
                        easing.type: Easing.OutQuad
                        from: 0
                        property: "scanProgress"
                        target: scanLine
                        to: 1
                    }
                }
            },
            Transition {
                from: "visible"
                to: "closing"

                SequentialAnimation {
                    NumberAnimation {
                        duration: Theme.durationInstant
                        from: 0
                        property: "xShake"
                        target: card
                        to: 6
                    }
                    NumberAnimation {
                        duration: Theme.durationInstant
                        from: 6
                        property: "xShake"
                        target: card
                        to: -4
                    }
                    NumberAnimation {
                        duration: Theme.durationInstant
                        from: -4
                        property: "xShake"
                        target: card
                        to: 0
                    }
                    ParallelAnimation {
                        NumberAnimation {
                            duration: Theme.durationExit
                            easing.type: Easing.InCubic
                            property: "xOffset"
                            target: card
                        }
                        NumberAnimation {
                            duration: Theme.durationExit
                            property: "cardOpacity"
                            target: card
                        }
                    }
                    ScriptAction {
                        script: {
                            if (notif.notification)
                                notif.notification.dismiss()
                        }
                    }
                }
            }
        ]
        Behavior on y {
            NumberAnimation {
                duration: Theme.durationExit
                easing.type: Easing.OutCubic
            }
        }

        // Defer the entrance until the initial state has been applied.
        Component.onCompleted: {
            Qt.callLater(() => {
                if (notif.state === "entering")
                    notif.state = "visible"
            })
        }

        Timer {
            id: closeTimer

            interval: {
                if (!notif.notification)
                    return root.defaultTimeout
                const t = notif.notification.expireTimeout
                if (t < 0 || t === 0) {
                    return notif.urgency === 2 ? root.criticalTimeout : root.defaultTimeout
                }
                return t
            }
            repeat: false
            running: notif.state === "visible"

            onTriggered: notif.state = "closing"
        }
        Rectangle {
            id: card

            property real cardOpacity: 0
            property real xOffset: 0
            property real xShake: 0

            border.color: notif.outlineColor
            border.width: 1
            color: notif.bgColor
            implicitHeight: contentCol.implicitHeight + Theme.spacingLarge
            opacity: cardOpacity
            radius: Theme.radiusPanel
            width: parent.width
            x: xOffset + xShake

            Rectangle {
                id: scanLine

                property real scanProgress: 0

                clip: true
                height: parent.height
                opacity: scanProgress > 0 && scanProgress < 1 ? 1 : 0
                width: 80
                x: scanProgress * parent.width - 40
                y: 0
                z: 2

                gradient: Gradient {
                    orientation: Gradient.Horizontal

                    GradientStop {
                        color: "transparent"
                        position: 0
                    }
                    GradientStop {
                        color: "#406e2a2a"
                        position: 0.5
                    }
                    GradientStop {
                        color: "transparent"
                        position: 1
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.durationQuick
                    }
                }
            }

            // Decorative grid.
            Canvas {
                anchors.fill: parent
                anchors.leftMargin: 3
                opacity: 0.18
                z: 0

                onPaint: {
                    const ctx = getContext("2d")
                    ctx.strokeStyle = "rgba(70, 63, 46, 0.25)"
                    ctx.lineWidth = 1
                    for (let x = 0; x < width; x += 16) {
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                    }
                    for (let y = 0; y < height; y += 16) {
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }
                }
            }
            ColumnLayout {
                id: contentCol

                anchors.left: parent.left
                anchors.leftMargin: Theme.spacingSection
                anchors.right: parent.right
                anchors.rightMargin: Theme.spacingLarge
                anchors.top: parent.top
                anchors.topMargin: Theme.spacingMedium
                spacing: Theme.spacingCompact
                z: 1

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingNormal

                    Text {
                        Layout.fillWidth: true
                        color: Theme.on_surface_variant
                        elide: Text.ElideRight
                        font.family: Theme.mono
                        font.letterSpacing: Theme.letterSpacingWide
                        font.pixelSize: Theme.fontCaption
                        text: notif.urgencyLabel + " | " + (notif.notification ? (notif.notification.appName || "SYSTEM").toUpperCase() : "SYSTEM")
                    }
                    Text {
                        color: Theme.on_surface_variant
                        font.family: Theme.mono
                        font.letterSpacing: 1
                        font.pixelSize: Theme.fontCaption
                        text: Qt.formatTime(new Date(), "hh:mm")
                    }
                    Rectangle {
                        Layout.preferredHeight: 14
                        Layout.preferredWidth: 16
                        border.color: notif.outlineColor
                        border.width: 1
                        color: closeMouse.containsMouse ? notif.textColor : "transparent"

                        Behavior on color {
                            ColorAnimation {
                                duration: Theme.durationShort
                            }
                        }

                        Text {
                            anchors.centerIn: parent
                            color: closeMouse.containsMouse ? notif.bgColor : notif.textColor
                            font.family: Theme.mono
                            font.pixelSize: Theme.fontMicro
                            text: "✕"

                            Behavior on color {
                                ColorAnimation {
                                    duration: Theme.durationShort
                                }
                            }
                        }
                        MouseArea {
                            id: closeMouse

                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onClicked: notif.state = "closing"
                        }
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 1
                    color: notif.textColor
                    opacity: 0.2
                }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.spacingLarge

                    Item {
                        id: imageWrap

                        readonly property string imageSource: {
                            if (!notif.notification)
                                return ""
                            // Prefer the embedded image, then a file path or themed app icon.
                            const image = notif.notification.image || ""
                            if (image.length > 0)
                                return image
                            const appIcon = notif.notification.appIcon || ""
                            if (appIcon.length > 0) {
                                if (appIcon.startsWith("/") || appIcon.startsWith("file://"))
                                    return appIcon
                                return Quickshell.iconPath(appIcon, true)
                            }
                            return ""
                        }

                        Layout.alignment: Qt.AlignTop
                        Layout.preferredHeight: 64
                        Layout.preferredWidth: 64
                        visible: imageSource.length > 0

                        Rectangle {
                            anchors.left: parent.left
                            anchors.top: parent.top
                            border.color: notif.outlineColor
                            height: 10
                            width: 14
                            z: 2

                            Text {
                                anchors.centerIn: parent
                                color: notif.textColor
                                font.family: Theme.mono
                                font.letterSpacing: 0.5
                                font.pixelSize: 7
                                text: String(notif.itemIndex + 1).padStart(2, "0")
                            }
                        }
                        Image {
                            anchors.fill: parent
                            anchors.margins: Theme.spacingTiny
                            asynchronous: true
                            cache: true
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                            source: imageWrap.imageSource
                            sourceSize.height: 128
                            sourceSize.width: 128
                            visible: status === Image.Ready
                        }
                    }
                    ColumnLayout {
                        Layout.alignment: Qt.AlignTop
                        Layout.fillWidth: true
                        spacing: Theme.spacingSmall

                        Text {
                            Layout.fillWidth: true
                            color: notif.textColor
                            elide: Text.ElideRight
                            font.family: Theme.mono
                            font.letterSpacing: 0.8
                            font.pixelSize: Theme.fontHeading
                            font.weight: Font.Bold
                            maximumLineCount: 2
                            text: notif.notification ? notif.notification.summary : ""
                            visible: text.length > 0
                            wrapMode: Text.WordWrap
                        }
                        Text {
                            Layout.fillWidth: true
                            color: notif.textColor
                            elide: Text.ElideRight
                            font.family: Theme.mono
                            font.letterSpacing: Theme.sectionLetterSpacing
                            font.pixelSize: Theme.fontBody
                            font.weight: Font.Medium
                            lineHeight: 1.4
                            maximumLineCount: 4
                            text: notif.notification ? notif.notification.body.replace(/&quot;/g, "\"") : ""
                            textFormat: Text.PlainText
                            visible: text.length > 0
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                // Notification actions are exposed directly as an ObjectModel.
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: Theme.spacingSmall
                    spacing: Theme.spacingCompact
                    visible: actionRepeater.count > 0

                    Repeater {
                        id: actionRepeater

                        model: notif.notification ? notif.notification.actions : null

                        delegate: Rectangle {
                            id: action

                            required property var modelData

                            Layout.preferredHeight: 22
                            Layout.preferredWidth: actionText.implicitWidth + Theme.spacingWide
                            border.color: notif.outlineColor
                            border.width: 1
                            color: actMouse.containsMouse ? notif.textColor : "transparent"

                            Behavior on color {
                                ColorAnimation {
                                    duration: Theme.durationShort
                                }
                            }

                            Text {
                                id: actionText

                                anchors.centerIn: parent
                                color: actMouse.containsMouse ? notif.bgColor : notif.textColor
                                font.family: Theme.mono
                                font.letterSpacing: 1.5
                                font.pixelSize: Theme.fontMicro
                                text: `▸ ${(action.modelData?.text ?? "").toUpperCase()}`

                                Behavior on color {
                                    ColorAnimation {
                                        duration: Theme.durationShort
                                    }
                                }
                            }
                            MouseArea {
                                id: actMouse

                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true

                                onClicked: {
                                    if (action.modelData)
                                        action.modelData.invoke()
                                    notif.state = "closing"
                                }
                            }
                        }
                    }
                }
                Item {
                    Layout.preferredHeight: Theme.spacingSmall
                }
            }

            // Pause dismissal while the pointer is over the card.
            MouseArea {
                acceptedButtons: Qt.MiddleButton
                anchors.fill: parent
                hoverEnabled: true
                propagateComposedEvents: true
                z: 0

                onClicked: m => {
                    if (m.button === Qt.MiddleButton)
                        notif.state = "closing"
                }
                onEntered: closeTimer.stop()
                onExited: {
                    if (notif.state === "visible")
                        closeTimer.restart()
                }
            }
        }
    }
}
