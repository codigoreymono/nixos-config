import QtQuick
import Quickshell.Services.Mpris

import qs.theme

Item {
    id: root

    readonly property var player:
        Mpris.players.values.find(player => player.isPlaying) ?? null

    readonly property bool playing:
        root.player !== null

    property var levels: [5, 11, 16, 9, 13]

    implicitWidth:
        root.playing
            ? bars.implicitWidth
            : 0

    implicitHeight: 28

    visible: root.playing

    Row {
        id: bars

        anchors.verticalCenter: parent.verticalCenter

        spacing: 2

        Repeater {
            model: 5

            Rectangle {
                required property int index

                width: 3
                height: root.levels[index]

                anchors.verticalCenter: parent.verticalCenter

                radius: 1.5
                color: Theme.text

                Behavior on height {
                    NumberAnimation {
                        duration: 120
                    }
                }
            }
        }
    }

    Timer {
        interval: 140
        repeat: true
        running: root.playing

        onTriggered: {
            root.levels = [
                4 + Math.random() * 12,
                4 + Math.random() * 14,
                4 + Math.random() * 16,
                4 + Math.random() * 13,
                4 + Math.random() * 11
            ]
        }
    }
}
