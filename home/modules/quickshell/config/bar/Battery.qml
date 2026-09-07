import QtQuick
import Quickshell
import Quickshell.Services.UPower

import qs.theme

Item {
    id: root

    readonly property var battery: UPower.displayDevice

    readonly property bool available:
        battery.ready
        && battery.isPresent

    readonly property int percentage:
        available
            ? Math.round(battery.percentage * 100)
            : 0

    readonly property bool low:
        available
        && UPower.onBattery
        && percentage <= 20

    visible: available

    implicitWidth: content.implicitWidth + 12
    implicitHeight: 28

    BatteryPanel {
        id: batteryPanel

        anchorItem: root
    }

    Rectangle {
        anchors.fill: parent

        radius: 5

        color:
            mouseArea.containsMouse
            || batteryPanel.visible
                ? Theme.surfaceActive
                : "transparent"

        Row {
            id: content

            anchors.centerIn: parent

            spacing: 5

            Image {
                anchors.verticalCenter: parent.verticalCenter

                width: 16
                height: 16

                fillMode: Image.PreserveAspectFit

                source: Quickshell.iconPath(
                    root.battery.iconName,
                    "battery-missing-symbolic"
                )
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter

                text: root.percentage + "%"

                color:
                    root.low
                        ? Theme.warning
                        : Theme.text

                font.family: Theme.fontMono
                font.pointSize: Theme.fontDesktopSize
                font.weight: Font.Medium
            }
        }

        Behavior on color {
            ColorAnimation {
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
            batteryPanel.toggle()
    }
}
