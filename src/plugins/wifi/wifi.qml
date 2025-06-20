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
        onPoweredChanged: {
            wifiTimer.stop();
            columnCheckBox.indeterminate = false
            columnCheckBox.checked = networkingModel.powered
        }
    }

    Timer{
        id: wifiTimer
        interval: 5000
        repeat: false
        onTriggered: {
            wifiEnable.indeterminate = false
            wifiEnable.checked = networkingModel.powered
        }
    }

    SettingsColumn{
        id: actionColumn
        anchors.fill: parent

        RightCheckBox{
            id: wifiEnable
            label: qsTr("Enable WiFi")
            checked: networkingModel.powered
            width: parent.width

            onClicked:{
                networkingModel.powered = !networkingModel.powered;
                wifiEnable.indeterminate = true
                wifiTimer.start()
            }
        }

        Flickable{
            visible: networkingModel.powered
            width: parent.width
            height: parent.height-wifiEnable.height

            contentHeight: networks.height+Theme.dp(50)

            clip: true

            Column{
                id: networks
                spacing: Theme.itemSpacingSmall
                width: parent.width

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
                    text: qsTr("Available")
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
                        main.pageStack.push(Qt.resolvedUrl("SavedServices.qml"));
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

