import QtQuick
import Quickshell

import qs.services
import qs.theme

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: menuWindow

            property var modelData

            screen: modelData

            visible:
                PowerService.visible
                && PowerService.targetScreen
                    === modelData.name

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0

            aboveWindows: true
            focusable: true

            color: "transparent"

            // Dimmed background
            Rectangle {
                anchors.fill: parent

                color: "#66000000"
            }

            // Click outside -> close
            MouseArea {
                anchors.fill: parent

                onClicked: {
                    PowerService.close()
                }
            }

            // Central menu
            Rectangle {
                id: panel

                anchors.centerIn: parent

                width: 560
                height: 150

                radius: 14

                color: Theme.background

                border.width: 1
                border.color: Theme.foreground

                Row {
                    anchors.centerIn: parent

                    spacing: 12

                    Repeater {
                        model: [
                            {
                                icon: "",
                                label: "Lock",
                                action: "lock"
                            },
                            {
                                icon: "󰤄",
                                label: "Suspend",
                                action: "suspend"
                            },
                            {
                                icon: "󰍃",
                                label: "Logout",
                                action: "logout"
                            },
                            {
                                icon: "󰜉",
                                label: "Reboot",
                                action: "reboot"
                            },
                            {
                                icon: "",
                                label: "Shutdown",
                                action: "shutdown"
                            }
                        ]

                        delegate: Rectangle {
                            id: actionButton

                            required property var modelData

                            width: 92
                            height: 92

                            radius: 10

                            color:
                                buttonMouse.containsMouse
                                    ? Theme.surfaceActive
                                    : "transparent"

                            Column {
                                anchors.centerIn: parent

                                spacing: 8

                                Text {
                                    anchors.horizontalCenter:
                                        parent.horizontalCenter

                                    text:
                                        actionButton.modelData.icon

                                    color: Theme.text

                                    font.family: Theme.fontMono
                                    font.pixelSize: 26
                                }

                                Text {
                                    anchors.horizontalCenter:
                                        parent.horizontalCenter

                                    text:
                                        actionButton.modelData.label

                                    color: Theme.text

                                    font.family: Theme.fontMono
                                    font.pixelSize: 12
                                }
                            }

                            MouseArea {
                                id: buttonMouse

                                anchors.fill: parent

                                hoverEnabled: true

                                cursorShape:
                                    Qt.PointingHandCursor

                                onClicked: {
                                    const action =
                                        actionButton.modelData.action

                                    if (action === "lock")
                                        PowerService.lock()
                                    else if (action === "suspend")
                                        PowerService.suspend()
                                    else if (action === "logout")
                                        PowerService.logout()
                                    else if (action === "reboot")
                                        PowerService.reboot()
                                    else if (action === "shutdown")
                                        PowerService.shutdown()
                                }
                            }
                        }
                    }
                }
            }

            Shortcut {
                sequence: "Escape"

                enabled: menuWindow.visible

                onActivated: {
                    PowerService.close()
                }
            }
        }
    }
}
