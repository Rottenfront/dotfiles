import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services as Services
import qs.theme

Rectangle {
    id: wsContainer

    readonly property int activeWs: hypr.focusedWorkspaceId
    property string fontFamily: Theme.mono
    property int fontSize: Theme.size
    readonly property var hypr: Services.Hyprland
    readonly property int pageCount: Math.max(Config.minimumWorkspacePages, Math.ceil(workspaceCount / visibleCount), Math.ceil(activeWs / visibleCount))
    readonly property int visibleCount: Config.workspacesPerPage
    readonly property int workspaceCount: Math.max(Config.workspacesPerPage, hypr.workspaceIds.length)

    function changeWorkspace(id) {
        Services.Hyprland.changeWorkspace(id)
    }

    function changeWorkspaceRelative(delta) {
        changeWorkspace(activeWs + delta)
    }

    Layout.preferredHeight: Theme.barWidgetHeight
    Layout.preferredWidth: visibleCount * Theme.workspaceSize + (visibleCount - 1) * Theme.spacingSmall + Theme.spacingSmall
    border.color: Theme.outline
    border.width: 1
    clip: true
    color: Theme.surface_container
    radius: Theme.radiusLarge

    ListView {
        id: pager

        anchors.fill: parent
        currentIndex: Math.floor((wsContainer.activeWs - 1) / wsContainer.visibleCount)
        highlightMoveDuration: Theme.durationLong
        highlightRangeMode: ListView.StrictlyEnforceRange
        interactive: false
        model: wsContainer.pageCount
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem

        delegate: Item {
            id: page

            required property int index
            property var pageOccupiedRanges: []
            property int startWs: index * wsContainer.visibleCount + 1

            function updatePageOccupied() {
                const ranges = []
                let start = -1
                for (let i = 0; i < wsContainer.visibleCount; i++) {
                    const wsId = startWs + i
                    if (wsContainer.hypr.isWorkspaceOccupied(wsId)) {
                        if (start === -1)
                            start = i
                    } else if (start !== -1) {
                        ranges.push({
                            start,
                            end: i - 1
                        })
                        start = -1
                    }
                }
                if (start !== -1)
                    ranges.push({
                        start,
                        end: wsContainer.visibleCount - 1
                    })
                pageOccupiedRanges = ranges
            }

            height: wsContainer.height
            width: wsContainer.width

            Component.onCompleted: updatePageOccupied()

            Connections {
                function onStateChanged() {
                    page.updatePageOccupied()
                }

                target: wsContainer.hypr
            }
            Repeater {
                model: page.pageOccupiedRanges

                Rectangle {
                    required property var modelData

                    color: Theme.background
                    height: Theme.workspaceSize
                    opacity: Theme.opacityStrong
                    radius: Theme.radiusMedium
                    width: (modelData.end - modelData.start + 1) * Theme.workspaceSize + (modelData.end - modelData.start) * Theme.spacingSmall
                    x: modelData.start * (Theme.workspaceSize + Theme.spacingSmall) + Theme.spacingTiny
                    y: 1
                }
            }
            Rectangle {
                property int localIndex: wsContainer.activeWs - page.startWs

                color: Theme.primary
                height: Theme.workspaceSize
                radius: Theme.radiusPill
                visible: localIndex >= 0 && localIndex < wsContainer.visibleCount
                width: Theme.workspaceSize
                x: localIndex * (Theme.workspaceSize + Theme.spacingSmall) + Theme.spacingTiny
                y: 1

                Behavior on x {
                    NumberAnimation {
                        duration: Theme.durationQuick
                        easing.type: Easing.OutSine
                    }
                }
            }
            Row {
                anchors.fill: parent
                anchors.margins: Theme.spacingTiny
                spacing: Theme.spacingSmall

                Repeater {
                    model: wsContainer.visibleCount

                    Item {
                        id: workspace

                        property bool hasWindows: wsContainer.hypr.isWorkspaceOccupied(wsId)
                        required property int index
                        property bool isActive: wsId === wsContainer.activeWs
                        property int wsId: page.startWs + index

                        height: Theme.workspaceSize
                        width: Theme.workspaceSize

                        Text {
                            anchors.centerIn: parent
                            color: workspace.isActive ? Theme.background : workspace.hasWindows ? Theme.primary : Theme.on_surface
                            font.bold: true
                            font.family: wsContainer.fontFamily
                            font.pixelSize: wsContainer.fontSize
                            text: workspace.wsId
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked: wsContainer.changeWorkspace(workspace.wsId)
                        }
                    }
                }
            }
        }
    }
}
