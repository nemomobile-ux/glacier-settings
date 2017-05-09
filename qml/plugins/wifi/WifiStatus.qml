import QtQuick 2.6
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2

Page {
    id: wifiSettingsPage
    property var modelData

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: modelData.name
    }

    TechnologyModel {
        id: networkingModel
        name: "wifi"
    }



    Column{
        id: form
        width: parent.width

        anchors{
            top: parent.top
            topMargin: 20
        }

        spacing: 24
        leftPadding: 24


        Row{
            spacing: 24

            Label {
                text: qsTr("Method")
            }

            ButtonRow {
                id: methodButtonRow
                model: ListModel{
                    id: methodModel
                    ListElement{
                        name: "DHCP"
                    }
                    ListElement{
                        name: "Manual"
                    }
                }

                Component.onCompleted: {
                    if(modelData.ipv4["Method"] === "manual")
                    {
                        methodButtonRow.currentIndex = 1
                    }
                    else
                    {
                        methodButtonRow.currentIndex = 0
                    }
                }
            }
        }

        Label {
            text: qsTr("Network info")
        }

        Row{
            spacing: 24
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
            spacing: 24
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
            spacing: 24
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

        Rectangle {
            width: parent.width
            height: childrenRect.height

            color: "transparent"

            Button {
                id: disconnectButton
                width: parent.width
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                text: qsTr("Disconnect")
                onClicked: {
                    modelData.requestDisconnect();
                    console.log("Disconnect clicked");
                    pageStack.pop();
                }
            }
        }

    }
}
