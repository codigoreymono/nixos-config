import QtQuick
import Quickshell.Hyprland

import qs.theme

Row {
    id: root

    spacing: 2

    readonly property var currentWorkspaces:
        Hyprland.workspaces.values

    // ---------------------------------------------------------------
    // DYNAMIC WORKSPACE
    //
    // [1] [2] [3] [4] [X]
    //
    // X comienza como 5.
    // Si usamos un workspace >= 5, muestra ese workspace.
    // Al volver a 1-4, muestra el workspace > 5 más alto
    // que todavía exista.
    // ---------------------------------------------------------------

    readonly property int dynamicWorkspaceId: {
        const focused = Hyprland.focusedWorkspace

        if (focused && focused.id >= 5)
            return focused.id

        let highest = 5

        for (let i = 0; i < root.currentWorkspaces.length; i++) {
            const id = root.currentWorkspaces[i].id

            if (id > highest)
                highest = id
        }

        return highest
    }

    // ---------------------------------------------------------------
    // HELPERS
    // ---------------------------------------------------------------

    function workspaceForId(id) {
        for (let i = 0; i < root.currentWorkspaces.length; i++) {
            const workspace = root.currentWorkspaces[i]

            if (workspace.id === id)
                return workspace
        }

        return null
    }

    function switchWorkspace(id) {
        Hyprland.dispatch(
            'hl.dsp.focus({ workspace = "' + id + '" })'
        )
    }

    // ---------------------------------------------------------------
    // WORKSPACES
    // ---------------------------------------------------------------

    Repeater {
        model: 5

        delegate: Item {
            id: workspaceItem

            required property int index

            readonly property int workspaceId:
                index < 4
                    ? index + 1
                    : root.dynamicWorkspaceId

            readonly property var workspace:
                root.workspaceForId(workspaceId)

            readonly property bool occupied:
                workspace
                    ? workspace.toplevels.values.length > 0
                    : false

            readonly property bool active:
                workspace
                    ? workspace.active
                    : false

            readonly property bool focused:
                workspace
                    ? workspace.focused
                    : false

            readonly property bool urgent:
                workspace
                    ? workspace.urgent
                    : false

            width: 22
            height: 22

            Rectangle {
                id: indicator

                anchors.centerIn: parent

                width: 20
                height: 20
                radius: 4

                scale:
                    mouseArea.containsMouse
                    && !workspaceItem.focused
                        ? 1.08
                        : 1.0

                color:
                    workspaceItem.urgent
                        ? Theme.warning
                        : workspaceItem.focused
                            ? Theme.foreground
                            : mouseArea.containsMouse
                                ? Theme.border
                                : workspaceItem.occupied
                                    ? Theme.surfaceActive
                                    : Theme.surface

                border.width:
                    workspaceItem.active
                    && !workspaceItem.focused
                        ? 1
                        : 0

                border.color: Theme.foreground

                Text {
                    anchors.centerIn: parent

                    text: workspaceItem.workspaceId

                    color:
                        workspaceItem.urgent
                        || workspaceItem.focused
                            ? Theme.background
                            : workspaceItem.active
                                ? Theme.textStrong
                                : workspaceItem.occupied
                                    ? Theme.text
                                    : Theme.textMuted

                    font.family: Theme.fontMono
                    font.pointSize: Theme.fontDesktopSize

                    font.weight:
                        workspaceItem.focused
                            ? Font.DemiBold
                            : Font.Normal
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                    }
                }
            }

            MouseArea {
                id: mouseArea

                anchors.fill: parent

                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked:
                    root.switchWorkspace(
                        workspaceItem.workspaceId
                    )
            }
        }
    }
}
