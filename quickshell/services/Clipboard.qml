pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool active: false
    readonly property bool busy: actionProc.running || pasteProc.running
    property var entries: []
    property string error: ""
    property bool focusReady: false
    readonly property string helper: decodeURIComponent(Qt.resolvedUrl("../scripts/clipboard.py").toString().replace(/^file:\/\//, ""))
    readonly property bool loading: listProc.running
    property string pendingAddress: ""
    property string pendingMods: "CTRL"
    property bool refreshPending: false
    property int session: 0
    property string targetAddress: ""
    property string targetMods: "CTRL"

    signal copied

    function activate(id, copyOnly) {
        if (!active || busy || !focusReady || !/^[1-9][0-9]{0,19}$/.test(id))
            return
        actionProc.actionSession = session
        actionProc.operation = "copy"
        actionProc.pasteAddress = copyOnly ? "" : targetAddress
        actionProc.pasteMods = targetMods
        actionProc.command = ["python3", helper, "copy", id]
        error = ""
        actionProc.running = true
    }

    function beginSession() {
        session++
        active = true
        error = ""
        entries = []
        targetAddress = ""
        focusReady = false
        pendingAddress = ""
        pasteDelay.stop()
        cacheCleanup.stop()
        if (!snapshotProc.running)
            capture()
        refresh()
    }

    function capture() {
        snapshotProc.captureSession = session
        snapshotProc.command = ["python3", helper, "snapshot"]
        snapshotProc.running = true
    }

    function endSession() {
        active = false
        focusReady = false
        targetAddress = ""
        entries = []
        cacheCleanup.restart()
    }

    function mutate(operation, id) {
        actionProc.actionSession = session
        actionProc.operation = operation
        actionProc.command = ["python3", helper, operation].concat(id ? [id] : [])
        error = ""
        actionProc.running = true
    }

    function readResult(text) {
        try {
            return JSON.parse(text)
        } catch (_) {
            return {
                ok: false,
                error: "Clipboard helper did not return a result"
            }
        }
    }

    function refresh() {
        if (!active)
            return
        if (listProc.running || cleanupProc.running) {
            refreshPending = true
            return
        }
        refreshPending = false
        listProc.listSession = session
        listProc.command = ["python3", helper, "list"]
        listProc.running = true
    }

    function remove(id) {
        if (!active || busy || !/^[1-9][0-9]{0,19}$/.test(id))
            return
        mutate("delete", id)
    }

    function wipe() {
        if (active && !busy)
            mutate("wipe", "")
    }

    Process {
        id: snapshotProc

        property int captureSession: 0

        stderr: StdioCollector {}
        stdout: StdioCollector {
            onStreamFinished: {
                if (snapshotProc.captureSession !== root.session || !root.active)
                    return
                const result = root.readResult(text)
                root.targetAddress = result.ok ? (result.address || "") : ""
                root.targetMods = result.mods === "CTRL SHIFT" ? "CTRL SHIFT" : "CTRL"
                root.focusReady = true
                if (!result.ok)
                    root.error = result.error
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (root.active && snapshotProc.captureSession !== root.session)
                root.capture()
            else if (root.active && !root.focusReady) {
                root.error = "Could not capture the previous application; copy only is available"
                root.focusReady = true
            }
        }
    }
    Process {
        id: listProc

        property int listSession: 0

        stderr: StdioCollector {}
        stdout: StdioCollector {
            onStreamFinished: {
                if (!root.active || listProc.listSession !== root.session)
                    return
                const result = root.readResult(text)
                if (result.ok)
                    root.entries = result.entries || []
                else
                    root.error = result.error
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (root.active && (root.refreshPending || listProc.listSession !== root.session))
                Qt.callLater(root.refresh)
            else if (exitCode !== 0 && root.active && !root.error)
                root.error = "Could not load clipboard history"
        }
    }
    Process {
        id: actionProc

        property int actionSession: 0
        property string operation: ""
        property string pasteAddress: ""
        property string pasteMods: "CTRL"

        stderr: StdioCollector {}
        stdout: StdioCollector {
            onStreamFinished: {
                const result = root.readResult(text)
                if (!result.ok) {
                    root.error = result.error
                    return
                }
                if (actionProc.actionSession !== root.session || !root.active)
                    return
                if (actionProc.operation === "copy") {
                    root.pendingAddress = actionProc.pasteAddress
                    root.pendingMods = actionProc.pasteMods
                    root.copied()
                    if (root.pendingAddress)
                        pasteDelay.restart()
                }
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0 && !root.error)
                root.error = "Clipboard operation failed"
            if (root.active && operation !== "copy")
                Qt.callLater(root.refresh)
        }
    }
    Process {
        id: pasteProc

        stderr: StdioCollector {}
        stdout: StdioCollector {
            onStreamFinished: {
                const result = root.readResult(text)
                if (!result.ok) {
                    root.error = result.error
                    console.warn("Clipboard: " + result.error)
                }
            }
        }
    }
    Process {
        id: cleanupProc

        command: ["python3", root.helper, "clear-cache"]

        stderr: StdioCollector {}
        stdout: StdioCollector {}

        onExited: (exitCode, exitStatus) => {
            if (root.active && root.refreshPending)
                Qt.callLater(root.refresh)
        }
    }
    Timer {
        id: pasteDelay

        interval: 150

        onTriggered: {
            if (!root.active && root.pendingAddress) {
                pasteProc.command = ["python3", root.helper, "paste", root.pendingAddress, "--mods", root.pendingMods]
                pasteProc.running = true
            }
            root.pendingAddress = ""
        }
    }
    Timer {
        id: cacheCleanup

        interval: 1000

        onTriggered: {
            if (root.active)
                return
            if (listProc.running || actionProc.running)
                restart()
            else
                cleanupProc.running = true
        }
    }
}
