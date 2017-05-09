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
        width: parent.width

        anchors{
            top: parent.top
            topMargin: 20
        }

        spacing: 24
        leftPadding: 24

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
