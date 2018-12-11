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

        Rectangle{
            width: parent.width
            height: childrenRect.height
            color: "transparent"

            Label{
                id: nameLabel
                text: qsTr("Auto connect")
                anchors{
                    left: parent.left
                }
                wrapMode: Text.Wrap
                font.bold: true
            }

            CheckBox {
                id: columnCheckBox
                checked: modelData.autoConnect
                anchors{
                    right: parent.right
                    verticalCenter: nameLabel.verticalCenter
                }

                onClicked: {
                    modelData.autoConnect = !modelData.autoConnect;
                }
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
