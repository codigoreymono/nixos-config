import QtQuick
import Qt.labs.folderlistmodel

import Quickshell

import qs.services
import qs.theme

Scope {
    FolderListModel {
        id: wallpaperModel

        folder:
            "file://"
            + WallpaperService.wallpaperDirectory

        nameFilters: [
            "*.png",
            "*.jpg",
            "*.jpeg",
            "*.webp"
        ]

        caseSensitive: false

        showDirs: false
        showFiles: true
        showHidden: false
        showOnlyReadable: true
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: menuWindow

            property var modelData

            screen: modelData

            visible:
                WallpaperService.visible
                && WallpaperService.targetScreen
                    === modelData.name

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            exclusionMode:
                ExclusionMode.Ignore

            exclusiveZone: 0

            aboveWindows: true
            focusable: true

            color: "transparent"

            Rectangle {
                anchors.fill: parent

                color: "#66000000"
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    WallpaperService.close()
                }
            }

            Rectangle {
                id: panel

                anchors.centerIn: parent

                width:
                    Math.min(
                        900,
                        menuWindow.width - 80
                    )

                height:
                    Math.min(
                        620,
                        menuWindow.height - 80
                    )

                radius: 14

                color: Theme.background

                border.width: 1
                border.color: Theme.foreground

                Text {
                    id: title

                    anchors {
                        top: parent.top
                        topMargin: 20

                        horizontalCenter:
                            parent.horizontalCenter
                    }

                    text:
                        "Wallpapers | Monitor: "
                        + WallpaperService.targetScreen

                    color: Theme.text

                    font.family: Theme.fontMono
                    font.pixelSize: 16
                }

                Text {
                    anchors.centerIn: parent

                    visible:
                        wallpaperModel.count === 0

                    text:
                        "No wallpapers found"

                    color: Theme.text

                    font.family: Theme.fontMono
                    font.pixelSize: 14
                }

                GridView {
                    id: grid

                    anchors {
                        top: title.bottom
                        topMargin: 20

                        left: parent.left
                        leftMargin: 20

                        right: parent.right
                        rightMargin: 28

                        bottom: parent.bottom
                        bottomMargin: 20
                    }

                    clip: true

                    model: wallpaperModel

                    cellWidth: 210
                    cellHeight: 150

                    delegate: Item {
                        id: wallpaperItem

                        required property string fileName
                        required property string fileBaseName
                        required property string filePath
                        required property url fileUrl

                        width: grid.cellWidth
                        height: grid.cellHeight

                        Rectangle {
                            id: preview

                            anchors {
                                fill: parent
                                margins: 6
                            }

                            radius: 10

                            color: "transparent"

                            border.width:
                                WallpaperService.currentWallpaper(
                                    WallpaperService.targetScreen
                                ) === wallpaperItem.filePath
                                    ? 2
                                    : 1

                            border.color:
                                WallpaperService.currentWallpaper(
                                    WallpaperService.targetScreen
                                ) === wallpaperItem.filePath
                                    ? Theme.foreground
                                    : Theme.surfaceActive

                            clip: true

                            Image {
                                anchors.fill: parent

                                source: wallpaperItem.fileUrl

                                sourceSize.width: 420
                                sourceSize.height: 300

                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                cache: false
                            }

                            Rectangle {
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                    bottom: parent.bottom
                                }

                                height: 30

                                color: "#99000000"

                                Text {
                                    anchors {
                                        fill: parent
                                        leftMargin: 8
                                        rightMargin: 8
                                    }

                                    verticalAlignment:
                                        Text.AlignVCenter

                                    text:
                                        wallpaperItem.fileBaseName

                                    color: "white"

                                    elide:
                                        Text.ElideRight

                                    font.family:
                                        Theme.fontMono

                                    font.pixelSize: 11
                                }
                            }

                            Rectangle {
                                anchors.fill: parent

                                radius: 10

                                color:
                                    previewMouse.containsMouse
                                        ? "#22ffffff"
                                        : "transparent"
                            }

                            MouseArea {
                                id: previewMouse

                                anchors.fill: parent

                                hoverEnabled: true

                                cursorShape:
                                    Qt.PointingHandCursor

                                onClicked: {
                                    WallpaperService.setWallpaper(
                                        WallpaperService.targetScreen,
                                        wallpaperItem.filePath
                                    )
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: scrollTrack

                    anchors {
                        top: grid.top
                        bottom: grid.bottom

                        right: panel.right
                        rightMargin: 12
                    }

                    width: 3
                    radius: 2

                    visible:
                        grid.contentHeight > grid.height

                    color: Theme.surfaceActive

                    Rectangle {
                        width: parent.width

                        height:
                            Math.max(
                                24,
                                grid.visibleArea.heightRatio
                                    * scrollTrack.height
                            )

                        y:
                            grid.visibleArea.yPosition
                                * scrollTrack.height

                        radius: 2

                        color: Theme.text
                    }
                }
            }

            Shortcut {
                sequence: "Escape"

                enabled: menuWindow.visible

                onActivated: {
                    WallpaperService.close()
                }
            }
        }
    }
}
