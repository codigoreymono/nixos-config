import QtQuick
import Quickshell
import Quickshell.Networking

import qs.theme

PopupWindow {
    id: root

    required property var anchorItem
    required property var wifiDevice

    property var passwordNetwork: null

    readonly property var networks:
        root.wifiDevice
            ? root.wifiDevice.networks.values
            : []

    readonly property bool askingPassword:
        root.passwordNetwork !== null

    implicitWidth: 310
    implicitHeight:
        root.askingPassword
            ? 430
            : 360

    visible: false
    grabFocus: true

    color: "transparent"

    anchor.item: root.anchorItem
    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.margins.top: 6

    // ---------------------------------------------------------------
    // NETWORK
    // ---------------------------------------------------------------

    function supportsPsk(network) {
        return network.security === WifiSecurityType.WpaPsk
            || network.security === WifiSecurityType.Wpa2Psk
            || network.security === WifiSecurityType.Sae
    }

    function selectNetwork(network) {
        if (!network)
            return

        if (network.connected)
            return

        passwordInput.text = ""
        root.passwordNetwork = null

        // Saved network.
        if (network.known) {
            network.connect()
            return
        }

        // Open network.
        if (network.security === WifiSecurityType.Open) {
            network.connect()
            return
        }

        // WPA / WPA2 / WPA3 Personal.
        if (root.supportsPsk(network)) {
            root.passwordNetwork = network

            Qt.callLater(
                function() {
                    passwordInput.forceActiveFocus()
                }
            )

            return
        }

        // Let NetworkManager try unsupported security types.
        network.connect()
    }

    function connectWithPassword() {
        if (!root.passwordNetwork)
            return

        if (passwordInput.text.length === 0)
            return

        root.passwordNetwork.connectWithPsk(
            passwordInput.text
        )

        passwordInput.text = ""
        root.passwordNetwork = null
    }

    function cancelPassword() {
        passwordInput.text = ""
        root.passwordNetwork = null
    }

    function toggleWifi() {
        Networking.wifiEnabled =
            !Networking.wifiEnabled

        root.cancelPassword()
    }

    // ---------------------------------------------------------------
    // PANEL
    // ---------------------------------------------------------------

    function open() {
        root.visible = true

        if (root.wifiDevice)
            root.wifiDevice.scannerEnabled = true
    }

    function close() {
        root.visible = false

        root.cancelPassword()

        if (root.wifiDevice)
            root.wifiDevice.scannerEnabled = false
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

    Rectangle {
        anchors.fill: parent

        radius: 8

        color: Theme.surface

        border.width: 1
        border.color: Theme.border

        Column {
            anchors.fill: parent
            anchors.margins: 12

            spacing: 8

            // -------------------------------------------------------
            // WIFI TOGGLE
            // ---------------------------------------------------------------

            Rectangle {
                width: parent.width
                height: 38

                radius: 5

                color:
                    wifiMouse.containsMouse
                        ? Theme.surfaceActive
                        : "transparent"

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    text: "Wi-Fi"

                    color: Theme.foreground

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize + 1

                    font.weight:
                        Font.DemiBold
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 8
                    anchors.verticalCenter: parent.verticalCenter

                    text:
                        Networking.wifiEnabled
                            ? "On"
                            : "Off"

                    color:
                        Networking.wifiEnabled
                            ? Theme.text
                            : Theme.textMuted

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }

                MouseArea {
                    id: wifiMouse

                    anchors.fill: parent

                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked:
                        root.toggleWifi()
                }
            }

            Rectangle {
                width: parent.width
                height: 1

                color: Theme.border
            }

            // -------------------------------------------------------
            // AVAILABLE NETWORKS
            // ---------------------------------------------------------------

            Text {
                visible:
                    Networking.wifiEnabled

                text: "Available networks"

                color: Theme.textMuted

                font.family:
                    Theme.fontMono

                font.pointSize:
                    Theme.fontDesktopSize
            }

            ListView {
                id: networkList

                width: parent.width
                height:
                    root.askingPassword
                        ? 220
                        : 260

                visible:
                    Networking.wifiEnabled

                clip: true
                spacing: 2

                model: root.networks

                delegate: Rectangle {
                    id: networkRow

                    required property var modelData

                    readonly property int percentage:
                        Math.round(
                            modelData.signalStrength * 100
                        )

                    width: networkList.width
                    height: 38

                    radius: 5

                    color:
                        networkMouse.containsMouse
                            ? Theme.surfaceActive
                            : "transparent"

                    Row {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter

                        spacing: 8

                        Text {
                            width: 16

                            text:
                                networkRow.modelData.connected
                                    ? "✓"
                                    : ""

                            color: Theme.foreground

                            font.family:
                                Theme.fontMono

                            font.pointSize:
                                Theme.fontDesktopSize
                        }

                        Text {
                            width:
                                parent.width - 72

                            text:
                                networkRow.modelData.name

                            elide:
                                Text.ElideRight

                            color:
                                networkRow.modelData.connected
                                    ? Theme.foreground
                                    : Theme.text

                            font.family:
                                Theme.fontMono

                            font.pointSize:
                                Theme.fontDesktopSize

                            font.weight:
                                networkRow.modelData.connected
                                    ? Font.DemiBold
                                    : Font.Normal
                        }

                        Text {
                            text:
                                networkRow.percentage + "%"

                            color: Theme.textMuted

                            font.family:
                                Theme.fontMono

                            font.pointSize:
                                Theme.fontDesktopSize
                        }
                    }

                    MouseArea {
                        id: networkMouse

                        anchors.fill: parent

                        hoverEnabled: true
                        cursorShape:
                            networkRow.modelData.connected
                                ? Qt.ArrowCursor
                                : Qt.PointingHandCursor

                        onClicked:
                            root.selectNetwork(
                                networkRow.modelData
                            )
                    }
                }
            }

            // -------------------------------------------------------
            // PASSWORD
            // ---------------------------------------------------------------

            Column {
                width: parent.width

                visible:
                    root.askingPassword

                spacing: 6

                Text {
                    width: parent.width

                    text:
                        root.passwordNetwork
                            ? "Password for "
                                + root.passwordNetwork.name
                            : ""

                    elide: Text.ElideRight

                    color: Theme.text

                    font.family:
                        Theme.fontMono

                    font.pointSize:
                        Theme.fontDesktopSize
                }

                Rectangle {
                    width: parent.width
                    height: 34

                    radius: 5

                    color: Theme.background

                    border.width: 1
                    border.color:
                        passwordInput.activeFocus
                            ? Theme.textMuted
                            : Theme.border

                    TextInput {
                        id: passwordInput

                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8

                        verticalAlignment:
                            TextInput.AlignVCenter

                        echoMode:
                            TextInput.Password

                        color: Theme.text

                        selectionColor:
                            Theme.surfaceActive

                        font.family:
                            Theme.fontMono

                        font.pointSize:
                            Theme.fontDesktopSize

                        clip: true

                        onAccepted:
                            root.connectWithPassword()
                    }
                }

                Row {
                    anchors.right: parent.right

                    spacing: 6

                    Rectangle {
                        width: 70
                        height: 30

                        radius: 5

                        color:
                            cancelMouse.containsMouse
                                ? Theme.surfaceActive
                                : "transparent"

                        Text {
                            anchors.centerIn: parent

                            text: "Cancel"

                            color: Theme.textMuted

                            font.family:
                                Theme.fontMono

                            font.pointSize:
                                Theme.fontDesktopSize
                        }

                        MouseArea {
                            id: cancelMouse

                            anchors.fill: parent

                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked:
                                root.cancelPassword()
                        }
                    }

                    Rectangle {
                        width: 76
                        height: 30

                        radius: 5

                        color:
                            connectMouse.containsMouse
                                ? Theme.text
                                : Theme.foreground

                        Text {
                            anchors.centerIn: parent

                            text: "Connect"

                            color: Theme.background

                            font.family:
                                Theme.fontMono

                            font.pointSize:
                                Theme.fontDesktopSize

                            font.weight:
                                Font.Medium
                        }

                        MouseArea {
                            id: connectMouse

                            anchors.fill: parent

                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked:
                                root.connectWithPassword()
                        }
                    }
                }
            }

            // -------------------------------------------------------
            // WIFI OFF
            // ---------------------------------------------------------------

            Text {
                anchors.horizontalCenter:
                    parent.horizontalCenter

                visible:
                    !Networking.wifiEnabled

                text: "Wi-Fi is off"

                color: Theme.textMuted

                font.family:
                    Theme.fontMono

                font.pointSize:
                    Theme.fontDesktopSize
            }
        }
    }
}
