pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // ── Public Properties ──────────────────────────
    property string artist: ""
    property string title: ""
    property string album: ""
    property bool playing: false
    property bool active: false    // true when a song is loaded
    property string elapsed: ""
    property string duration: ""
    property string position: ""   // e.g. "3/42"
    property int volume: 0

    // ── MPD Event Watcher ──────────────────────────
    // `mpc idleloop player` blocks and prints a line each time
    // the player state changes (play, pause, song switch, etc.)
    Process {
        id: idleProc
        running: true
        command: ["mpc", "idleloop", "player"]

        stdout: SplitParser {
            onRead: _ => root.refresh()
        }

        onExited: {
            // Restart if it dies (MPD might have restarted)
            idleRestart.start()
        }
    }

    Timer {
        id: idleRestart
        interval: 3000
        onTriggered: idleProc.running = true
    }

    // ── Fallback periodic refresh ──────────────────
    // In case idleloop misses an event or MPD restarts
    Timer {
        interval: 15000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    // ── Status Fetcher ─────────────────────────────
    Process {
        id: statusProc
        command: ["mpc", "-f", "%artist%@@@%title%@@@%album%"]

        property var buffer: []

        stdout: SplitParser {
            onRead: data => statusProc.buffer.push(data)
        }

        onExited: {
            root._parse(statusProc.buffer)
            statusProc.buffer = []
        }
    }

    // ── Playback Commands ──────────────────────────
    Process { id: cmdNext;   command: ["mpc", "next"] }
    Process { id: cmdPrev;   command: ["mpc", "prev"] }
    Process { id: cmdToggle; command: ["mpc", "toggle"] }

    function refresh() { statusProc.running = true }
    function next()    { cmdNext.running   = true }
    function prev()    { cmdPrev.running   = true }
    function toggle()  { cmdToggle.running = true }

    // ── Parser ─────────────────────────────────────
    function _parse(lines) {
        // Reset
        root.active  = false
        root.playing = false
        root.artist  = ""
        root.title   = ""
        root.album   = ""
        root.elapsed = ""
        root.duration = ""
        root.position = ""

        if (!lines || lines.length === 0) return

        let idx = 0

        // Line 0: song info  (only present when a song is current)
        // Format: Artist@@@Title@@@Album
        if (lines[0].includes("@@@")) {
            const p = lines[0].split("@@@")
            root.artist = (p[0] || "").trim()
            root.title  = (p[1] || "").trim()
            root.album  = (p[2] || "").trim()
            root.active = root.title !== "" || root.artist !== ""
            idx = 1
        }

        // Line 1 (or 0): status line
        // Format: [playing] #3/42   1:05/3:45 (29%)
        if (idx < lines.length) {
            const line = lines[idx]
            root.playing = line.includes("[playing]")

            const tm = line.match(/(\d+:\d+)\/(\d+:\d+)/)
            if (tm) {
                root.elapsed  = tm[1]
                root.duration = tm[2]
            }

            const pm = line.match(/#(\d+\/\d+)/)
            if (pm) root.position = pm[1]

            idx++
        }

        // Line 2 (or 1): volume line
        // Format: volume: 75%   repeat: off   ...
        if (idx < lines.length) {
            const vm = lines[idx].match(/volume:\s*(\d+)%/)
            if (vm) root.volume = parseInt(vm[1])
        }
    }

    Component.onCompleted: refresh()
}
