import QtQuick

import Quickshell
import Quickshell.Io

import qs.theme

Item {
    id: root

    required property Item anchorItem

    property alias open: popup.visible

    property var entries: []

    property int totalEntries: 0
    property int maxEntries: 50

    // -----------------------------------------------------------------
    // HISTORY
    // -----------------------------------------------------------------

    function refreshHistory() {
        listProcess.exec([
            "cliphist",
            "list"
        ])
    }

    function parseHistory(output) {
        const lines = output.split("\n")
        const result = []

        let total = 0

        for (let i = 0; i < lines.length; ++i) {
            const raw = lines[i]

            if (raw.length === 0)
                continue

            const separator = raw.indexOf("\t")

            if (separator === -1)
                continue

            total++

            if (result.length >= root.maxEntries)
                continue

            const id = raw.slice(0, separator)
            const preview = raw.slice(separator + 1)

            result.push({
                raw: raw,
                id: id,
                preview: preview,
                isImage: preview.startsWith("[[ binary data")
            })
        }

        root.totalEntries = total
        root.entries = result
    }

    function copyEntry(entry) {
        copyProcess.exec([
            "cliphist-copy",
            entry.raw
        ])

        popup.visible = false
    }

    function clearHistory() {
        clearProcess.exec([
            "clipboard-history-wipe"
        ])
    }

    // -----------------------------------------------------------------
    // PROCESSES
    // -----------------------------------------------------------------

    Process {
        id: listProcess

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseHistory(this.text)
            }
        }
    }

    Process {
        id: copyProcess
    }

    Process {
        id: clearProcess

        onExited: {
            root.refreshHistory()
        }
    }

    // -----------------------------------------------------------------
    // POPUP
    // -----------------------------------------------------------------

    PopupWindow {
        id: popup

        anchor.item: root.anchorItem
        anchor.edges: Edges.Bottom | Edges.Right
        anchor.gravity: Edges.Bottom | Edges.Left
        anchor.margins.bottom: 8

        implicitWidth: 380
        implicitHeight: 430

        visible: false
        grabFocus: true

        onVisibleChanged: {
            if (visible)
                root.refreshHistory()
        }

        Rectangle {
            anchors.fill: parent

            color: Theme.background

            border.color: Theme.border
            border.width: 1

            radius: 10

            // ---------------------------------------------------------
            // HEADER
            // ---------------------------------------------------------

            Text {
                id: title

                anchors.top: parent.top
                anchors.left: parent.left

                anchors.topMargin: 14
                anchors.leftMargin: 16

                text: "Clipboard"

                color: Theme.textStrong

                font.family: Theme.fontMono
                font.pointSize: Theme.fontDesktopSize + 1
                font.bold: true
            }

            Text {
                id: countText

                anchors.left: title.right
                anchors.verticalCenter: title.verticalCenter

                anchors.leftMargin: 10

                text:
                    root.totalEntries > root.maxEntries
                        ? root.entries.length
                            + " of "
                            + root.totalEntries
                        : root.totalEntries === 1
                            ? "1 item"
                            : root.totalEntries + " items"

                color: Theme.textMuted

                font.family: Theme.fontMono
                font.pointSize: Theme.fontDesktopSize - 1
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
                    font.pointSize: Theme.fontDesktopSize
                }

                MouseArea {
                    id: clearMouse

                    anchors.fill: parent

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked: {
                        root.clearHistory()
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

            // ---------------------------------------------------------
            // HISTORY
            // ---------------------------------------------------------

            Flickable {
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

                contentWidth: width
                contentHeight: historyColumn.implicitHeight

                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: historyColumn

                    width: historyView.width

                    spacing: 6

                    Repeater {
                        model: root.entries

                        delegate: Rectangle {
                            id: entry

                            required property var modelData

                            width: historyColumn.width

                            height:
                                modelData.isImage
                                    ? 58
                                    : 54

                            radius: 7

                            color:
                                entryMouse.containsMouse
                                    ? Theme.surfaceActive
                                    : Theme.surface

                            border.color: Theme.border
                            border.width: 1

                            // -----------------------------------------
                            // IMAGE ENTRY
                            // -----------------------------------------

                            Text {
                                id: imageIcon

                                visible: entry.modelData.isImage

                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter

                                anchors.leftMargin: 12

                                text: ""

                                color: Theme.text

                                font.family: Theme.fontMono
                                font.pointSize: Theme.fontDesktopSize + 2
                            }

                            Text {
                                id: imageTitle

                                visible: entry.modelData.isImage

                                anchors.top: parent.top
                                anchors.left: imageIcon.right
                                anchors.right: parent.right

                                anchors.topMargin: 9
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10

                                text: "Image"

                                color: Theme.textStrong

                                font.family: Theme.fontMono
                                font.pointSize: Theme.fontDesktopSize
                                font.bold: true
                            }

                            Text {
                                visible: entry.modelData.isImage

                                anchors.top: imageTitle.bottom
                                anchors.left: imageIcon.right
                                anchors.right: parent.right

                                anchors.topMargin: 3
                                anchors.leftMargin: 10
                                anchors.rightMargin: 10

                                text: entry.modelData.preview

                                color: Theme.textMuted

                                elide: Text.ElideRight

                                font.family: Theme.fontMono
                                font.pointSize: Theme.fontDesktopSize - 1
                            }

                            // -----------------------------------------
                            // TEXT ENTRY
                            // -----------------------------------------

                            Text {
                                visible: !entry.modelData.isImage

                                anchors.fill: parent

                                anchors.leftMargin: 12
                                anchors.rightMargin: 12
                                anchors.topMargin: 8
                                anchors.bottomMargin: 8

                                text: entry.modelData.preview

                                color: Theme.text

                                wrapMode: Text.WrapAnywhere
                                elide: Text.ElideRight

                                maximumLineCount: 2

                                font.family: Theme.fontMono
                                font.pointSize: Theme.fontDesktopSize
                            }

                            MouseArea {
                                id: entryMouse

                                anchors.fill: parent

                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    root.copyEntry(entry.modelData)
                                }
                            }
                        }
                    }
                }
            }

            // ---------------------------------------------------------
            // SCROLL INDICATOR
            // ---------------------------------------------------------

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

            // ---------------------------------------------------------
            // EMPTY / LOADING
            // ---------------------------------------------------------

            Text {
                anchors.centerIn: historyView

                visible:
                    root.entries.length === 0
                    && !listProcess.running

                text: "Clipboard history is empty"

                color: Theme.textMuted

                font.family: Theme.fontMono
                font.pointSize: Theme.fontDesktopSize
            }

            Text {
                anchors.centerIn: historyView

                visible: listProcess.running

                text: "Loading..."

                color: Theme.textMuted

                font.family: Theme.fontMono
                font.pointSize: Theme.fontDesktopSize
            }
        }
    }
}
