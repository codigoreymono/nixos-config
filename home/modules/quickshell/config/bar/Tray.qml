import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

import qs.theme

Item {
    id: root

    // Keep a persistent StatusNotifierHost alive.
    // tray-tui handles the actual tray UI.
    readonly property var trayItems: SystemTray.items

    implicitWidth: 28
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent

        radius: 5

        color:
            mouseArea.containsMouse
                ? Theme.surfaceActive
                : "transparent"

        Text {
            anchors.centerIn: parent

            text: "󰆍"

            color: Theme.text

            font.family: Theme.fontMono
            font.pointSize: Theme.fontDesktopSize + 2
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
                "--app-id=tray-tui",
                "-e",
                "tray-tui"
            ])
    }
}
