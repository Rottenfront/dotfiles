import QtQuick
import QtQuick.Layouts
import qs.theme

Rectangle {
    Layout.preferredWidth: trayInner.implicitWidth + Theme.barPaddingCompact
    Layout.rightMargin: Theme.spacingSmall
    border.color: Theme.outline
    border.width: 1
    clip: true
    color: Theme.surface_container
    height: Theme.barWidgetHeight
    radius: Theme.radiusPanel

    Behavior on Layout.preferredWidth {
        NumberAnimation {
            duration: Theme.durationExpand
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on Layout.rightMargin {
        NumberAnimation {
            duration: Theme.durationExpand
            easing.type: Easing.InOutQuad
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration: Theme.durationShort
        }
    }

    RowLayout {
        id: trayInner

        anchors.centerIn: parent
        spacing: Theme.spacingNormal

        Tray {
            iconSize: Theme.fontIcon
        }
    }
}
