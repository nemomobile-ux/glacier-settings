/*
 * Copyright (C) 2026 Chupligin Sergey <neochapay@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

import QtQuick
import QtQuick.Dialogs

import Nemo
import Nemo.Controls

import Connman 0.2

import Glacier.Controls.Settings 1.0

Page {
    id: vpnEditorPage

    property string connectionPath: ""
    property var connection: connectionPath !== "" ? vpnManager.connection(connectionPath) : null
    readonly property bool isNew: connectionPath === ""

    readonly property var vpnManager: VpnModel.vpnManager

    headerTools: HeaderToolsLayout {
        showBackButton: true
        title: isNew ? qsTr("Add VPN") : qsTr("Edit VPN")
        tools: [
            ToolButton {
                iconSource: "image://theme/check"
                onClicked: saveConnection()
            }
        ]
    }

    function saveConnection() {
        var host = hostField.text.trim()
        if (host === "") {
            return
        }

        var name = nameField.text.trim()
        if (name === "") {
            name = host
        }

        var type = typeModel.get(typeRoller.currentIndex).value
        var props = {}
        props["Name"] = name
        props["Host"] = host
        props["Domain"] = domainField.text.trim() === "" ? "local" : domainField.text.trim()
        props["Type"] = type
        props["AutoConnect"] = autoConnectCheck.checked

        var provider = {}
        provider["Host"] = host

        if (type === "openvpn") {
            provider["OpenVPN.Port"] = portField.text.trim() === "" ? "1194" : portField.text.trim()
            provider["OpenVPN.Proto"] = protoModel.get(protoRoller.currentIndex).value
            provider["DeviceType"] = deviceTypeModel.get(deviceTypeRoller.currentIndex).value
            if (caCertField.text.trim() !== "") provider["OpenVPN.CACert"] = caCertField.text.trim()
            if (clientCertField.text.trim() !== "") provider["OpenVPN.Cert"] = clientCertField.text.trim()
            if (clientKeyField.text.trim() !== "") provider["OpenVPN.Key"] = clientKeyField.text.trim()
            if (authUserPassCheck.checked) provider["AuthUserPass"] = true
        } else if (type === "l2tp" || type === "pptp") {
            if (userField.text.trim() !== "") provider[type.toUpperCase() + ".User"] = userField.text.trim()
        } else if (type === "openconnect") {
            if (caCertField.text.trim() !== "") provider["OpenConnect.CACert"] = caCertField.text.trim()
            if (clientCertField.text.trim() !== "") provider["OpenConnect.ClientCert"] = clientCertField.text.trim()
        } else if (type === "vpnc") {
            if (userField.text.trim() !== "") provider["VPNC.XauthUsername"] = userField.text.trim()
            provider["VPNC.DeviceType"] = deviceTypeModel.get(deviceTypeRoller.currentIndex).value
        }

        props["Provider"] = provider

        if (isNew) {
            vpnManager.createConnection(props)
        } else {
            vpnManager.modifyConnection(connectionPath, props)
        }

        main.pageStack.pop()
    }

    ListModel {
        id: typeModel
        ListElement { name: "OpenVPN"; value: "openvpn" }
        ListElement { name: "L2TP"; value: "l2tp" }
        ListElement { name: "PPTP"; value: "pptp" }
        ListElement { name: "OpenConnect"; value: "openconnect" }
        ListElement { name: "VPNC"; value: "vpnc" }
    }

    ListModel {
        id: protoModel
        ListElement { name: "UDP"; value: "udp" }
        ListElement { name: "TCP"; value: "tcp" }
    }

    ListModel {
        id: deviceTypeModel
        ListElement { name: "TUN"; value: "tun" }
        ListElement { name: "TAP"; value: "tap" }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: formColumn.height + Theme.itemSpacingLarge * 2
        clip: true

        SettingsColumn {
            id: formColumn
            spacing: Theme.itemSpacingLarge

            TextField {
                id: nameField
                width: parent.width
                placeholderText: qsTr("Name")
                text: connection ? connection.name : ""
            }

            TextField {
                id: hostField
                width: parent.width
                placeholderText: qsTr("Host")
                text: connection ? connection.host : ""
            }

            TextField {
                id: domainField
                width: parent.width
                placeholderText: qsTr("Domain (default: local)")
                text: connection ? connection.domain : ""
            }

            GlacierRoller {
                id: typeRoller
                width: parent.width
                label: qsTr("Type")
                model: typeModel
                delegate: GlacierRollerItem {
                    Text {
                        height: typeRoller.itemHeight
                        verticalAlignment: Text.AlignVCenter
                        text: name
                        color: Theme.textColor
                        font.pixelSize: Theme.fontSizeMedium
                        font.bold: (typeRoller.activated && typeRoller.currentIndex === index)
                    }
                }
                Component.onCompleted: {
                    if (connection) {
                        for (var i = 0; i < typeModel.count; i++) {
                            if (typeModel.get(i).value === connection.type) {
                                typeRoller.currentIndex = i
                                break
                            }
                        }
                    }
                }
            }

            RightCheckBox {
                id: autoConnectCheck
                label: qsTr("Auto connect")
                checked: connection ? connection.autoConnect : false
            }

            // OpenVPN specific
            Item {
                width: parent.width
                height: openVpnColumn.height
                visible: typeModel.get(typeRoller.currentIndex).value === "openvpn"

                Column {
                    id: openVpnColumn
                    width: parent.width
                    spacing: Theme.itemSpacingLarge

                    TextField {
                        id: portField
                        width: parent.width
                        placeholderText: qsTr("Port (default: 1194)")
                        text: {
                            if (connection && connection.providerProperties["OpenVPN.Port"])
                                return connection.providerProperties["OpenVPN.Port"]
                            return ""
                        }
                    }

                    GlacierRoller {
                        id: protoRoller
                        width: parent.width
                        label: qsTr("Protocol")
                        model: protoModel
                        delegate: GlacierRollerItem {
                            Text {
                                height: protoRoller.itemHeight
                                verticalAlignment: Text.AlignVCenter
                                text: name
                                color: Theme.textColor
                                font.pixelSize: Theme.fontSizeMedium
                                font.bold: (protoRoller.activated && protoRoller.currentIndex === index)
                            }
                        }
                        Component.onCompleted: {
                            if (connection && connection.providerProperties["OpenVPN.Proto"] === "tcp") {
                                protoRoller.currentIndex = 1
                            }
                        }
                    }

                    GlacierRoller {
                        id: deviceTypeRoller
                        width: parent.width
                        label: qsTr("Device type")
                        model: deviceTypeModel
                        delegate: GlacierRollerItem {
                            Text {
                                height: deviceTypeRoller.itemHeight
                                verticalAlignment: Text.AlignVCenter
                                text: name
                                color: Theme.textColor
                                font.pixelSize: Theme.fontSizeMedium
                                font.bold: (deviceTypeRoller.activated && deviceTypeRoller.currentIndex === index)
                            }
                        }
                        Component.onCompleted: {
                            if (connection && connection.providerProperties["DeviceType"] === "tap") {
                                deviceTypeRoller.currentIndex = 1
                            }
                        }
                    }

                    TextField {
                        id: caCertField
                        width: parent.width
                        placeholderText: qsTr("CA certificate path")
                        text: connection && connection.providerProperties["OpenVPN.CACert"] ? connection.providerProperties["OpenVPN.CACert"] : ""
                    }

                    TextField {
                        id: clientCertField
                        width: parent.width
                        placeholderText: qsTr("Client certificate path")
                        text: connection && connection.providerProperties["OpenVPN.Cert"] ? connection.providerProperties["OpenVPN.Cert"] : ""
                    }

                    TextField {
                        id: clientKeyField
                        width: parent.width
                        placeholderText: qsTr("Client key path")
                        text: connection && connection.providerProperties["OpenVPN.Key"] ? connection.providerProperties["OpenVPN.Key"] : ""
                    }

                    RightCheckBox {
                        id: authUserPassCheck
                        label: qsTr("Use username/password")
                        checked: connection && connection.providerProperties["AuthUserPass"] ? true : false
                    }
                }
            }

            // L2TP/PPTP/VPNC user field
            TextField {
                id: userField
                width: parent.width
                visible: {
                    var t = typeModel.get(typeRoller.currentIndex).value
                    return t === "l2tp" || t === "pptp" || t === "vpnc"
                }
                placeholderText: qsTr("Username")
                text: {
                    if (!connection) return ""
                    var t = connection.type
                    if (t === "l2tp") return connection.providerProperties["L2TP.User"] || ""
                    if (t === "pptp") return connection.providerProperties["PPTP.User"] || ""
                    if (t === "vpnc") return connection.providerProperties["VPNC.XauthUsername"] || ""
                    return ""
                }
            }
        }

        ScrollDecorator {}
    }
}
