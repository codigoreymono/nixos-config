import QtQuick
import QtQuick.Controls.Basic
import Quickshell
import Quickshell.Services.Pipewire

import qs.theme

PopupWindow {
    id: root

    required property var anchorItem
    required property var sink

    PwObjectTracker {
        objects: [root.sink]
    }

    readonly property bool available:
        root.sink !== null
        && root.sink.ready
        && root.sink.audio !== null

    readonly property int percentage:
        root.available
            ? Math.round(root.sink.audio.volume * 100)
            : 0

    readonly property bool muted:
        root.available
            ? root.sink.audio.muted
            : false

    readonly property string deviceName: {
        if (!root.available)
            return "Audio"

        if (root.sink.nickname)
            return root.sink.nickname

        if (root.sink.description)
            return root.sink.description

        if (root.sink.name)
            return root.sink.name

        return "Audio"
    }

    implicitWidth: 320
    implicitHeight: 190

    visible: false
    grabFocus: true

    color: "transparent"

    anchor.item: root.anchorItem
    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.margins.top: 6

    // ---------------------------------------------------------------
    // AUDIO
    // ---------------------------------------------------------------

    function setVolume(value) {
        if (!root.available)
            return

        root.sink.audio.volume =
            Math.max(
                0,
                Math.min(value, 1)
            )
    }

    function toggleMute() {
        if (!root.available)
            return

        root.sink.audio.muted =
            !root.sink.audio.muted
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
            // DEVICE
            // ---------------------------------------------------------------

            Text {
                width: parent.width

                text: root.deviceName

                elide: Text.ElideRight

                color: Theme.foreground

                font.family:
                    Theme.fontMono

                font.pointSize:
                    Theme.fontDesktopSize + 1

                font.weight:
                    Font.DemiBold
            }

            Text {
                text:
                    root.muted
                        ? "Muted"
                        : "Volume " + root.percentage + "%"

                color:
                    root.muted
                        ? Theme.textMuted
                        : Theme.text

                font.family:
                    Theme.fontMono

                font.pointSize:
                    Theme.fontDesktopSize
            }

            // -------------------------------------------------------
            // VOLUME
            // ---------------------------------------------------------------

            Slider {
                id: volumeSlider

                width: parent.width
                height: 32

                from: 0
                to: 1

                value:
                    root.available
                        ? root.sink.audio.volume
                        : 0

                live: true

                onMoved:
                    root.setVolume(value)

                background: Rectangle {
                    x: volumeSlider.leftPadding

                    y:
                        volumeSlider.topPadding
                        + volumeSlider.availableHeight / 2
                        - height / 2

                    width:
                        volumeSlider.availableWidth

                    height: 5
                    radius: 3

                    color: Theme.background

                    Rectangle {
                        width:
                            volumeSlider.visualPosition
                            * parent.width

                        height: parent.height
                        radius: parent.radius

                        color:
                            root.muted
                                ? Theme.textMuted
                                : Theme.foreground
                    }
                }

                handle: Rectangle {
                    x:
                        volumeSlider.leftPadding
                        + volumeSlider.visualPosition
                        * (
                            volumeSlider.availableWidth
                            - width
                        )

                    y:
                        volumeSlider.topPadding
                        + volumeSlider.availableHeight / 2
                        - height / 2

                    width: 16
                    height: 16
                    radius: 8

                    color:
                        volumeSlider.pressed
                            ? Theme.foreground
                            : Theme.text

                    border.width: 2
                    border.color: Theme.surface
                }
            }

            Rectangle {
                width: parent.width
                height: 1

                color: Theme.border
            }

            // -------------------------------------------------------
            // MUTE
            // ---------------------------------------------------------------

            Rectangle {
                width: parent.width
                height: 34

                radius: 5

                color:
                    muteMouse.containsMouse
                        ? Theme.surfaceActive
                        : "transparent"

                Row {
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    spacing: 8

                    Image {
                        anchors.verticalCenter:
                            parent.verticalCenter

                        width: 16
                        height: 16

                        source: Quickshell.iconPath(
                            root.muted
                                ? "audio-volume-muted-symbolic"
                                : "audio-volume-high-symbolic",
                            "audio-volume-high-symbolic"
                        )
                    }

                    Text {
                        anchors.verticalCenter:
                            parent.verticalCenter

                        text:
                            root.muted
                                ? "Unmute"
                                : "Mute"

                        color: Theme.text

                        font.family:
                            Theme.fontMono

                        font.pointSize:
                            Theme.fontDesktopSize
                    }
                }

                MouseArea {
                    id: muteMouse

                    anchors.fill: parent

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked:
                        root.toggleMute()
                }
            }
        }
    }
}
