import QtQuick
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Io

import qs.theme

PopupWindow {
    id: root

    required property var anchorItem
    required property real brightness

    readonly property int percentage:
        Math.round(
            root.brightness * 100
        )

    implicitWidth: 300
    implicitHeight: 135

    visible: false
    grabFocus: true

    color: "transparent"

    anchor.item:
        root.anchorItem

    anchor.edges:
        Edges.Bottom | Edges.Right

    anchor.gravity:
        Edges.Bottom | Edges.Left

    anchor.margins.top: 6

    // ---------------------------------------------------------------
    // BRIGHTNESS
    // ---------------------------------------------------------------

    Process {
        id: brightnessProcess
    }

    function setBrightness(value) {
        const percentage =
            Math.round(value * 100)

        brightnessProcess.exec([
            "brightnessctl",
            "set",
            percentage + "%"
        ])
    }

    // ---------------------------------------------------------------
    // PANEL
    // ---------------------------------------------------------------

    function open() {
        root.visible = true
    }

    function close() {
        root.visible = false
    }

    function toggle() {
        if (root.visible)
            root.close()
        else
            root.open()
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.visible

        onActivated:
            root.close()
    }

    Rectangle {
        anchors.fill: parent

        radius: 8

        color: Theme.surface

        border.width: 1
        border.color: Theme.border

        Column {
            anchors.fill: parent
            anchors.margins: 14

            spacing: 12

            // -------------------------------------------------------
            // HEADER
            // ---------------------------------------------------------------

            Row {
                width: parent.width

                Text {
                    text: "Brightness"

                    color:
                        Theme.foreground

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize + 1

                    font.weight:
                        Font.DemiBold
                }

                Item {
                    width:
                        parent.width
                        - parent.children[0].width
                        - percentageText.width

                    height: 1
                }

                Text {
                    id: percentageText

                    text:
                        root.percentage + "%"

                    color:
                        Theme.text

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }
            }

            // -------------------------------------------------------
            // SLIDER
            // ---------------------------------------------------------------

            Slider {
                id: brightnessSlider

                width: parent.width
                height: 32

                from: 0
                to: 1

                value:
                    root.brightness

                live: true

                onMoved:
                    root.setBrightness(value)

                background: Rectangle {
                    x:
                        brightnessSlider.leftPadding

                    y:
                        brightnessSlider.topPadding
                        + brightnessSlider.availableHeight / 2
                        - height / 2

                    width:
                        brightnessSlider.availableWidth

                    height: 5
                    radius: 3

                    color:
                        Theme.background

                    Rectangle {
                        width:
                            brightnessSlider.visualPosition
                            * parent.width

                        height:
                            parent.height

                        radius:
                            parent.radius

                        color:
                            Theme.foreground
                    }
                }

                handle: Rectangle {
                    x:
                        brightnessSlider.leftPadding
                        + brightnessSlider.visualPosition
                        * (
                            brightnessSlider.availableWidth
                            - width
                        )

                    y:
                        brightnessSlider.topPadding
                        + brightnessSlider.availableHeight / 2
                        - height / 2

                    width: 16
                    height: 16
                    radius: 8

                    color:
                        brightnessSlider.pressed
                            ? Theme.foreground
                            : Theme.text

                    border.width: 2
                    border.color:
                        Theme.surface
                }
            }
        }
    }
}
