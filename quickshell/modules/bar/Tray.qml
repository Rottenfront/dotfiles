import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import qs.theme

RowLayout {
    id: trayRoot

    property var blacklist: []
    property bool hidePassive: false
    property int iconSize: Theme.fontIcon
    property var pinnedApps: []

    spacing: Theme.spacingCompact

    Repeater {
        model: SystemTray.items.values

        delegate: Rectangle {
            Layout.preferredHeight: visible ? trayRoot.iconSize + 10 : 0
            Layout.preferredWidth: visible ? trayRoot.iconSize + 10 : 0
            color: itemMouseArea.containsMouse ? Theme.primary_container : "transparent"
            height: visible ? trayRoot.iconSize + 10 : 0
            radius: 6
            // Filter here instead
            visible: {
                let item = modelData
                if (!item)
                    return false
                if (trayRoot.blacklist.some(name => item.id.toLowerCase().includes(name.toLowerCase())))
                    return false
                if (trayRoot.hidePassive && item.status === SystemTrayStatus.Passive)
                    return false
                return true
            }
            width: visible ? trayRoot.iconSize + 10 : 0

            Image {
                id: trayIcon

                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                height: trayRoot.iconSize
                smooth: true
                source: modelData.icon || ""
                visible: status === Image.Ready || status === Image.Loading
                width: trayRoot.iconSize
            }

            // ---------- fallback ----------
            Text {
                anchors.centerIn: parent
                color: Theme.on_surface
                font.pixelSize: Theme.fontCaption
                text: trayIcon.status === Image.Error ? "?" : ""
                visible: trayIcon.status === Image.Error
            }

            // ---------- interactions ----------
            MouseArea {
                id: itemMouseArea

                acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton)
                        modelData.activate()
                    else if (mouse.button === Qt.MiddleButton)
                        modelData.secondaryActivate()
                    else if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                        const pos = mapToGlobal(width / 2, height)
                        contextMenu.open(modelData.menu, pos.x, pos.y)
                    }
                }
            }
        }
    }
    TrayContextMenu {
        id: contextMenu
    }
}
