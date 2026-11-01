import QtQuick
import qs.components
import qs.services as Services
import qs.theme

Rectangle {
    property int t: Services.System.temp
    property color tempColor: {
        if (t >= 85)
            return Theme.error
        if (t >= 70)
            return Theme.on_surface
        return Theme.on_surface
    }
    property string tempIcon: {
        if (t >= 85)
            return Icons.fire
        if (t >= 50)
            return Icons.temperatureMedium
        return Icons.temperature
    }

    border.color: Theme.outline
    border.width: 1
    color: Theme.surface_container
    implicitHeight: Theme.barWidgetHeight
    implicitWidth: temp.implicitWidth + Theme.barPaddingCompact
    radius: Theme.radiusPill

    Text {
        id: temp

        anchors.centerIn: parent
        color: tempColor
        font.family: Theme.mono
        font.pixelSize: Theme.size
        text: tempIcon + " " + Services.System.temp + "°C"
    }
}
