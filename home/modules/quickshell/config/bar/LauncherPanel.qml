import QtQuick
import QtQuick.Controls
import Quickshell

import qs.theme

PopupWindow {
    id: root

    required property var anchorItem
    implicitWidth: 340
    implicitHeight: 320

    visible: false
    grabFocus: true

    color: "transparent"

    anchor.item: root.anchorItem
    anchor.edges: Edges.Bottom | Edges.Left
    anchor.gravity: Edges.Bottom | Edges.Right
    anchor.margins.top: 6

    // ---------------------------------------------------------------
    // APPLICATIONS
    // ---------------------------------------------------------------

    readonly property var applications:
        DesktopEntries.applications.values

    readonly property var favoriteNames: [
        "Firefox",
        "Visual Studio Code",
        "foot"
    ]

    readonly property bool searching:
        searchInput.text.trim().length > 0

    // ---------------------------------------------------------------
    // HELPERS
    // ---------------------------------------------------------------

    function applicationNamed(name) {
        const target = name.toLowerCase()

        for (let i = 0; i < root.applications.length; i++) {
            const app = root.applications[i]

            if (
                app.name
                && app.name.toLowerCase() === target
            ) {
                return app
            }
        }

        return null
    }

    readonly property var favoriteApplications: {
        const result = []

        for (let i = 0; i < root.favoriteNames.length; i++) {
            const app =
                root.applicationNamed(
                    root.favoriteNames[i]
                )

            if (app)
                result.push(app)
        }

        return result
    }

    // A few additional applications for the default view.
    readonly property var suggestionApplications: {
        const result = []
        const favorites = {}
        const sorted = []

        for (
            let i = 0;
            i < root.favoriteApplications.length;
            i++
        ) {
            favorites[
                root.favoriteApplications[i].id
            ] = true
        }

        for (let i = 0; i < root.applications.length; i++) {
            sorted.push(root.applications[i])
        }

        sorted.sort(function(a, b) {
            return a.name.localeCompare(b.name)
        })

        for (let i = 0; i < sorted.length; i++) {
            const app = sorted[i]

            if (!favorites[app.id]) {
                result.push(app)

                if (result.length === 3)
                    break
            }
        }

        return result
    }

    function filteredApplications(query) {
        const text =
            query.trim().toLowerCase()

        if (text.length === 0)
            return []

        const result = []

        for (let i = 0; i < root.applications.length; i++) {
            const app = root.applications[i]

            const name =
                app.name
                    ? app.name.toLowerCase()
                    : ""

            const genericName =
                app.genericName
                    ? app.genericName.toLowerCase()
                    : ""

            const keywords =
                app.keywords
                    ? app.keywords.join(" ").toLowerCase()
                    : ""

            if (
                name.includes(text)
                || genericName.includes(text)
                || keywords.includes(text)
            ) {
                result.push(app)
            }
        }

        result.sort(function(a, b) {
            return a.name.localeCompare(b.name)
        })

        return result
    }

    readonly property var searchResults:
        root.filteredApplications(
            searchInput.text
        )

    function launch(entry) {
        if (!entry)
            return

        Quickshell.execDetached({
            command: [
                "uwsm",
                "app",
                "--"
            ].concat(entry.command),

            workingDirectory:
                entry.workingDirectory
        })

        root.visible = false
    }

    function open() {
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

    onVisibleChanged: {
        if (visible) {
            Qt.callLater(function() {
                searchInput.forceActiveFocus()
            })
        } else {
            searchInput.text = ""
            resultsList.currentIndex = 0
        }
    }

    // ---------------------------------------------------------------
    // APPLICATION ROW
    // ---------------------------------------------------------------

    component ApplicationRow: Rectangle {
        required property var entry

        property bool selected: false

        height: 32
        radius: 5

        color:
            selected
                ? Theme.foreground
                : rowMouse.containsMouse
                    ? Theme.surfaceActive
                    : "transparent"

        Image {
            id: appIcon

            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter

            width: 18
            height: 18

            fillMode: Image.PreserveAspectFit

            source: Quickshell.iconPath(
                entry.icon,
                "application-x-executable"
            )
        }

        Text {
            anchors.left: appIcon.right
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter

            text: entry.name

            elide: Text.ElideRight

            color:
                selected
                    ? Theme.background
                    : Theme.text

            font.family: Theme.fontMono
            font.pointSize:
                Theme.fontDesktopSize
        }

        MouseArea {
            id: rowMouse

            anchors.fill: parent

            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onClicked:
                root.launch(entry)
        }

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
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
            anchors.margins: 12

            spacing: 8

            // -------------------------------------------------------
            // SEARCH
            // -------------------------------------------------------

            TextField {
                id: searchInput

                width: parent.width
                height: 36

                placeholderText:
                    "Search applications..."

                color: Theme.text
                placeholderTextColor:
                    Theme.textMuted

                selectionColor:
                    Theme.foreground

                selectedTextColor:
                    Theme.background

                font.family:
                    Theme.fontMono

                font.pointSize:
                    Theme.fontDesktopSize

                background: Rectangle {
                    radius: 6

                    color: Theme.background

                    border.width:
                        searchInput.activeFocus
                            ? 1
                            : 0

                    border.color:
                        Theme.foreground
                }

                onTextChanged:
                    resultsList.currentIndex = 0

                Keys.onEscapePressed:
                    root.close()

                Keys.onDownPressed: {
                    if (
                        root.searching
                        && resultsList.count > 0
                    ) {
                        resultsList.currentIndex =
                            Math.min(
                                resultsList.currentIndex + 1,
                                resultsList.count - 1
                            )
                    }
                }

                Keys.onUpPressed: {
                    if (
                        root.searching
                        && resultsList.count > 0
                    ) {
                        resultsList.currentIndex =
                            Math.max(
                                resultsList.currentIndex - 1,
                                0
                            )
                    }
                }

                Keys.onReturnPressed: {
                    if (
                        root.searching
                        && root.searchResults.length > 0
                    ) {
                        root.launch(
                            root.searchResults[
                                Math.max(
                                    resultsList.currentIndex,
                                    0
                                )
                            ]
                        )
                    }
                }
            }

            // -------------------------------------------------------
            // DEFAULT VIEW
            // -------------------------------------------------------

            Column {
                width: parent.width
                spacing: 4

                visible: !root.searching

                Text {
                    text: "Favorites"

                    color: Theme.textMuted

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }

                Repeater {
                    model:
                        root.favoriteApplications

                    delegate: ApplicationRow {
                        required property var modelData

                        width: parent.width
                        entry: modelData
                    }
                }

                Item {
                    width: 1
                    height: 4
                }

                Text {
                    text: "Suggestions"

                    color: Theme.textMuted

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }

                Repeater {
                    model:
                        root.suggestionApplications

                    delegate: ApplicationRow {
                        required property var modelData

                        width: parent.width
                        entry: modelData
                    }
                }
            }

            // -------------------------------------------------------
            // SEARCH RESULTS
            // -------------------------------------------------------

            Column {
                width: parent.width
                spacing: 4

                visible: root.searching

                Text {
                    text:
                        root.searchResults.length === 1
                            ? "1 result"
                            : root.searchResults.length
                                + " results"

                    color: Theme.textMuted

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }

                ListView {
                    id: resultsList

                    width: parent.width

                    height:
                        Math.min(count, 8) * 34

                    clip: true
                    spacing: 2

                    model: root.searchResults

                    currentIndex: 0

                    delegate: ApplicationRow {
                        required property var modelData

                        width: resultsList.width

                        entry: modelData

                        selected:
                            ListView.isCurrentItem
                    }
                }
            }
        }
    }
}
