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
                if (modelData.state == "idle" || modelData.state == "failure")
                {
                    modelData.requestConnect();
                    networkingModel.networkName.text = modelData.name;
                } else {
                    console.log("Show network status page");
                    for (var key in modelData.ipv4)
                    {
                        console.log(key + " -> " + modelData.ipv4[key]);
                    }
                }
            }
        }
    }

    function getStrengthIndex(strength) {
        var strengthIndex = "0"

        if (strength >= 59) {
            strengthIndex = "4"
        }
        else if (strength >= 55)
        {
            strengthIndex = "3"
        }
        else if (strength >= 50)
        {
            strengthIndex = "2"
        }
        else if (strength >= 40)
        {
            strengthIndex = "1"
        }
        return strengthIndex
    }
}
