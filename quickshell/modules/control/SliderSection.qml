import QtQuick.Layouts
import qs.components
import qs.services as Services
import qs.theme

ColumnLayout {
    Layout.fillWidth: true
    Layout.leftMargin: Theme.paddingSection
    Layout.rightMargin: Theme.paddingSection
    Layout.topMargin: Theme.spacingNormal
    spacing: Theme.spacingSection

    SliderRow {
        icon: "󰕾"
        label: "Volume"
        showValue: true
        value: Services.Volume.volume * 100
        valueSuffix: "%"

        onMoved: value => Services.Volume.setVolume(value / 100)
    }
    SliderRow {
        icon: "󰃞"
        label: "Brightness"
        showValue: true
        value: Services.System.brightness
        valueSuffix: "%"
        visible: Services.System.brightness !== 0

        onMoved: value => Services.System.setBrightness(value)
    }
}
