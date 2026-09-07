pragma Singleton

import QtQuick

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
    id: root

    property bool visible: false
    property string targetScreen: ""

    readonly property string wallpaperDirectory:
        Quickshell.env("HOME") + "/Pictures/Wallpapers"

    function focusedScreenName(): string {
        if (Hyprland.focusedMonitor)
            return Hyprland.focusedMonitor.name

        if (Quickshell.screens.length > 0)
            return Quickshell.screens[0].name

        return ""
    }

    function open(): void {
        root.targetScreen = root.focusedScreenName()
        root.visible = true
    }

    function close(): void {
        root.visible = false
    }

    function toggle(): void {
        if (root.visible) {
            root.close()
            return
        }

        root.open()
    }

    function currentWallpaper(
        monitorName: string
    ): string {
        const wallpapers =
            stateAdapter.wallpapers ?? {}

        return wallpapers[monitorName] ?? ""
    }

    function setWallpaper(
        monitorName: string,
        path: string
    ): void {
        if (
            monitorName.length === 0
            || path.length === 0
        )
            return

        applyWallpaper(
            monitorName,
            path
        )

        const wallpapers =
            Object.assign(
                {},
                stateAdapter.wallpapers ?? {}
            )

        wallpapers[monitorName] = path

        stateAdapter.wallpapers = wallpapers

        root.close()
    }

    function applyWallpaper(
        monitorName: string,
        path: string
    ): void {
        Quickshell.execDetached([
            "hyprctl",
            "hyprpaper",
            "wallpaper",
            monitorName
                + ", "
                + path
                + ", cover"
        ])
    }

    function restoreWallpapers(): void {
        const wallpapers =
            stateAdapter.wallpapers ?? {}

        for (
            const monitorName
            in wallpapers
        ) {
            const path =
                wallpapers[monitorName]

            if (path && path.length > 0) {
                root.applyWallpaper(
                    monitorName,
                    path
                )
            }
        }
    }

    FileView {
        id: stateFile

        path:
            Quickshell.stateDir
            + "/wallpapers.json"

        printErrors: false

        onAdapterUpdated: {
            writeAdapter()
        }

        onLoaded: {
            restoreTimer.restart()
        }

        JsonAdapter {
            id: stateAdapter

            property var wallpapers: ({})
        }
    }

    Timer {
        id: restoreTimer

        interval: 1000
        repeat: false

        onTriggered: {
            root.restoreWallpapers()
        }
    }
}
