pragma Singleton

import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root

    property bool visible: false
    property string targetScreen: ""

    function focusedScreenName(): string {
        if (Hyprland.focusedMonitor)
            return Hyprland.focusedMonitor.name

        if (Quickshell.screens.length > 0)
            return Quickshell.screens[0].name

        return ""
    }

    function open(screenName: string): void {
        root.targetScreen =
            screenName.length > 0
                ? screenName
                : root.focusedScreenName()

        root.visible = true
    }

    function close(): void {
        root.visible = false
    }

    function toggle(screenName: string): void {
        if (root.visible) {
            root.close()
            return
        }

        root.open(screenName)
    }

    function toggleFocused(): void {
        root.toggle(root.focusedScreenName())
    }

    function lock(): void {
        root.close()

        Quickshell.execDetached([
            "loginctl",
            "lock-session"
        ])
    }

    function suspend(): void {
        root.close()

        Quickshell.execDetached([
            "systemctl",
            "suspend"
        ])
    }

    function logout(): void {
        root.close()

        Quickshell.execDetached([
            "hyprctl",
            "dispatch",
            "hl.dsp.exit()"
        ])
    }

    function reboot(): void {
        root.close()

        Quickshell.execDetached([
            "systemctl",
            "reboot"
        ])
    }

    function shutdown(): void {
        root.close()

        Quickshell.execDetached([
            "systemctl",
            "poweroff"
        ])
    }

}
