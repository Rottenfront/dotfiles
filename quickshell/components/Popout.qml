pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes
import qs.theme

Item {
    id: root

    readonly property real _clampedRH: Math.min(root._r, root._halfH)
    readonly property real _clampedRH3: Math.min(root._r, root._thirdH)
    readonly property real _clampedRW: Math.min(root._r, root._halfW)
    readonly property real _halfH: root.height * 0.5
    readonly property real _halfW: root.width * 0.5
    readonly property real _r: root.radius
    readonly property real _r2: root.radius * 2
    readonly property real _thirdH: root.height / 3
    property int alignment: 0
    property color color: Theme.background
    default property alias content: contentWrapper.data
    property int radius: 50

    antialiasing: true
    layer.enabled: true
    layer.samples: 16
    layer.smooth: true
    smooth: true

    Loader {
        anchors.fill: parent
        asynchronous: true
        sourceComponent: {
            const shapes = [attachedTop, attachedTopRight, attachedRight, attachedBottomRight, attachedBottom, attachedBottomLeft, attachedLeft, attachedTopLeft]
            return root.alignment >= 0 && root.alignment < 8 ? shapes[root.alignment] : null
        }
    }
    Item {
        id: contentWrapper

        anchors.fill: parent
        anchors.margins: root.radius
    }
    Component {
        id: attachedTop

        BubbleShape {
            id: topShape

            PathMove {
                x: 0
                y: 0
            }
            PathArc {
                radiusX: root._r
                radiusY: root._clampedRH
                x: root._r
                y: root._clampedRH
            }
            PathLine {
                x: root._r
                y: Math.max(topShape.height - root._r, root._halfH)
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._r
                radiusY: root._clampedRH
                x: root._r2
                y: topShape.height
            }
            PathLine {
                x: topShape.width - root._r2
                y: topShape.height
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._r
                radiusY: root._clampedRH
                x: topShape.width - root._r
                y: Math.max(topShape.height - root._r, root._halfH)
            }
            PathLine {
                x: topShape.width - root._r
                y: root._clampedRH
            }
            PathArc {
                radiusX: root._r
                radiusY: root._clampedRH
                x: topShape.width
                y: 0
            }
            PathLine {
                x: 0
                y: 0
            }
        }
    }
    Component {
        id: attachedTopRight

        BubbleShape {
            id: topRightShape

            PathMove {
                x: 0
                y: 0
            }
            PathArc {
                radiusX: root._r
                radiusY: root._clampedRH3
                x: root._r
                y: root._clampedRH3
            }
            PathLine {
                x: root._r
                y: Math.max(topRightShape.height - root._r2, root._thirdH)
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._r
                radiusY: root._clampedRH3
                x: root._r2
                y: Math.max(topRightShape.height - root._r, 2 * root._thirdH)
            }
            PathLine {
                x: topRightShape.width - root._r
                y: Math.max(topRightShape.height - root._r, 2 * root._thirdH)
            }
            PathArc {
                radiusX: root._r
                radiusY: root._clampedRH3
                x: topRightShape.width
                y: topRightShape.height
            }
            PathLine {
                x: topRightShape.width
                y: 0
            }
            PathLine {
                x: 0
                y: 0
            }
        }
    }
    Component {
        id: attachedRight

        BubbleShape {
            id: rightShape

            PathMove {
                x: rightShape.width
                y: rightShape.height
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._clampedRW
                radiusY: root._r
                x: Math.max(rightShape.width - root._r, root._halfW)
                y: rightShape.height - root._r
            }
            PathLine {
                x: root._clampedRW
                y: rightShape.height - root._r
            }
            PathArc {
                radiusX: root._clampedRW
                radiusY: root._r
                x: 0
                y: rightShape.height - root._r2
            }
            PathLine {
                x: 0
                y: root._r2
            }
            PathArc {
                radiusX: root._clampedRW
                radiusY: root._r
                x: root._clampedRW
                y: root._r
            }
            PathLine {
                x: Math.max(rightShape.width - root._r, root._halfW)
                y: root._r
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._clampedRW
                radiusY: root._r
                x: rightShape.width
                y: 0
            }
            PathLine {
                x: rightShape.width
                y: rightShape.height
            }
        }
    }
    Component {
        id: attachedBottomRight

        BubbleShape {
            id: bottomRightShape

            PathMove {
                x: 0
                y: bottomRightShape.height
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._r
                radiusY: root._clampedRH3
                x: root._r
                y: Math.max(bottomRightShape.height - root._r, 2 * root._thirdH)
            }
            PathLine {
                x: root._r
                y: root._r2
            }
            PathArc {
                radiusX: root._r
                radiusY: root._clampedRH3
                x: root._r2
                y: root._r
            }
            PathLine {
                x: bottomRightShape.width - root._r
                y: root._r
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._r
                radiusY: root._clampedRH3
                x: bottomRightShape.width
                y: 0
            }
            PathLine {
                x: bottomRightShape.width
                y: bottomRightShape.height
            }
            PathLine {
                x: 0
                y: bottomRightShape.height
            }
        }
    }
    Component {
        id: attachedBottom

        BubbleShape {
            id: bottomShape

            PathMove {
                x: 0
                y: bottomShape.height
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._r
                radiusY: root._clampedRH
                x: root._r
                y: Math.max(bottomShape.height - root._r, root._halfH)
            }
            PathLine {
                x: root._r
                y: root._clampedRH
            }
            PathArc {
                radiusX: root._r
                radiusY: root._clampedRH
                x: root._r2
                y: 0
            }
            PathLine {
                x: bottomShape.width - root._r2
                y: 0
            }
            PathArc {
                radiusX: root._r
                radiusY: root._clampedRH
                x: bottomShape.width - root._r
                y: root._clampedRH
            }
            PathLine {
                x: bottomShape.width - root._r
                y: Math.max(bottomShape.height - root._r, root._halfH)
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._r
                radiusY: root._clampedRH
                x: bottomShape.width
                y: bottomShape.height
            }
            PathLine {
                x: 0
                y: bottomShape.height
            }
        }
    }
    Component {
        id: attachedBottomLeft

        BubbleShape {
            id: bottomLeftShape

            PathMove {
                x: bottomLeftShape.width
                y: bottomLeftShape.height
            }
            PathArc {
                radiusX: root._r
                radiusY: root._clampedRH3
                x: bottomLeftShape.width - root._r
                y: Math.max(bottomLeftShape.height - root._r, 2 * root._thirdH)
            }
            PathLine {
                x: bottomLeftShape.width - root._r
                y: root._r2
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._r
                radiusY: root._clampedRH3
                x: bottomLeftShape.width - root._r2
                y: root._r
            }
            PathLine {
                x: root._r
                y: root._r
            }
            PathArc {
                radiusX: root._r
                radiusY: root._clampedRH3
                x: 0
                y: 0
            }
            PathLine {
                x: 0
                y: bottomLeftShape.height
            }
            PathLine {
                x: bottomLeftShape.width
                y: bottomLeftShape.height
            }
        }
    }
    Component {
        id: attachedLeft

        BubbleShape {
            id: leftShape

            PathMove {
                x: 0
                y: 0
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._clampedRW
                radiusY: root._r
                x: root._clampedRW
                y: root._r
            }
            PathLine {
                x: Math.max(leftShape.width - root._r, root._halfW)
                y: root._r
            }
            PathArc {
                radiusX: root._clampedRW
                radiusY: root._r
                x: leftShape.width
                y: root._r2
            }
            PathLine {
                x: leftShape.width
                y: leftShape.height - root._r2
            }
            PathArc {
                radiusX: root._clampedRW
                radiusY: root._r
                x: Math.max(leftShape.width - root._r, root._halfW)
                y: leftShape.height - root._r
            }
            PathLine {
                x: root._clampedRW
                y: leftShape.height - root._r
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._clampedRW
                radiusY: root._r
                x: 0
                y: leftShape.height
            }
            PathLine {
                x: 0
                y: 0
            }
        }
    }
    Component {
        id: attachedTopLeft

        BubbleShape {
            id: topLeftShape

            PathMove {
                x: topLeftShape.width
                y: 0
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._r
                radiusY: root._clampedRH3
                x: topLeftShape.width - root._r
                y: root._clampedRH3
            }
            PathLine {
                x: topLeftShape.width - root._r
                y: Math.max(topLeftShape.height - root._r2, root._thirdH)
            }
            PathArc {
                radiusX: root._r
                radiusY: root._clampedRH3
                x: topLeftShape.width - root._r2
                y: Math.max(topLeftShape.height - root._r, 2 * root._thirdH)
            }
            PathLine {
                x: root._r
                y: Math.max(topLeftShape.height - root._r, 2 * root._thirdH)
            }
            PathArc {
                direction: PathArc.Counterclockwise
                radiusX: root._r
                radiusY: root._clampedRH3
                x: 0
                y: topLeftShape.height
            }
            PathLine {
                x: 0
                y: 0
            }
            PathLine {
                x: topLeftShape.width
                y: 0
            }
        }
    }

    component BubbleShape: Shape {
        default property alias pathElements: shapePath.pathElements

        anchors.fill: parent
        antialiasing: true
        layer.enabled: true
        layer.samples: 16
        layer.smooth: true
        smooth: true

        ShapePath {
            id: shapePath

            capStyle: ShapePath.RoundCap
            fillColor: root.color
            joinStyle: ShapePath.RoundJoin
            // This outline thing still isn't ready yet.. [very unstable like rendering issues].
            strokeColor: Theme.background
            strokeWidth: 0
        }
    }
}
