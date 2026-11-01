import QtQuick
import QtQuick.Shapes
import qs.theme

Item {
    id: root

    property color backgroundColor: "#2a2a2a"
    property color fillColor: "#3daee9"
    property string label: ""
    property int lineWidth: Theme.spacingNormal
    property real value: 0

    height: 60
    width: 100

    Shape {
        anchors.fill: parent

        ShapePath {
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"
            strokeColor: root.backgroundColor
            strokeWidth: root.lineWidth

            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height
                radiusX: (root.width - root.lineWidth) / 2
                radiusY: radiusX
                startAngle: 180
                sweepAngle: 180
            }
        }
        ShapePath {
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"
            strokeColor: root.fillColor
            strokeWidth: root.lineWidth

            PathAngleArc {
                centerX: root.width / 2
                centerY: root.height
                radiusX: (root.width - root.lineWidth) / 2
                radiusY: radiusX
                startAngle: 180
                sweepAngle: (root.value / 100) * 180
            }
        }
    }
    Column {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: Theme.spacingMedium
        spacing: Theme.spacingTiny

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            font.bold: true
            font.pixelSize: Theme.fontIcon
            text: Math.round(root.value) + "%"
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#888888"
            font.pixelSize: Theme.fontCaption
            text: root.label
        }
    }
}
