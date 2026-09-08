import QtQuick
import Quickshell

import qs.theme

Item {
    id: root

    width: 34
    height: 34

    Image {
        id: nixIcon

        anchors.centerIn: parent

        width:
            mouseArea.containsMouse
                ? 25
                : 23

        height: width

        fillMode: Image.PreserveAspectFit

        source: Quickshell.iconPath(
            "nix-snowflake-white",
            true
        )

        visible: source.toString().length > 0

        Behavior on width {
            NumberAnimation {
                duration: 100
            }
        }
    }

    Text {
        anchors.centerIn: parent

        visible: !nixIcon.visible

        text: ""

        color: Theme.text

        font.family: Theme.fontMono
        font.pointSize: Theme.fontDesktopSize + 4
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked:
            Quickshell.execDetached([
                "fuzzel"
            ])
    }
}
