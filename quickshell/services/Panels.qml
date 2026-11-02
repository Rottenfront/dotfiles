pragma Singleton

import QtQuick

QtObject {
    id: root

    property bool clipboardOpen: false
    property bool musicOpen: false
    property bool notificationsOpen: false

    function closeAll(): void {
        clipboardOpen = false
        musicOpen = false
        notificationsOpen = false
    }

    function toggleClipboard(): void {
        const open = !clipboardOpen
        closeAll()
        clipboardOpen = open
    }

    function toggleMusic(): void {
        const open = !musicOpen
        closeAll()
        musicOpen = open
    }

    function toggleNotifications(): void {
        const open = !notificationsOpen
        closeAll()
        notificationsOpen = open
    }
}
