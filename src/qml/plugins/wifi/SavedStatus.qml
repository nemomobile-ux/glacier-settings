import QtQuick 2.6
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2

import "../../components"

Page {
    id: savedWifiStatusPage
    property var modelData

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true
        title: modelData.name
    }

    SettingsColumn{
        id: actionColumn


        RightCheckBox {
            id: columnCheckBox
            label: qsTr("Auto connect")
            checked: modelData.autoConnect
            anchors{
                right: parent.right
                verticalCenter: nameLabel.verticalCenter
            }

            onClicked: {
                modelData.autoConnect = !modelData.autoConnect;
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
                text: qsTr("Remove")
                onClicked: {
                    modelData.remove();
                    console.log("Remove clicked");
                    pageStack.pop();
                }
            }
        }
    }
}
