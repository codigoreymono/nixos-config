import QtQuick

import Quickshell

import qs.theme

PanelWindow {
    id: root

    property var notification: null
    property var targetScreen: null

    signal dismissRequested()
    signal timeoutReached()
    signal notificationClosed()

    // -----------------------------------------------------------------
    // WINDOW
    // -----------------------------------------------------------------

    screen: targetScreen

    visible:
        notification !== null
        && targetScreen !== null

    implicitWidth: 360
    implicitHeight:
        notificationCard.implicitHeight

    anchors {
        top: true
        right: true
    }

    margins {
        top: 42
        right: 12
    }

    exclusionMode:
        ExclusionMode.Ignore

    aboveWindows: true
    focusable: false

    color: "transparent"

    // -----------------------------------------------------------------
    // TIMEOUT
    // -----------------------------------------------------------------

    onNotificationChanged: {
        if (notification)
            hideTimer.restart()
        else
            hideTimer.stop()
    }

    Timer {
        id: hideTimer

        interval: 5000
        repeat: false

        onTriggered: {
            root.timeoutReached()
        }
    }

    // If the application closes/replaces the notification itself.
    Connections {
        target: root.notification

        function onClosed(reason) {
            root.notificationClosed()
        }
    }

    // -----------------------------------------------------------------
    // CARD
    // -----------------------------------------------------------------

    Rectangle {
        id: notificationCard

        anchors.fill: parent

        implicitHeight:
            content.implicitHeight + 24

        radius: 8

        color: Theme.surface

        border.width: 1
        border.color: Theme.border

        // -------------------------------------------------------------
        // ICON
        // -------------------------------------------------------------

        Image {
            id: appIcon

            anchors.left: parent.left
            anchors.top: parent.top

            anchors.leftMargin: 12
            anchors.topMargin: 12

            width: 32
            height: 32

            fillMode: Image.PreserveAspectFit

            source:
                root.notification
                && root.notification.appIcon
                    ? Quickshell.iconPath(
                        root.notification.appIcon,
                        "dialog-information"
                    )
                    : Quickshell.iconPath(
                        "dialog-information"
                    )
        }

        // -------------------------------------------------------------
        // CONTENT
        // -------------------------------------------------------------

        Column {
            id: content

            anchors.top: parent.top
            anchors.left: appIcon.right
            anchors.right: closeButton.left

            anchors.topMargin: 11
            anchors.leftMargin: 10
            anchors.rightMargin: 8

            spacing: 3

            Text {
                width: parent.width

                text:
                    root.notification
                    && root.notification.appName
                        ? root.notification.appName
                        : "Notification"

                color: Theme.textMuted

                elide: Text.ElideRight

                font.family: Theme.fontMono
                font.pointSize:
                    Theme.fontDesktopSize - 1
            }

            Text {
                width: parent.width

                text:
                    root.notification
                        ? root.notification.summary
                        : ""

                color: Theme.textStrong

                elide: Text.ElideRight

                font.family: Theme.fontMono
                font.pointSize:
                    Theme.fontDesktopSize

                font.bold: true
            }

            Text {
                width: parent.width

                visible:
                    root.notification
                    && root.notification.body.length > 0

                text:
                    root.notification
                        ? root.notification.body
                        : ""

                textFormat: Text.PlainText

                color: Theme.text

                wrapMode: Text.Wrap

                maximumLineCount: 3
                elide: Text.ElideRight

                font.family: Theme.fontMono
                font.pointSize:
                    Theme.fontDesktopSize
            }
        }

        // -------------------------------------------------------------
        // CLOSE
        // -------------------------------------------------------------

        Rectangle {
            id: closeButton

            anchors.top: parent.top
            anchors.right: parent.right

            anchors.topMargin: 8
            anchors.rightMargin: 8

            width: 26
            height: 26

            radius: 5

            color:
                closeMouse.containsMouse
                    ? Theme.surfaceActive
                    : "transparent"

            Text {
                anchors.centerIn: parent

                text: ""

                color:
                    closeMouse.containsMouse
                        ? Theme.textStrong
                        : Theme.textMuted

                font.family: Theme.fontMono
                font.pointSize:
                    Theme.fontDesktopSize
            }

            MouseArea {
                id: closeMouse

                anchors.fill: parent

                hoverEnabled: true
                cursorShape:
                    Qt.PointingHandCursor

                onClicked: {
                    root.dismissRequested()
                }
            }
        }
    }
}
