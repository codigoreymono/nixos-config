import QtQuick
import Quickshell
import Quickshell.Io

import qs.theme

Item {
    id: root

    // ---------------------------------------------------------------
    // BRIGHTNESS
    // ---------------------------------------------------------------

    FileView {
        id: brightnessFile

        path:
            "/sys/class/backlight/intel_backlight/brightness"
    }

    FileView {
        id: maxBrightnessFile

        path:
            "/sys/class/backlight/intel_backlight/max_brightness"
    }

    // Reload the current value so changes from the physical
    // brightness keys are reflected in the bar.
    Timer {
        interval: 500
        running: true
        repeat: true

        onTriggered:
            brightnessFile.reload()
    }

    readonly property int currentBrightness:
        brightnessFile.loaded
            ? Number(
                brightnessFile.text().trim()
            )
            : 0

    readonly property int maxBrightness:
        maxBrightnessFile.loaded
            ? Number(
                maxBrightnessFile.text().trim()
            )
            : 0

    readonly property real brightness:
        root.maxBrightness > 0
            ? root.currentBrightness
                / root.maxBrightness
            : 0

    readonly property int percentage:
        Math.round(
            root.brightness * 100
        )

    implicitWidth:
        content.implicitWidth + 12

    implicitHeight: 28

    Row {
        id: content

        anchors.centerIn: parent
        spacing: 5

        Text {
            anchors.verticalCenter: parent.verticalCenter

            text:
                root.percentage < 50
                    ? "󰃞"
                    : "󰃠"

            color: Theme.text

            font.family: Theme.fontMono
            font.pointSize: Theme.fontDesktopSize + 2
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter

            text: root.percentage + "%"

            color: Theme.text

            font.family: Theme.fontMono
            font.pointSize: Theme.fontDesktopSize
            font.weight: Font.Medium
        }
    }
}
