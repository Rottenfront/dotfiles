import QtQuick
import QtQuick.Layouts
import qs.theme

Rectangle {
    id: root
    required property real value
    required property real maxValue
    required property string icon
    // height: 100
    Layout.fillHeight: true
    implicitWidth: 40
    implicitHeight: mainLayout.implicitHeight + 25
    color: Theme.background
    radius: 20
    clip: true
    border.color: Theme.outline
    border.width: 1

    ColumnLayout {
        id: mainLayout
        y: 10
        width: parent.width

        Layout.alignment: Qt.AlignHCenter

        spacing: 12
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: icon
            color: Theme.on_surface
            font.family: "Material Design Icons"
            font.pixelSize: 18
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            width: 8
            height: 100
            radius: 4
            color: Theme.surface

            Rectangle {
                height: Math.min(parent.height * (value / maxValue), parent.height)
                width: parent.width
                color: Theme.primary
                radius: 4

                Behavior on height {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }

    Behavior on x {
        NumberAnimation {
            duration: 200
            // easing.type: easing.outcubic
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration: 200
            // easing.type: easing.outcubic
        }
    }
}
