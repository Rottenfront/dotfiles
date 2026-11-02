pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs.config

Singleton {
    id: root

    readonly property bool active: activePlayer !== null
    property MprisPlayer activePlayer: null
    readonly property string album: activePlayer?.trackAlbum ?? ""
    readonly property string artUrl: activePlayer?.trackArtUrl ?? ""
    readonly property string artist: activePlayer?.trackArtist ?? ""
    readonly property string currentPlayerName: activePlayer ? (activePlayer.identity || activePlayer.desktopEntry || "Unknown") : ""
    readonly property bool isPlaying: activePlayer?.playbackState === MprisPlaybackState.Playing
    readonly property double length: lengthSupported ? Math.max(0, activePlayer.length) : 0
    readonly property bool lengthSupported: activePlayer?.lengthSupported ?? false
    property bool manualSelection: false
    readonly property int playerCount: players.length
    readonly property var players: Mpris.players.values
    readonly property double position: positionSupported ? Math.max(0, activePlayer.position) : 0
    readonly property bool positionSupported: activePlayer?.positionSupported ?? false
    readonly property string title: activePlayer?.trackTitle || "No Media"
    readonly property string trackId: activePlayer ? String(activePlayer.uniqueId) : ""

    function next() {
        if (activePlayer?.canGoNext)
            runCommand(["next"])
    }

    function nextPlayer() {
        if (players.length > 1)
            selectPlayer(players[(players.indexOf(activePlayer) + 1) % players.length])
    }

    function playPause() {
        if (activePlayer?.canTogglePlaying)
            runCommand(["play-pause"])
    }

    function previous() {
        if (activePlayer?.canGoPrevious)
            runCommand(["previous"])
    }

    function previousPlayer() {
        if (players.length > 1)
            selectPlayer(players[(players.indexOf(activePlayer) - 1 + players.length) % players.length])
    }

    function runCommand(args) {
        if (activePlayer) {
            const playerName = activePlayer.dbusName.replace(/^org\.mpris\.MediaPlayer2\./, "")
            Quickshell.execDetached(["playerctl", "--player", playerName].concat(args))
        }
    }

    function selectPlayer(player) {
        if (player) {
            activePlayer = player
            manualSelection = true
        }
    }

    function setPosition(pos) {
        if (activePlayer?.canSeek)
            runCommand(["position", String(pos)])
    }

    function updateActivePlayer() {
        if (manualSelection && activePlayer && players.includes(activePlayer))
            return
        manualSelection = false
        const playing = players.find(player => player.playbackState === MprisPlaybackState.Playing)
        if (playing)
            activePlayer = playing
        else if (!activePlayer || !players.includes(activePlayer))
            activePlayer = players[0] ?? null
    }

    Component.onCompleted: updateActivePlayer()
    onPlayersChanged: updateActivePlayer()

    Timer {
        interval: Config.secondInterval
        repeat: true
        running: true

        onTriggered: {
            root.updateActivePlayer()
            if (root.isPlaying && root.positionSupported)
                root.activePlayer.positionChanged()
        }
    }
}
