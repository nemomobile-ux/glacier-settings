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
                text: qsTr("WiFi")
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

    Flickable{
        visible: networkingModel.powered
        width: parent.width-size.dp(40)
        height: parent.height-actionColumn.height-size.dp(80)
        contentHeight: networks.height+size.dp(50)

        clip: true
        anchors{
            top: actionColumn.bottom
            topMargin: size.dp(80)
            left: parent.left
            leftMargin: size.dp(20)
        }

        Column{
            id: networks
            spacing: Theme.itemSpacingSmall

            Text{
                text: qsTr("Saved")
                color: Theme.textColor
                font.pixelSize: Theme.fontSizeLarge
            }

            Rectangle{
                width: parent.width
                height: 1
            }

            Repeater{
                width: parent.width
                model: networkingModel
                delegate: NetworkDelegate{saved: true}
            }


            Text{
                text: qsTr("Enabled")
                color: Theme.textColor
                font.pixelSize: Theme.fontSizeLarge
            }

            Rectangle{
                width: parent.width
                height: 1
            }

            Repeater{
                width: parent.width
                model: networkingModel
                delegate: NetworkDelegate{saved: false}
            }

            ListViewItemWithActions{
                label: qsTr("Manage saved networks")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SavedServices.qml"));
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
