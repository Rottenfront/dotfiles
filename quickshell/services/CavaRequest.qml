import QtQuick

QtObject {
    id: root

    property bool active: false
    property int request: -1

    function updateRequest(): void {
        if (active && request === -1) {
            request = Cava.acquire()
        } else if (!active && request !== -1) {
            Cava.release(request)
            request = -1
        }
    }

    Component.onCompleted: updateRequest()
    Component.onDestruction: Cava.release(request)
    onActiveChanged: updateRequest()
}
