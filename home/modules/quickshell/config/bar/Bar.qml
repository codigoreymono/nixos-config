import QtQuick
import Quickshell

import qs.theme

PanelWindow {
    id: root

    required property var notificationManager

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 40

    Rectangle {
        anchors.fill: parent
        color: Theme.background

        // -----------------------------------------------------------
        // LEFT
        // Launcher -> Active Window -> Media
        // -----------------------------------------------------------

        Launcher {
            id: launcher

            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
        }

        ActiveWindow {
            id: activeWindow

            anchors.left: launcher.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
        }

        MediaIndicator {
            id: mediaIndicator

            anchors.left: activeWindow.right
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
        }

        // -----------------------------------------------------------
        // CENTER
        // -----------------------------------------------------------

        Workspaces {
            anchors.centerIn: parent
        }

        // -----------------------------------------------------------
        // RIGHT
        // Clock -> Caffeine -> Network -> Audio -> Brightness
        // -> Battery -> Tray -> Clipboard -> Notifications
        // -----------------------------------------------------------

        Clock {
            id: clock

            anchors.right: caffeine.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        Caffeine {
            id: caffeine

            panelWindow: root

            anchors.right: network.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        Network {
            id: network

            anchors.right: audio.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        Audio {
            id: audio

            anchors.right: brightness.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        Brightness {
            id: brightness

            anchors.right: battery.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        Battery {
            id: battery

            anchors.right: tray.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        Tray {
            id: tray

            anchors.right: clipboard.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        Clipboard {
            id: clipboard

            anchors.right: notifications.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        Notifications {
            id: notifications

            notificationManager:
                root.notificationManager

            anchors.right: power.left
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter
        }

        PowerButton {
            id: power

            panelWindow: root

            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
