/*
 * Copyright (C) 2017 Chupligin Sergey <neochapay@gmail.com>
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

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2

import "../../components"

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

    SettingsColumn{
        id: actionColumn

        Rectangle{
            width: parent.width
            height: childrenRect.height
            color: "transparent"

            Label{
                id: nameLabel
                text: qsTr("Enable WiFi")
                anchors{
                    left: parent.left
                }
                wrapMode: Text.Wrap
                font.bold: true
            }

            CheckBox {
                id: columnCheckBox
                checked: networkingModel.powered
                anchors{
                    right: parent.right
                    verticalCenter: nameLabel.verticalCenter
                }
                onClicked:{
                    networkingModel.powered = !networkingModel.powered;
                }
            }
        }
    }


    ListView {
        id: networkList
        width: parent.width-size.dp(40)
        height: parent.height-actionColumn.height-size.dp(80)
        clip: true
        anchors{
            top: actionColumn.bottom
            topMargin: size.dp(80)
            left: parent.left
            leftMargin: size.dp(20)
        }

        model: networkingModel
        delegate: ListViewItemWithActions{
            height: size.dp(80)
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
                    console.log("Show settings page");
                    pageStack.push(Qt.resolvedUrl("WifiSettings.qml"),{modelData: modelData})
                } else {
                    console.log("Show network status page");
                    var component = Qt.createComponent(Qt.resolvedUrl("WifiStatus.qml")).errorString();
                    console.log(component)
                    pageStack.push(Qt.resolvedUrl("WifiStatus.qml"),{modelData: modelData})
                }
            }

            actions: Rectangle{
                width: childrenRect.width+16
                height: parent.height
                Image{
                    id: removeNetworkButton
                    source: "../../img/trash.svg"
                    width: 64
                    height: 64
                    fillMode: Image.PreserveAspectFit
                    sourceSize{
                        width: width
                        height: height
                    }
                    anchors{
                        top:parent.top
                        topMargin: 8
                        left: parent.left
                        leftMargin: 8
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            modelData.remove();
                            networkList.hideAllActions(-1);
                        }
                    }
                }

                Image{
                    source: "../../img/disconnect.svg"
                    visible: (modelData.state == "online" || modelData.state == "ready")

                    width: 64
                    height: 64
                    fillMode: Image.PreserveAspectFit
                    sourceSize{
                        width: width
                        height: height
                    }
                    anchors{
                        top:parent.top
                        topMargin: 8
                        left: removeNetworkButton.right
                        leftMargin: 16
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            modelData.requestDisconnect();
                            networkList.hideAllActions(-1);
                        }
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
