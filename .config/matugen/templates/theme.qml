pragma Singleton
import QtQuick

QtObject {
<* for name, value in colors *>
    readonly property color {{name}}: "{{value.default.hex}}"
<* endfor *>

    readonly property string mono: "Cascadia Code" 
    readonly property int size: 13 

    readonly property int durationFast:   150
    readonly property int durationMid:    380
    readonly property int durationSlow:   650
}
