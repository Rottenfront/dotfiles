pragma Singleton
import QtQuick
import Quickshell.Services.Notifications
import Quickshell
import Quickshell.Io

Singleton {
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

            if (!dnd)
                notifSound.start();
        }
        property bool dnd: false
    }
    Process {
        id: notifSound
        running: false
        command: ["canberra-gtk-play", "-i", "message-new-instant"]
    }
}
