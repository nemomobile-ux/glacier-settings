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
import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.glacier.settings 1.0
import org.nemomobile.systemsettings 1.0

import Nemo.Configuration 1.0

import MeeGo.Connman 0.2
import org.kde.bluezqt 1.0 as BluezQt

Rectangle {
    id: quickSettings
    color: "transparent"

    width: parent.width
    height: Theme.itemHeightHuge*2

    TechnologyModel {
        id: wifiNetworkingModel
        name: "wifi"

        onTechnologiesChanged: {
            wifiButton.activated = wifiNetworkingModel.powered
        }

        onPoweredChanged: {
            wifiButton.activated = wifiNetworkingModel.powered
        }
    }

    property QtObject _adapter: _bluetoothManager && _bluetoothManager.usableAdapter
    property QtObject _bluetoothManager: BluezQt.Manager

    TechnologyModel {
        id: bluetoothModel
        name: "bluetooth"

        onTechnologiesChanged: {
            bluetoothButton.activated = bluetoothModel.powered
        }

        onPoweredChanged: {
            bluetoothButton.activated = bluetoothModel.powered
        }
    }

    ConfigurationValue {
        id: loactionEbnable
        key: "/home/glacier/loaction/enabled"
        defaultValue: "0"
    }

    NetworkManagerFactory {
        id: connMgr
    }

    ProfileControl{
        id: profileControl
    }

    Text {
        id: label
        text: qsTr("Quick settings")
        font.capitalization: Font.AllUppercase
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.textColor
        anchors{
            left: parent.left
            leftMargin: size.dp(10)
        }
    }

    Rectangle{
        id: line
        height: 1
        color: "white"
        width: parent.width-label.width-size.dp(30)
        anchors{
            left: label.right
            leftMargin: size.dp(10)
            verticalCenter: label.verticalCenter
        }
    }

    Row{
        id: buttonRow
        height: Theme.itemHeightLarge+size.dp(40)
        anchors{
            top: label.bottom
            horizontalCenter: parent.horizontalCenter
        }

        spacing: size.dp(20)

        QuickButton{
            id: wifiButton

            icon: "../img/wifi.svg"

            activated: wifiNetworkingModel.powered
            visible: wifiNetworkingModel.available

            onClicked: {
                if(wifiButton.activated)
                {
                    wifiNetworkingModel.powered = false;
                }
                else
                {
                    wifiNetworkingModel.powered = true;
                }
            }
        }

        QuickButton{
            id: bluetoothButton
            activated: bluetoothModel.powered && _adapter && _adapter.powered
            visible: wifiNetworkingModel.available

            icon: "../img/bluetooth.svg"

            onClicked: {
                if (bluetoothButton.activated)
                {
                    bluetoothModel.powered = false;
                }
                else
                {
                    bluetoothModel.powered = true;
                }
            }
        }

        QuickButton{
            id: volumeButton

            icon: "../img/volume.svg"

            activated: profileControl.profile != "silent"

            onClicked: {
                if(volumeButton.activated)
                {
                    profileControl.profile = "silent"
                }
                else
                {
                    profileControl.profile = "general"
                }
            }
        }

        QuickButton{
            id: gpsButton

            icon: "../img/gps.svg"
            visible: true //Always?
            activated: loactionEbnable.value == true

            onClicked: {
                if(gpsButton.activated)
                {
                    loactionEbnable.value = false
                }
                else
                {
                    loactionEbnable.value = true
                }
            }
        }

        QuickButton{
            id: airplaneButton
            activated: connMgr.instance.offlineMode
            icon: "../img/plane.svg"

            onClicked: {
                connMgr.instance.offlineMode = !connMgr.instance.offlineMode;
            }
        }
    }

    DisplaySettings{
        id: displaySettings
    }

    Label{
        id: brightnessLabel
        text: qsTr("Brightness");
        anchors{
            left: parent.left
            leftMargin: size.dp(20)
            bottom: brightnessSlider.top
            bottomMargin: size.dp(20)
        }
    }

    Slider{
        id: brightnessSlider
        width: parent.width-size.dp(40)
        anchors{
            left: parent.left
            leftMargin: size.dp(20)
            bottom: parent.bottom
            bottomMargin: size.dp(20)
        }
        minimumValue: 0
        maximumValue: displaySettings.maximumBrightness
        value: displaySettings.brightness
        stepSize: 1
        onValueChanged: {
            displaySettings.brightness = value
        }
        enabled: !displaySettings.autoBrightnessEnabled
    }
}
