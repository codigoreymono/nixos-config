import QtQuick

import Quickshell.Wayland

import qs.services
import qs.theme

Item {
    id: root

    required property var panelWindow

    implicitWidth: 28
    implicitHeight: 28

    IdleInhibitor {
        window: root.panelWindow
        enabled: CaffeineService.active
    }

    Rectangle {
        anchors.fill: parent

        radius: 5

        color:
            CaffeineService.active
                ? Theme.foreground
                : mouseArea.containsMouse
                    ? Theme.surfaceActive
                    : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }

    Text {
        anchors.centerIn: parent

        text:
            CaffeineService.active
                ? "󰅶"
                : "󰾪"

        color:
            CaffeineService.active
                ? Theme.background
                : Theme.text

        font.family: Theme.fontMono
        font.pixelSize: 18
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            CaffeineService.toggle()
        }
    }
}
