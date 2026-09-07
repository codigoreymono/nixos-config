import QtQuick
import Quickshell
import Quickshell.Networking

import qs.theme

Item {
    id: root

    // ---------------------------------------------------------------
    // WIFI DEVICE
    // ---------------------------------------------------------------

    readonly property var devices:
        Networking.devices.values

    readonly property var wifiDevice: {
        for (let i = 0; i < root.devices.length; i++) {
            const device = root.devices[i]

            if (device.type === DeviceType.Wifi)
                return device
        }

        return null
    }

    readonly property var networks:
        root.wifiDevice
            ? root.wifiDevice.networks.values
            : []

    readonly property var connectedNetwork: {
        for (let i = 0; i < root.networks.length; i++) {
            const network = root.networks[i]

            if (network.connected)
                return network
        }

        return null
    }

    readonly property bool wifiAvailable:
        root.wifiDevice !== null

    readonly property bool wifiEnabled:
        Networking.wifiHardwareEnabled
        && Networking.wifiEnabled

    readonly property string networkName:
        root.connectedNetwork
            ? root.connectedNetwork.name
            : root.wifiEnabled
                ? "Disconnected"
                : "Wi-Fi off"

    // ---------------------------------------------------------------
    // ICON
    // ---------------------------------------------------------------

    function networkIcon() {
        if (!root.connectedNetwork)
            return "network-offline-symbolic"

        return "network-transmit-receive-symbolic"
    }

    visible: root.wifiAvailable

    implicitWidth: content.implicitWidth + 12
    implicitHeight: 28

    NetworkPanel {
        id: networkPanel

        anchorItem: root
        wifiDevice: root.wifiDevice
    }

    Rectangle {
        anchors.fill: parent

        radius: 5

        color:
            mouseArea.containsMouse
            || networkPanel.visible
                ? Theme.surfaceActive
                : "transparent"

        Row {
            id: content

            anchors.centerIn: parent

            spacing: 5

            Image {
                anchors.verticalCenter:
                    parent.verticalCenter

                width: 17
                height: 17

                fillMode:
                    Image.PreserveAspectFit

                source: Quickshell.iconPath(
                    root.networkIcon(),
                    "network-workgroup-symbolic"
                )
            }

            Text {
                anchors.verticalCenter:
                    parent.verticalCenter

                width:
                    Math.min(
                        implicitWidth,
                        110
                    )

                text: root.networkName

                elide: Text.ElideRight

                color:
                    root.connectedNetwork
                        ? Theme.text
                        : Theme.textMuted

                font.family:
                    Theme.fontMono

                font.pointSize:
                    Theme.fontDesktopSize

                font.weight:
                    root.connectedNetwork
                        ? Font.Medium
                        : Font.Normal
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
            networkPanel.toggle()
    }
}
