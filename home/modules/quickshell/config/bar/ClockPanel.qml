import QtQuick
import QtQuick.Controls
import Quickshell

import qs.theme

PopupWindow {
    id: root

    required property var anchorItem

    implicitWidth: 320
    implicitHeight: 390

    visible: false
    grabFocus: true

    color: "transparent"

    anchor.item: root.anchorItem
    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.margins.top: 6

    // English UI + Monday as first day of the week.
    readonly property var uiLocale:
        Qt.locale("en_GB")

    property int shownMonth: 0
    property int shownYear: 1970

    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    // ---------------------------------------------------------------
    // CALENDAR HELPERS
    // ---------------------------------------------------------------

    function resetToToday() {
        root.shownMonth = clock.date.getMonth()
        root.shownYear = clock.date.getFullYear()
    }

    function changeMonth(offset) {
        const date = new Date(
            root.shownYear,
            root.shownMonth + offset,
            1
        )

        root.shownMonth = date.getMonth()
        root.shownYear = date.getFullYear()
    }

    function open() {
        root.resetToToday()
        root.visible = true
    }

    function close() {
        root.visible = false
    }

    function toggle() {
        if (root.visible)
            root.close()
        else
            root.open()
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.visible

        onActivated: root.close()
    }

    // ---------------------------------------------------------------
    // PANEL
    // ---------------------------------------------------------------

    Rectangle {
        anchors.fill: parent

        radius: 8

        color: Theme.surface

        border.width: 1
        border.color: Theme.border

        Column {
            anchors.fill: parent
            anchors.margins: 14

            spacing: 10

            // -------------------------------------------------------
            // CURRENT TIME
            // -------------------------------------------------------

            Text {
                anchors.horizontalCenter: parent.horizontalCenter

                text: Qt.formatDateTime(
                    clock.date,
                    "HH:mm"
                )

                color: Theme.foreground

                font.family: Theme.fontMono
                font.pointSize: Theme.fontDesktopSize + 8
                font.weight: Font.Medium
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter

                text: root.uiLocale.toString(
                    clock.date,
                    "dddd, MMMM d, yyyy"
                )

                color: Theme.textMuted

                font.family: Theme.fontMono
                font.pointSize: Theme.fontDesktopSize
            }

            // -------------------------------------------------------
            // SEPARATOR
            // -------------------------------------------------------

            Rectangle {
                width: parent.width
                height: 1

                color: Theme.border
            }

            // -------------------------------------------------------
            // MONTH NAVIGATION
            // -------------------------------------------------------

            Item {
                width: parent.width
                height: 28

                Rectangle {
                    id: previousButton

                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    width: 26
                    height: 26
                    radius: 5

                    color:
                        previousMouse.containsMouse
                            ? Theme.surfaceActive
                            : "transparent"

                    Text {
                        anchors.centerIn: parent

                        text: "‹"

                        color: Theme.text

                        font.family: Theme.fontMono
                        font.pointSize: Theme.fontDesktopSize + 3
                    }

                    MouseArea {
                        id: previousMouse

                        anchors.fill: parent

                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked:
                            root.changeMonth(-1)
                    }
                }

                Text {
                    anchors.centerIn: parent

                    text: root.uiLocale.toString(
                        new Date(
                            root.shownYear,
                            root.shownMonth,
                            1
                        ),
                        "MMMM yyyy"
                    )

                    color: Theme.text

                    font.family: Theme.fontMono
                    font.pointSize: Theme.fontDesktopSize
                    font.weight: Font.DemiBold
                }

                Rectangle {
                    id: nextButton

                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    width: 26
                    height: 26
                    radius: 5

                    color:
                        nextMouse.containsMouse
                            ? Theme.surfaceActive
                            : "transparent"

                    Text {
                        anchors.centerIn: parent

                        text: "›"

                        color: Theme.text

                        font.family: Theme.fontMono
                        font.pointSize: Theme.fontDesktopSize + 3
                    }

                    MouseArea {
                        id: nextMouse

                        anchors.fill: parent

                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked:
                            root.changeMonth(1)
                    }
                }
            }

            // -------------------------------------------------------
            // WEEK DAYS
            // -------------------------------------------------------

            DayOfWeekRow {
                id: weekDays

                width: parent.width
                height: 22

                locale: root.uiLocale

                delegate: Text {
                    required property string shortName

                    text: shortName

                    color: Theme.textMuted

                    font.family: Theme.fontMono
                    font.pointSize: Theme.fontDesktopSize - 1

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            // -------------------------------------------------------
            // CALENDAR
            // -------------------------------------------------------

            MonthGrid {
                id: monthGrid

                width: parent.width
                height: 190

                month: root.shownMonth
                year: root.shownYear

                locale: root.uiLocale

                delegate: Rectangle {
                    required property var model

                    radius: 5

                    color:
                        model.today
                            ? Theme.foreground
                            : dayMouse.containsMouse
                                ? Theme.surfaceActive
                                : "transparent"

                    opacity:
                        model.month === monthGrid.month
                            ? 1.0
                            : 0.30

                    Text {
                        anchors.centerIn: parent

                        text: model.day

                        color:
                            model.today
                                ? Theme.background
                                : Theme.text

                        font.family: Theme.fontMono
                        font.pointSize: Theme.fontDesktopSize

                        font.weight:
                            model.today
                                ? Font.DemiBold
                                : Font.Normal
                    }

                    MouseArea {
                        id: dayMouse

                        anchors.fill: parent

                        hoverEnabled: true

                        // Days are informational for now.
                        // Later they can show events if we want.
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }
                }
            }

            // -------------------------------------------------------
            // TODAY
            // -------------------------------------------------------

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter

                width: todayText.implicitWidth + 18
                height: 26

                radius: 5

                color:
                    todayMouse.containsMouse
                        ? Theme.surfaceActive
                        : "transparent"

                Text {
                    id: todayText

                    anchors.centerIn: parent

                    text: "Today"

                    color: Theme.text

                    font.family: Theme.fontMono
                    font.pointSize: Theme.fontDesktopSize
                }

                MouseArea {
                    id: todayMouse

                    anchors.fill: parent

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked:
                        root.resetToToday()
                }
            }
        }
    }
}
