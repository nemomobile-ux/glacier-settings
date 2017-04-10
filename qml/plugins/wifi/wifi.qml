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

    Column{
        id: actionColumn
        anchors{
            top: parent.top
            topMargin: 20
        }
        width: parent.width

        Label{
            id: nameLabel
            text: qsTr("Enable WiFi")
            anchors{
                left: actionColumn.left
                leftMargin: 20
            }
            wrapMode: Text.Wrap
            font.pointSize: 22
            font.bold: true
            color: "#ffffff"
        }

        CheckBox {
            id: columnCheckBox
            checked: networkingModel.powered
            anchors{
                right: actionColumn.right
                rightMargin: 20
                verticalCenter: nameLabel.verticalCenter
            }
            onClicked:{
                networkingModel.setPowered(columnCheckBox.checked)
            }
        }
    }


    ListView {
        id: networkList
        width: parent.width-40
        height: parent.height-actionColumn.height-80
        clip: true
        anchors{
            top: actionColumn.bottom
            topMargin: 80
            left: parent.left
            leftMargin: 20
        }

        model: networkingModel
        delegate: ListViewItemWithActions{
            height: 80
            label: modelData.name

            description: {
                var state = modelData.state;
                var security = modelData.security[0];

                if ((state == "online") || (state == "ready")) {
                    return qsTr("connected");
                } else if (state == "association" || state == "configuration") {
                    return qsTr("connecting")+"...";
                } else {
                    if (security == "none") {
                        return qsTr("open");
                    } else {
                        return qsTr("secure");
                    }
                }
            }
            icon: (getStrengthIndex(modelData.strength) === "0")? "image://theme/icon_wifi_0" : "image://theme/icon_wifi_focused" + getStrengthIndex(modelData.strength)

            onClicked:{
                if (modelData.state == "idle" || modelData.state == "failure"){
                    console.log("Show network settings page");
                } else {
                    console.log("Show network status page");
                }
            }
        }
    }

    function getStrengthIndex(strength) {
        var strengthIndex = "0"

        if (strength >= 59) {
            strengthIndex = "4"
        }
        else if (strength >= 55){
            strengthIndex = "3"
        }
        else if (strength >= 50){
            strengthIndex = "2"
        }
        else if (strength >= 40){
            strengthIndex = "1"
        }
        return strengthIndex
    }
}
