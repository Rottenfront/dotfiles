import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules
import qs.theme

ShellRoot {
    id: root

    property bool barVisible: true
    readonly property ControlCenter controlCenter: controlCenterLoader.item as ControlCenter

    NotificationWidget {}
    Visualizer {
        id: musicVis
    }
    OsdWindow {}
    PanelWindow {
        id: rootPanel

        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        focusable: false
        implicitHeight: screen.height
        implicitWidth: screen.width

        mask: Region {
            Region {
                height: topBar.height + Math.min(0, topBar.y)
                width: topBar.width
                x: topBar.x
                y: Math.max(0, topBar.y)
            }
            Region {
                item: root.controlCenter?.visible ? root.controlCenter : null
            }
        }

        anchors {
            bottom: true
            left: true
            right: true
            top: true
        }
        PanelWindow {
            color: "transparent"
            focusable: false
            implicitHeight: barVisible ? topBar.height : 0
            implicitWidth: 0
            mask: rootPanel.mask

            anchors {
                top: true
            }
        }
        TopBar {
            id: topBar

            y: root.barVisible ? 0 : -height

            Behavior on opacity {
                NumberAnimation {
                    duration: Theme.durationFade
                    easing.type: Easing.InOutQuad
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: Theme.durationFade
                    easing.type: Easing.OutCubic
                }
            }
        }
        Loader {
            id: controlCenterLoader

            active: false
            anchors.fill: parent
            focus: true

            sourceComponent: ControlCenter {}
        }
    }
    IpcHandler {
        function toggle(): void {
            if (!controlCenterLoader.active)
                controlCenterLoader.active = true
            if (root.controlCenter)
                root.controlCenter.opened = !root.controlCenter.opened
        }

        target: "ctrl"
    }
    IpcHandler {
        function toggle(): void {
            musicVis.visible = !musicVis.visible
        }

        target: "musicVis"
    }
    IpcHandler {
        function hide(): void {
            root.barVisible = false
        }

        function show(): void {
            root.barVisible = true
        }

        function toggle(): void {
            root.barVisible = !root.barVisible
        }

        target: "bar"
    }
}
