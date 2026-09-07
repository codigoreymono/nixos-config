import QtQuick

import qs.theme
import "../notifications"

Item {
    id: root

    required property var notificationManager

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

    Rectangle {
        visible:
            root.notificationManager.historyCount > 0

        anchors.top: parent.top
        anchors.right: parent.right

        anchors.topMargin: 2
        anchors.rightMargin: 1

        width: 7
        height: 7

        radius: 4

        color: Theme.foreground
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape:
            Qt.PointingHandCursor

        onClicked: {
            center.open = !center.open
        }
    }

    NotificationCenter {
        id: center

        anchorItem: root

        notificationManager:
            root.notificationManager
    }
}
