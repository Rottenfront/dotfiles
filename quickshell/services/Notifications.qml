pragma Singleton
import QtQuick
import Quickshell.Services.Notifications

NotificationServer {
    id: notifServer

    property bool dnd: false

    actionsSupported: true
    bodyHyperlinksSupported: false
    bodyImagesSupported: true
    bodyMarkupSupported: true
    imageSupported: true
    keepOnReload: true

    onNotification: n => {
        n.tracked = true
    }
}
