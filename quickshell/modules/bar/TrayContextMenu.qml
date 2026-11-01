import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.theme

PanelWindow {
    id: root

    property var animCurve: [0.05, 0, 0.133, 0.06, 0.166, 0.4, 0.208, 0.82, 0.25, 1, 1, 1]
    property int animLength: Theme.durationLong
    property bool hasCurrent: false
    property var menuHandle: null
    property real menuX: 0
    property real menuY: 0

    function close() {
        hasCurrent = false
    }

    function open(handle, x, y) {
        menuHandle = handle
        let width = 240
        let safeX = x - (width / 2)
        safeX = Math.max(8, Math.min(safeX, Screen.width - width - 8))
        menuX = safeX
        menuY = y - 32
        hasCurrent = true
    }

    WlrLayershell.keyboardFocus: wrapper.visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.layer: WlrLayer.Overlay
    color: "transparent"

    mask: Region {
        item: wrapper.visible ? wrapper : null
    }

    anchors {
        bottom: true
        left: true
        right: true
        top: true
    }
    MouseArea {
        anchors.fill: parent
        enabled: wrapper.visible

        onClicked: root.close()
    }
    Item {
        id: wrapper

        readonly property real contentHeight: menuColumn.implicitHeight + 16

        clip: true
        implicitHeight: root.hasCurrent ? contentHeight : 0
        visible: height > 0
        width: 240
        x: root.menuX
        y: root.menuY

        Behavior on implicitHeight {
            NumberAnimation {
                duration: root.animLength
                easing.bezierCurve: root.animCurve
                easing.type: Easing.BezierSpline
            }
        }

        Rectangle {
            id: menuBg

            anchors.fill: parent
            border.color: Theme.outline
            clip: true
            color: Theme.surface_container
            radius: Theme.radiusPanel

            QsMenuOpener {
                id: opener

                menu: root.menuHandle
            }
            Rectangle {
                id: highlight

                property bool active: false
                property real targetY: 0

                color: Theme.secondary
                height: 26
                opacity: active ? 0.15 : 0
                radius: Theme.radiusNormal
                width: parent.width - Theme.spacingWide
                x: Theme.spacingNormal
                y: menuColumn.y + targetY

                Behavior on opacity {
                    NumberAnimation {
                        duration: Theme.durationFast
                    }
                }
                Behavior on y {
                    NumberAnimation {
                        duration: Theme.durationNormal
                        easing.overshoot: 0.8
                        easing.type: Easing.OutBack
                    }
                }
            }
            Column {
                id: menuColumn

                anchors.left: parent.left
                anchors.leftMargin: Theme.spacingNormal
                anchors.right: parent.right
                anchors.rightMargin: Theme.spacingNormal
                anchors.top: parent.top
                anchors.topMargin: Theme.spacingNormal
                spacing: Theme.spacingTiny

                Repeater {
                    model: opener.children

                    delegate: Item {
                        id: menuItem

                        property bool hasChildren: modelData.hasChildren
                        property bool isSeparator: modelData.isSeparator

                        height: isSeparator ? 10 : 26
                        width: menuColumn.width

                        Rectangle {
                            anchors.centerIn: parent
                            color: Theme.outline_variant
                            height: 1
                            opacity: 0.5
                            visible: isSeparator
                            width: parent.width - 16
                        }
                        Rectangle {
                            anchors.left: parent.left
                            anchors.leftMargin: Theme.spacingSmall
                            anchors.verticalCenter: parent.verticalCenter
                            color: Theme.primary
                            height: 16
                            radius: Theme.radiusTiny
                            visible: !isSeparator && highlight.active && highlight.targetY === menuItem.y
                            width: Theme.accentWidth
                        }
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 0
                            anchors.rightMargin: Theme.spacingLarge
                            spacing: Theme.spacingLarge
                            visible: !isSeparator

                            Item {
                                Layout.preferredHeight: 20
                                Layout.preferredWidth: 20

                                Image {
                                    anchors.centerIn: parent
                                    fillMode: Image.PreserveAspectFit
                                    height: Theme.fontIcon
                                    layer.enabled: true
                                    source: modelData.icon || ""
                                    visible: modelData.icon !== undefined && modelData.icon !== ""
                                    width: Theme.fontIcon

                                    layer.effect: MultiEffect {
                                        colorization: 1
                                        colorizationColor: (highlight.active && highlight.targetY === menuItem.y) ? Theme.primary : Theme.on_surface_variant
                                    }
                                }
                            }
                            Text {
                                Layout.fillWidth: true
                                color: (highlight.active && highlight.targetY === menuItem.y) ? Theme.on_surface : Qt.rgba(Theme.on_surface.r, Theme.on_surface.g, Theme.on_surface.b, Theme.opacityStrong)
                                elide: Text.ElideRight
                                font.bold: true
                                font.family: Theme.mono
                                font.letterSpacing: 0.2
                                font.pixelSize: Theme.size
                                text: modelData.text || ""
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                color: Theme.primary
                                font.family: Theme.mono
                                font.pixelSize: Theme.size
                                text: menuItem.hasChildren ? "" : ""
                                visible: (modelData.checkable && modelData.checked) || menuItem.hasChildren
                            }
                        }
                        MouseArea {
                            id: itemMouse

                            anchors.fill: parent
                            cursorShape: isSeparator ? Qt.ArrowCursor : Qt.PointingHandCursor
                            hoverEnabled: true

                            onClicked: {
                                if (!menuItem.isSeparator) {
                                    if (modelData.hasChildren) {
                                        root.menuHandle = modelData
                                    } else {
                                        modelData.triggered()
                                        root.close()
                                    }
                                }
                            }
                            onEntered: {
                                if (!menuItem.isSeparator) {
                                    highlight.targetY = menuItem.y
                                    highlight.active = true
                                } else {}
                            }
                        }
                    }
                }
            }
        }
    }
}
