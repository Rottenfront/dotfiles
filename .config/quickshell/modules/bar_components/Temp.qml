import QtQuick
import qs.services as Services
import "../../theme"
import qs.Core

Rectangle {
    radius: 14
    border.color: Theme.outline
    border.width: 1
    color: Theme.surface_container
    implicitHeight: 28
    implicitWidth: temp.implicitWidth + 16

    Text {
        id: temp
        anchors.centerIn: parent

        font.pixelSize: Theme.size
        font.family: Theme.mono
        color: tempColor

        text: tempIcon + " " + Services.System.temp + "°C"
    }

    property int t: Services.System.temp

    property string tempIcon: {
        if (t >= 85) return Icons.fire
        if (t >= 50) return Icons.temperatureMedium
        return Icons.temperature
    }

    property color tempColor: {
        if (t >= 85) return Theme.error
        if (t >= 70) return Theme.on_surface
        return Theme.on_surface
    }
}
