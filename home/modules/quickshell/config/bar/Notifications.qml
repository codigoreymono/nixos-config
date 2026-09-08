import QtQuick
import Quickshell

import qs.theme

Item {
    id: root

    implicitWidth: 28
    implicitHeight: 28

    Text {
        anchors.centerIn: parent

        text: ""

        color:
            mouseArea.containsMouse
                ? Theme.textStrong
                : Theme.text

        font.family: Theme.fontMono
        font.pointSize:
            Theme.fontDesktopSize + 1
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape:
            Qt.PointingHandCursor

        onClicked:
            Quickshell.execDetached([
                "foot",
                "--app-id=mako-history",
                "-e",
                "mako-history"
            ])
    }
}
