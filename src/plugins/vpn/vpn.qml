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

import Nemo
import Nemo.Controls

import Connman 0.2

import Glacier.Controls.Settings 1.0

Page {
    id: vpnPage

    readonly property var vpnManager: VpnModel.vpnManager

    headerTools: HeaderToolsLayout {
        showBackButton: true
        title: qsTr("VPN")
        tools: [
            ToolButton {
                iconSource: "image://theme/plus"
                onClicked: main.pageStack.push(Qt.resolvedUrl("AddVpnPage.qml"))
            }
        ]
    }

    ListView {
        id: vpnList
        anchors.fill: parent
        clip: true
        model: vpnManager ? vpnManager.connections : null

        delegate: ListViewItemWithActions {
            readonly property var connection: modelData

            label: connection ? connection.name : ""
            description: {
                if (!connection) return ""
                switch (connection.state) {
                case VpnConnection.Ready:
                    return qsTr("connected")
                case VpnConnection.Configuration:
                case VpnConnection.Association:
                    return qsTr("connecting...")
                case VpnConnection.Failure:
                    return qsTr("failed")
                default:
                    return qsTr("disconnected")
                }
            }
            iconVisible: false
            showNext: true

            onClicked: {
                if (!connection) return
                main.pageStack.push(Qt.resolvedUrl("VpnEditor.qml"), { connectionPath: connection.path })
            }

            actions: [
                ActionButton {
                    iconSource: "image://theme/link"
                    visible: connection && !connection.connected
                    onClicked: vpnManager.activateConnection(connection.path)
                },
                ActionButton {
                    iconSource: "image://theme/unlink"
                    visible: connection && connection.connected
                    onClicked: vpnManager.deactivateConnection(connection.path)
                },
                ActionButton {
                    iconSource: "image://theme/trash"
                    onClicked: {
                        if (connection) {
                            vpnManager.deleteConnection(connection.path)
                        }
                    }
                }
            ]
        }

        ScrollDecorator {}
    }

    Label {
        visible: vpnList.count === 0
        text: qsTr("No VPN connections configured")
        anchors.centerIn: parent
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
        width: parent.width - Theme.itemSpacingLarge * 2
    }
}
