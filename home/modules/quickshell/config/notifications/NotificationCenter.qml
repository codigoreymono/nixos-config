import QtQuick

import Quickshell

import qs.theme

PopupWindow {
    id: root

    required property Item anchorItem
    required property var notificationManager

    property alias open: root.visible

    // Newest notification first.
    readonly property var entries: {
        const result = []
        const values =
            root.notificationManager.historyModel.values

        for (let i = values.length - 1; i >= 0; --i)
            result.push(values[i])

        return result
    }

    anchor.item: root.anchorItem
    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.margins.bottom: 8

    implicitWidth: 380
    implicitHeight: 430

    visible: false
    grabFocus: true

    color: "transparent"

    Rectangle {
        anchors.fill: parent

        radius: 10

        color: Theme.background

        border.width: 1
        border.color: Theme.border

        // -------------------------------------------------------------
        // HEADER
        // -------------------------------------------------------------

        Text {
            id: title

            anchors.top: parent.top
            anchors.left: parent.left

            anchors.topMargin: 14
            anchors.leftMargin: 16

            text: "Notifications"

            color: Theme.textStrong

            font.family: Theme.fontMono
            font.pointSize:
                Theme.fontDesktopSize + 1

            font.bold: true
        }

        Text {
            anchors.left: title.right
            anchors.verticalCenter:
                title.verticalCenter

            anchors.leftMargin: 10

            text:
                root.entries.length === 1
                    ? "1 item"
                    : root.entries.length + " items"

            color: Theme.textMuted

            font.family: Theme.fontMono
            font.pointSize:
                Theme.fontDesktopSize - 1
        }

        Rectangle {
            id: clearButton

            anchors.top: parent.top
            anchors.right: parent.right

            anchors.topMargin: 9
            anchors.rightMargin: 10

            width: clearText.implicitWidth + 16
            height: 28

            radius: 6

            visible:
                root.entries.length > 0

            color:
                clearMouse.containsMouse
                    ? Theme.surfaceActive
                    : Theme.surface

            Text {
                id: clearText

                anchors.centerIn: parent

                text: "Clear all"

                color: Theme.text

                font.family: Theme.fontMono
                font.pointSize:
                    Theme.fontDesktopSize
            }

            MouseArea {
                id: clearMouse

                anchors.fill: parent

                hoverEnabled: true
                cursorShape:
                    Qt.PointingHandCursor

                onClicked: {
                    root.notificationManager.clearAll()
                }
            }
        }

        Rectangle {
            id: separator

            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            anchors.topMargin: 12
            anchors.leftMargin: 12
            anchors.rightMargin: 12

            height: 1

            color: Theme.border
        }

        // -------------------------------------------------------------
        // HISTORY
        // -------------------------------------------------------------

        ListView {
            id: historyView

            anchors.top: separator.bottom
            anchors.left: parent.left
            anchors.right: scrollTrack.left
            anchors.bottom: parent.bottom

            anchors.topMargin: 8
            anchors.leftMargin: 10
            anchors.rightMargin: 8
            anchors.bottomMargin: 10

            clip: true

            spacing: 6

            model: root.entries

            boundsBehavior:
                Flickable.StopAtBounds

            delegate: Rectangle {
                id: notificationEntry

                required property var modelData

                width: historyView.width

                implicitHeight:
                    notificationContent.implicitHeight + 20

                radius: 7

                color:
                    entryMouse.containsMouse
                        ? Theme.surfaceActive
                        : Theme.surface

                border.width: 1
                border.color: Theme.border

                // -----------------------------------------------------
                // ICON
                // -----------------------------------------------------

                Image {
                    id: appIcon

                    anchors.left: parent.left
                    anchors.top: parent.top

                    anchors.leftMargin: 10
                    anchors.topMargin: 10

                    width: 28
                    height: 28

                    fillMode:
                        Image.PreserveAspectFit

                    source:
                        notificationEntry.modelData.appIcon
                            ? Quickshell.iconPath(
                                notificationEntry.modelData.appIcon,
                                "dialog-information"
                            )
                            : Quickshell.iconPath(
                                "dialog-information"
                            )
                }

                // -----------------------------------------------------
                // CONTENT
                // -----------------------------------------------------

                Column {
                    id: notificationContent

                    anchors.top: parent.top
                    anchors.left: appIcon.right
                    anchors.right: dismissButton.left

                    anchors.topMargin: 9
                    anchors.leftMargin: 9
                    anchors.rightMargin: 8

                    spacing: 3

                    Text {
                        width: parent.width

                        text:
                            notificationEntry.modelData.appName
                                ? notificationEntry.modelData.appName
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
                            notificationEntry.modelData.summary

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
                            notificationEntry.modelData.body.length > 0

                        text:
                            notificationEntry.modelData.body

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

                // -----------------------------------------------------
                // DISMISS
                // -----------------------------------------------------

                Rectangle {
                    id: dismissButton

                    anchors.top: parent.top
                    anchors.right: parent.right

                    anchors.topMargin: 7
                    anchors.rightMargin: 7

                    width: 26
                    height: 26

                    radius: 5

                    color:
                        dismissMouse.containsMouse
                            ? Theme.surfaceActive
                            : "transparent"

                    Text {
                        anchors.centerIn: parent

                        text: ""

                        color:
                            dismissMouse.containsMouse
                                ? Theme.textStrong
                                : Theme.textMuted

                        font.family: Theme.fontMono
                        font.pointSize:
                            Theme.fontDesktopSize
                    }

                    MouseArea {
                        id: dismissMouse

                        anchors.fill: parent

                        hoverEnabled: true
                        cursorShape:
                            Qt.PointingHandCursor

                        onClicked: {
                            notificationEntry.modelData.dismiss()
                        }
                    }
                }

                MouseArea {
                    id: entryMouse

                    anchors.fill: parent

                    hoverEnabled: true
                    acceptedButtons: Qt.NoButton
                }
            }
        }

        // -------------------------------------------------------------
        // SCROLL INDICATOR
        // -------------------------------------------------------------

        Rectangle {
            id: scrollTrack

            anchors.top: separator.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            anchors.topMargin: 8
            anchors.rightMargin: 6
            anchors.bottomMargin: 10

            width: 3

            visible:
                historyView.contentHeight
                > historyView.height

            color: Theme.surface

            radius: 2

            Rectangle {
                width: parent.width

                height:
                    Math.max(
                        24,
                        parent.height
                            * historyView.visibleArea.heightRatio
                    )

                y:
                    historyView.visibleArea.yPosition
                    * parent.height

                color: Theme.textMuted

                radius: 2
            }
        }

        // -------------------------------------------------------------
        // EMPTY
        // -------------------------------------------------------------

        Text {
            anchors.centerIn: historyView

            visible:
                root.entries.length === 0

            text: "No notifications"

            color: Theme.textMuted

            font.family: Theme.fontMono
            font.pointSize:
                Theme.fontDesktopSize
        }
    }
}
