pragma Singleton
import QtQml.Models
import QtQuick
import Quickshell.Services.Notifications

NotificationServer {
    id: notifServer

    property var _history: []
    property bool dnd: false
    readonly property var history: _history
    readonly property int historyLimit: 100
    property Instantiator historyObservers: Instantiator {
        model: notifServer.trackedNotifications

        delegate: QtObject {
            id: observer

            property Connections closedConnection: Connections {
                function onClosed(reason) {
                    notifServer.markClosed(observer.modelData.id, reason)
                }

                target: observer.modelData
            }
            required property var modelData
            readonly property var snapshot: notifServer.snapshot(modelData)

            onSnapshotChanged: notifServer.recordHistory(snapshot, false)
        }
    }

    function clearHistory() {
        _history = []
    }

    function markClosed(id, reason) {
        _history = _history.map(item => item.id === id ? Object.assign({}, item, {
                active: false,
                closeReason: reason
            }) : item)
    }

    function recordHistory(entry, allowNew) {
        const index = _history.findIndex(item => item.id === entry.id)
        if (entry.transient) {
            removeHistory(entry.id)
            return
        }
        if (index < 0 && !allowNew)
            return
        const next = _history.filter(item => item.id !== entry.id)
        _history = [entry].concat(next).slice(0, historyLimit)
    }

    function removeHistory(id) {
        _history = _history.filter(item => item.id !== id)
    }

    function snapshot(n) {
        const image = String(n.image || "")
        return {
            id: n.id,
            appName: String(n.appName || "SYSTEM").slice(0, 256),
            appIcon: String(n.appIcon || "").slice(0, 4096),
            desktopEntry: String(n.desktopEntry || "").slice(0, 256),
            summary: String(n.summary || "").slice(0, 4096),
            body: String(n.body || "").slice(0, 16384),
            image: image.startsWith("file://") ? image.slice(0, 4096) : "",
            urgency: n.urgency,
            transient: n.transient,
            timestamp: Date.now(),
            active: true,
            closeReason: -1
        }
    }

    actionsSupported: true
    bodyHyperlinksSupported: false
    bodyImagesSupported: true
    bodyMarkupSupported: true
    imageSupported: true
    keepOnReload: true
    persistenceSupported: true

    onNotification: n => {
        recordHistory(snapshot(n), true)
        n.tracked = true
    }
}
