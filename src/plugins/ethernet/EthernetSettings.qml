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
    id: ethernetSettingsPage
    property var modelData

    headerTools: HeaderToolsLayout {
        showBackButton: true
        title: modelData && modelData.name !== "" ? modelData.name : qsTr("Wired connection")
    }

    SettingsColumn {
        id: form

        Row {
            spacing: Theme.itemSpacingLarge

            Label {
                text: qsTr("Method")
            }

            ButtonRow {
                id: methodButtonRow
                model: ListModel {
                    ListElement { name: qsTr("DHCP") }
                    ListElement { name: qsTr("Manual") }
                }

                Component.onCompleted: {
                    if (modelData && modelData.ipv4["Method"] === "manual") {
                        methodButtonRow.currentIndex = 1
                    } else {
                        methodButtonRow.currentIndex = 0
                    }
                }
            }
        }

        Row {
            spacing: Theme.itemSpacingLarge
            Label { text: qsTr("IP address") }
            TextField {
                text: modelData ? modelData.ipv4["Address"] : ""
                readOnly: methodButtonRow.currentIndex !== 1
            }
        }

        Row {
            spacing: Theme.itemSpacingLarge
            Label { text: qsTr("Net mask") }
            TextField {
                text: modelData ? modelData.ipv4["Netmask"] : ""
                readOnly: methodButtonRow.currentIndex !== 1
            }
        }

        Row {
            spacing: Theme.itemSpacingLarge
            Label { text: qsTr("Gateway") }
            TextField {
                text: modelData ? modelData.ipv4["Gateway"] : ""
                readOnly: methodButtonRow.currentIndex !== 1
            }
        }

        Button {
            width: parent.width
            text: qsTr("Disconnect")
            visible: modelData && (modelData.state === "online" || modelData.state === "ready")
            onClicked: {
                modelData.requestDisconnect()
                main.pageStack.pop()
            }
        }
    }
}
