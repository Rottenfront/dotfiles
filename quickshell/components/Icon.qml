import QtQuick
import QtQuick.Layouts
import qs.theme

Text {
    id: root

    property string icon: ""

    Layout.alignment: Qt.AlignBaseline
    font.family: Theme.symbols
    font.pixelSize: Theme.fontIcon
    horizontalAlignment: Text.AlignHCenter
    text: icon
    verticalAlignment: Text.AlignVCenter
}
