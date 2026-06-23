pragma Singleton
import QtQuick
import Quickshell.Services.Notifications

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
