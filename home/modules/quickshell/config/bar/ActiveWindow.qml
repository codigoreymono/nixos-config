import QtQuick
import Quickshell.Hyprland

import qs.theme

Item {
    id: root

    property real maxTitleWidth: 220

    readonly property var activeWindow:
        Hyprland.activeToplevel

    readonly property string appId:
        activeWindow
        && activeWindow.wayland
            ? activeWindow.wayland.appId
            : ""

    readonly property string title:
        activeWindow
            ? activeWindow.title
            : ""

    implicitWidth:
        contentRow.implicitWidth

    implicitHeight: 28

    Row {
        id: contentRow

        anchors.verticalCenter: parent.verticalCenter

        spacing: 6

        Text {
            id: appIdText

            anchors.verticalCenter: parent.verticalCenter

            text: root.appId

            visible: text.length > 0

            color: Theme.text

            font.family: Theme.fontMono
            font.pixelSize: 13
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter

            text: "—"

            visible:
                root.appId.length > 0
                && root.title.length > 0

            color: Theme.text

            font.family: Theme.fontMono
            font.pixelSize: 13

            opacity: 0.6
        }

        Item {
            id: titleViewport

            width:
                Math.min(
                    titleText.implicitWidth,
                    root.maxTitleWidth
                )

            height: titleText.implicitHeight

            anchors.verticalCenter: parent.verticalCenter

            visible: root.title.length > 0

            clip: true

            readonly property bool overflowing:
                titleText.implicitWidth > width

            Text {
                id: titleText

                anchors.verticalCenter: parent.verticalCenter

                x: 0

                text: root.title

                color: Theme.text

                font.family: Theme.fontMono
                font.pixelSize: 13

                onTextChanged: {
                    x = 0

                    if (titleViewport.overflowing)
                        bounceAnimation.restart()
                }
            }

            SequentialAnimation {
                id: bounceAnimation

                running: titleViewport.overflowing

                loops: Animation.Infinite

                PauseAnimation {
                    duration: 1200
                }

                NumberAnimation {
                    target: titleText
                    property: "x"

                    from: 0

                    to:
                        titleViewport.width
                        - titleText.implicitWidth

                    duration:
                        Math.max(
                            1200,
                            (
                                titleText.implicitWidth
                                - titleViewport.width
                            ) * 18
                        )

                    easing.type: Easing.InOutQuad
                }

                PauseAnimation {
                    duration: 900
                }

                NumberAnimation {
                    target: titleText
                    property: "x"

                    from:
                        titleViewport.width
                        - titleText.implicitWidth

                    to: 0

                    duration:
                        Math.max(
                            1200,
                            (
                                titleText.implicitWidth
                                - titleViewport.width
                            ) * 18
                        )

                    easing.type: Easing.InOutQuad
                }
            }
        }
    }
}
