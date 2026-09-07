import QtQuick

import qs.services
import qs.theme

Item {
    id: root

    required property var panelWindow

    implicitWidth: 28
    implicitHeight: 28

    Rectangle {
        anchors.fill: parent

        radius: 5

        color:
            mouseArea.containsMouse
                ? Theme.surfaceActive
                : "transparent"
    }

    Text {
        anchors.centerIn: parent

        text: ""

        color: Theme.text

        font.family: Theme.fontMono
        font.pixelSize: 16
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            PowerService.toggle(
                root.panelWindow.screen.name
            )
        }
    }
}
