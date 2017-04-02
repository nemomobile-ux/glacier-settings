import QtQuick 2.0
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2

Page {
    id: wifiPage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("WiFi settings")
    }

    TechnologyModel {
        id: networkingModel
        name: "wifi"
        property bool sheetOpened
        property string networkName
    }


    ListView {
        id: networkList
        width: parent.width-80
        height: parent.height-40

        anchors{
            top: parent.top
            topMargin: 40
            left: parent.left
            leftMargin: 40
        }

        model: networkingModel
        delegate: Item {
            width: parent.width
            height: 80


            Image {
                id: statusImage
                width: 56
                height: 56
                fillMode: Image.PreserveAspectFit

                anchors{
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                source: (getStrengthIndex(modelData.strength) === "0")? "image://theme/icon_wifi_0" : "image://theme/icon_wifi_focused" + getStrengthIndex(modelData.strength)
            }

            Label {
                anchors{
                    left: statusImage.right
                    leftMargin: 20
                    verticalCenter: statusImage.verticalCenter
                }
                width: root.width
                font.pointSize: 20
                text: modelData.name
                wrapMode: Text.Wrap
            }

        }
    }

    function getStrengthIndex(strength) {
        var strengthIndex = "0"

        if (strength >= 59) {
            strengthIndex = "4"
        } else if (strength >= 55) {
            strengthIndex = "3"
        } else if (strength >= 50) {
            strengthIndex = "2"
        } else if (strength >= 40) {
            strengthIndex = "1"
        }
        return strengthIndex
    }
}
