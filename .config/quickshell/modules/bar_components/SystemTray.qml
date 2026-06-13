import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import qs.core
import qs.widgets
import "../../theme"

Rectangle {
    radius: 15
    border.color: Theme.outline
    border.width: 1
    color: Theme.surface_container

    clip: true
    height: 28

    Layout.preferredWidth: trayInner.implicitWidth + 16
    Layout.rightMargin: 4

    RowLayout {
        id: trayInner
        anchors.centerIn: parent
        spacing: 8

        Tray {
            iconSize: 16
        }
    }

    /* ===== Animations restored with hardcoded values ===== */

    Behavior on Layout.preferredWidth {
        NumberAnimation {
            duration: 220
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on Layout.rightMargin {
        NumberAnimation {
            duration: 220
            easing.type: Easing.InOutQuad
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 120
        }
    }
}
