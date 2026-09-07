import QtQuick
import Quickshell
import Quickshell.Services.UPower

import qs.theme

PopupWindow {
    id: root

    required property var anchorItem

    readonly property var battery:
        UPower.displayDevice

    readonly property int percentage:
        battery.ready
            ? Math.round(battery.percentage * 100)
            : 0

    readonly property bool low:
        battery.ready
        && UPower.onBattery
        && percentage <= 20

    implicitWidth: 300
    implicitHeight: 270

    visible: false
    grabFocus: true

    color: "transparent"

    anchor.item: root.anchorItem
    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.margins.top: 6

    // ---------------------------------------------------------------
    // HELPERS
    // ---------------------------------------------------------------

    function stateText() {
        switch (battery.state) {
        case UPowerDeviceState.Charging:
            return "Charging"

        case UPowerDeviceState.Discharging:
            return "Discharging"

        case UPowerDeviceState.FullyCharged:
            return "Fully charged"

        case UPowerDeviceState.Empty:
            return "Empty"

        case UPowerDeviceState.PendingCharge:
            return "Waiting to charge"

        case UPowerDeviceState.PendingDischarge:
            return "Waiting to discharge"

        default:
            return "Unknown"
        }
    }

    function remainingSeconds() {
        if (
            battery.state === UPowerDeviceState.Charging
        ) {
            return battery.timeToFull
        }

        if (
            battery.state === UPowerDeviceState.Discharging
        ) {
            return battery.timeToEmpty
        }

        return 0
    }

    function formatDuration(seconds) {
        if (seconds <= 0)
            return ""

        const hours =
            Math.floor(seconds / 3600)

        const minutes =
            Math.floor((seconds % 3600) / 60)

        if (hours > 0)
            return hours + "h " + minutes + "m"

        return minutes + "m"
    }

    readonly property string remainingTime:
        root.formatDuration(
            root.remainingSeconds()
        )

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

    Shortcut {
        sequence: "Escape"
        enabled: root.visible

        onActivated:
            root.close()
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
            anchors.margins: 14

            spacing: 10

            // -------------------------------------------------------
            // HEADER
            // -------------------------------------------------------

            Row {
                anchors.horizontalCenter:
                    parent.horizontalCenter

                spacing: 8

                Image {
                    anchors.verticalCenter:
                        parent.verticalCenter

                    width: 22
                    height: 22

                    fillMode:
                        Image.PreserveAspectFit

                    source: Quickshell.iconPath(
                        root.battery.iconName,
                        "battery-missing-symbolic"
                    )
                }

                Text {
                    anchors.verticalCenter:
                        parent.verticalCenter

                    text: root.percentage + "%"

                    color:
                        root.low
                            ? Theme.warning
                            : Theme.foreground

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize + 6

                    font.weight:
                        Font.DemiBold
                }
            }

            Text {
                anchors.horizontalCenter:
                    parent.horizontalCenter

                text: root.stateText()

                color: Theme.text

                font.family:
                    Theme.fontMono

                font.pointSize:
                    Theme.fontDesktopSize
            }

            Text {
                anchors.horizontalCenter:
                    parent.horizontalCenter

                visible:
                    root.remainingTime.length > 0

                text:
                    battery.state
                        === UPowerDeviceState.Charging
                        ? root.remainingTime + " until full"
                        : root.remainingTime + " remaining"

                color: Theme.textMuted

                font.family:
                    Theme.fontMono

                font.pointSize:
                    Theme.fontDesktopSize
            }

            // -------------------------------------------------------
            // CHARGE BAR
            // -------------------------------------------------------

            Rectangle {
                width: parent.width
                height: 6

                radius: 3

                color: Theme.background

                Rectangle {
                    width:
                        parent.width
                        * Math.max(
                            0,
                            Math.min(
                                root.percentage / 100,
                                1
                            )
                        )

                    height: parent.height
                    radius: parent.radius

                    color:
                        root.low
                            ? Theme.warning
                            : Theme.foreground
                }
            }

            Rectangle {
                width: parent.width
                height: 1

                color: Theme.border
            }

            // -------------------------------------------------------
            // DETAILS
            // -------------------------------------------------------

            Item {
                width: parent.width
                height: 22

                Text {
                    anchors.left: parent.left

                    text: "Power source"

                    color: Theme.textMuted

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }

                Text {
                    anchors.right: parent.right

                    text:
                        UPower.onBattery
                            ? "Battery"
                            : "AC power"

                    color: Theme.text

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }
            }

            Item {
                width: parent.width
                height: 22

                Text {
                    anchors.left: parent.left

                    text:
                        UPower.onBattery
                            ? "Power usage"
                            : "Charge rate"

                    color: Theme.textMuted

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }

                Text {
                    anchors.right: parent.right

                    text:
                        Math.abs(
                            root.battery.changeRate
                        ).toFixed(1)
                        + " W"

                    color: Theme.text

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }
            }

            Item {
                width: parent.width
                height: 22

                visible:
                    root.battery.healthSupported

                Text {
                    anchors.left: parent.left

                    text: "Battery health"

                    color: Theme.textMuted

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }

                Text {
                    anchors.right: parent.right

                    text:
                        Math.round(
                            root.battery.healthPercentage
                        )
                        + "%"

                    color: Theme.text

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }
            }
        }
    }
}
