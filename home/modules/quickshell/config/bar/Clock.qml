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

    Rectangle {
        anchors.fill: parent

        radius: 5

        color:
            mouseArea.containsMouse
                ? Theme.surfaceActive
                : "transparent"

        Text {
            id: clockText

            anchors.centerIn: parent

            text: Qt.formatDateTime(
                clock.date,
                "HH:mm · d/M/yy"
            )

            color: Theme.text

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

        onClicked:
            Quickshell.execDetached([
                "foot",
                "--app-id=calcurse",
                "-e",
                "calcurse"
            ])
    }
}
