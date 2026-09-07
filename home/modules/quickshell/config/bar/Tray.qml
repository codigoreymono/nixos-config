import QtQuick

import Quickshell
import Quickshell.Services.SystemTray

import qs.theme

Item {
    id: root

    implicitWidth: trayRow.implicitWidth
    implicitHeight: 28

    Row {
        id: trayRow

        anchors.verticalCenter: parent.verticalCenter

        spacing: 2

        Repeater {
            model: SystemTray.items

            delegate: Item {
                id: trayItem

                required property var modelData

                width: 28
                height: 28

                Rectangle {
                    anchors.fill: parent

                    radius: 5

                    color:
                        mouseArea.containsMouse
                            ? Theme.surfaceActive
                            : "transparent"
                }

                Image {
                    anchors.centerIn: parent

                    width: 18
                    height: 18

                    source: trayItem.modelData.icon

                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                }

                QsMenuAnchor {
                    id: menuAnchor

                    menu: trayItem.modelData.menu

                    anchor.item: trayItem
                    anchor.edges:
                        Edges.Bottom
                        | Edges.Right

                    anchor.gravity:
                        Edges.Bottom
                        | Edges.Left
                }

                MouseArea {
                    id: mouseArea

                    anchors.fill: parent

                    hoverEnabled: true

                    acceptedButtons:
                        Qt.LeftButton
                        | Qt.MiddleButton
                        | Qt.RightButton

                    cursorShape:
                        Qt.PointingHandCursor

                    function openMenu() {
                        if (!trayItem.modelData.hasMenu)
                            return

                        menuAnchor.open()
                    }

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            if (trayItem.modelData.onlyMenu) {
                                openMenu()
                            } else {
                                trayItem.modelData.activate()
                            }

                            return
                        }

                        if (mouse.button === Qt.MiddleButton) {
                            trayItem.modelData.secondaryActivate()
                            return
                        }

                        if (mouse.button === Qt.RightButton) {
                            openMenu()
                        }
                    }

                    onWheel: wheel => {
                        trayItem.modelData.scroll(
                            wheel.angleDelta.y,
                            false
                        )
                    }
                }
            }
        }
    }
}
