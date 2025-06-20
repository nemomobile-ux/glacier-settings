/*
 * Copyright (C) 2017-2022 Chupligin Sergey <neochapay@gmail.com>
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
import QtQuick 2.6
import QtQuick.Window 2.1

import Nemo
import Nemo.Controls

import Connman 0.2

import Glacier.Controls.Settings 1.0

Page {
    id: wifiSettingsPage
    property var modelData

    headerTools: HeaderToolsLayout{
        id: header
        showBackButton: true;
        title: modelData.name
    }

    TechnologyModel{
        id: networkingModel
        name: "wifi"
    }


    SettingsColumn{
        id: form
        Row{
            spacing: Theme.itemSpacingLarge

            Label{
                text: qsTr("Method")
            }

            ButtonRow{
                id: methodButtonRow
                model: ListModel{
                    id: methodModel
                    ListElement{
                        name: qsTr("DHCP")
                    }
                    ListElement{
                        name: qsTr("Manual")
                    }
                }

                Component.onCompleted: {
                    if(modelData.ipv4["Method"] === "manual") {
                        methodButtonRow.currentIndex = 1
                    }else{
                        methodButtonRow.currentIndex = 0
                    }
                }
            }
        }

        Label{
            text: qsTr("Network info")
        }

        Row{
            spacing: Theme.itemSpacingLarge
            Label {
                id:ipAddressLabel
                text: qsTr("IP address")
            }

            TextField{
                id: ipAddressInput
                text: modelData.ipv4["Address"]
                readOnly: (methodButtonRow.currentIndex !== 1)
            }
        }

        Row{
            spacing: Theme.itemSpacingLarge
            Label {
                id:ipNetmaskLabel
                text: qsTr("Net mask")
            }

            TextField{
                id: ipNetmaskInput
                text: modelData.ipv4["Netmask"]
                readOnly: (methodButtonRow.currentIndex !== 1)
            }
        }

        Row{
            spacing: Theme.itemSpacingLarge
            Label {
                id:ipGatewayLabel
                text: qsTr("Gateway")
            }

            TextField{
                id: ipGatewayInput
                text: modelData.ipv4["Gateway"]
                readOnly: (methodButtonRow.currentIndex !== 1)
            }
        }

        Rectangle{
            width: parent.width
            height: childrenRect.height

            color: "transparent"

            Button{
                id: disconnectButton
                width: parent.width
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                text: qsTr("Disconnect")
                onClicked: {
                    modelData.requestDisconnect();
                    console.log("Disconnect clicked");
                    main.pageStack.pop();
                }
            }
        }
    }

    Connections{
        target: modelData
        onConnectRequestFailed: {
            console.log(error)
        }
    }
}
