import QtQuick

import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications

Scope {
    id: root

    property var currentNotification: null
    property var popupScreen: null

    readonly property var historyModel:
        server.trackedNotifications

    readonly property int historyCount:
        server.trackedNotifications.values.length

    // -----------------------------------------------------------------
    // SCREEN
    // -----------------------------------------------------------------

    function focusedScreen() {
        const monitor = Hyprland.focusedMonitor

        if (monitor) {
            for (let i = 0; i < Quickshell.screens.length; ++i) {
                const screen = Quickshell.screens[i]

                if (screen.name === monitor.name)
                    return screen
            }
        }

        if (Quickshell.screens.length > 0)
            return Quickshell.screens[0]

        return null
    }

    // -----------------------------------------------------------------
    // HISTORY
    // -----------------------------------------------------------------

    function clearAll() {
        const notifications =
            server.trackedNotifications.values

        for (let i = notifications.length - 1; i >= 0; --i) {
            notifications[i].dismiss()
        }

        root.currentNotification = null
    }

    // -----------------------------------------------------------------
    // NOTIFICATION SERVER
    // -----------------------------------------------------------------

    NotificationServer {
        id: server

        bodySupported: true
        bodyMarkupSupported: false

        imageSupported: false
        bodyImagesSupported: false

        actionsSupported: false
        inlineReplySupported: false

        persistenceSupported: true

        keepOnReload: false

        onNotification: notification => {
            notification.tracked = true

            root.popupScreen =
                root.focusedScreen()

            root.currentNotification =
                notification
        }
    }

    // -----------------------------------------------------------------
    // POPUP
    // -----------------------------------------------------------------

    NotificationPopup {
        notification:
            root.currentNotification

        targetScreen:
            root.popupScreen

        onDismissRequested: {
            if (root.currentNotification)
                root.currentNotification.dismiss()

            root.currentNotification = null
        }

        onTimeoutReached: {
            if (
                root.currentNotification
                && root.currentNotification.transient
            ) {
                root.currentNotification.expire()
            }

            root.currentNotification = null
        }

        onNotificationClosed: {
            root.currentNotification = null
        }
    }
}
