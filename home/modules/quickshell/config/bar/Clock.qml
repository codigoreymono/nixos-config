import QtQuick
import Quickshell

import qs.theme

Item {
    id: root

    implicitWidth: clockText.implicitWidth + 14
    implicitHeight: 28

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    ClockPanel {
        id: clockPanel

        anchorItem: root
    }

    Rectangle {
        anchors.fill: parent

        radius: 5

        color:
            mouseArea.containsMouse
            || clockPanel.visible
                ? Theme.surfaceActive
                : "transparent"

        Text {
            id: clockText

            anchors.centerIn: parent

            text: Qt.formatDateTime(
                clock.date,
                "HH:mm"
            )

            color:
                clockPanel.visible
                    ? Theme.foreground
                    : Theme.text

            font.family: Theme.fontMono
            font.pointSize: Theme.fontDesktopSize
            font.weight: Font.Medium
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

        onClicked: clockPanel.toggle()
    }
}
