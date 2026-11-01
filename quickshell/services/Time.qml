pragma Singleton
import QtQuick
import Quickshell

Singleton {
    readonly property SystemClock clock: systemClock
    property alias date: systemClock.date

    function format(fmt) {
        return Qt.formatDateTime(systemClock.date, fmt)
    }

    SystemClock {
        id: systemClock

        precision: SystemClock.Seconds
    }
}
