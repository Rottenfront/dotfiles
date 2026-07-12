pragma Singleton
import QtQuick
import Quickshell.Services.Notifications
import Quickshell
import Quickshell.Io

    NotificationServer {
        id: notifServer

        actionsSupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: true
        bodyHyperlinksSupported: false
        imageSupported: true
        keepOnReload: true

        onNotification: n => {
            n.tracked = true;
        }
        property bool dnd: false
    }
