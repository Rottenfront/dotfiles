pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import qs.services as Services

Singleton {
    property PwNode defaultSink: Pipewire.defaultAudioSink
    property PwNode defaultSource: Pipewire.defaultAudioSource
    property bool muted: defaultSink?.audio?.muted ?? false
    property var sinks: Pipewire.nodes.values.filter(node => node.isSink && !node.isStream && node.audio)
    property var sources: Pipewire.nodes.values.filter(node => !node.isSink && !node.isStream && node.audio)
    property real volume: (defaultSink?.audio?.volume > 1 ? 1 : defaultSink?.audio?.volume) ?? 0

    function init() {
    }

    function setDefaultSink(sink: PwNode): void {
        Pipewire.preferredDefaultAudioSink = sink
    }

    function setDefaultSource(source: PwNode): void {
        Pipewire.preferredDefaultAudioSource = source
    }

    function setSourceVolume(to: real): void {
        if (defaultSource?.ready && defaultSource?.audio) {
            defaultSource.audio.muted = false
            let val = Math.max(0, Math.min(1, to))
            defaultSource.audio.volume = val
            Services.Osd.showVolume()
        }
    }

    function setVolume(to: real): void {
        if (defaultSink?.ready && defaultSink?.audio) {
            defaultSink.audio.muted = false
            let val = Math.max(0, Math.min(1, to))
            defaultSink.audio.volume = val
            Services.Osd.showVolume()
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSource, Pipewire.defaultAudioSink, Pipewire.nodes, Pipewire.links]
    }
    Connections {
        id: audioConn

        function onMutedChanged() {
            Services.Osd.showVolume()
        }

        function onVolumeChanged() {
            Services.Osd.showVolume()
        }

        target: defaultSink && defaultSink.audio ? defaultSink.audio : null
    }
}
