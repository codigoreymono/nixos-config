import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

import qs.theme

Item {
    id: root

    readonly property var sink:
        Pipewire.defaultAudioSink

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

    visible: root.available

    implicitWidth: content.implicitWidth + 12
    implicitHeight: 28

    AudioPanel {
        id: audioPanel

        anchorItem: root
        sink: root.sink
    }

    Rectangle {
        anchors.fill: parent

        radius: 5

        color:
            mouseArea.containsMouse
            || audioPanel.visible
                ? Theme.surfaceActive
                : "transparent"

        Row {
            id: content

            anchors.centerIn: parent

            spacing: 5

            Image {
                anchors.verticalCenter:
                    parent.verticalCenter

                width: 16
                height: 16

                fillMode:
                    Image.PreserveAspectFit

                source: Quickshell.iconPath(
                    root.muted
                        ? "audio-volume-muted-symbolic"
                        : root.percentage < 34
                            ? "audio-volume-low-symbolic"
                            : root.percentage < 67
                                ? "audio-volume-medium-symbolic"
                                : "audio-volume-high-symbolic",
                    "audio-volume-high-symbolic"
                )
            }

            Text {
                anchors.verticalCenter:
                    parent.verticalCenter

                text:
                    root.muted
                        ? "Muted"
                        : root.percentage + "%"

                color:
                    root.muted
                        ? Theme.textMuted
                        : Theme.text

                font.family:
                    Theme.fontMono

                font.pointSize:
                    Theme.fontDesktopSize

                font.weight:
                    Font.Medium
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked:
            audioPanel.toggle()
    }
}
