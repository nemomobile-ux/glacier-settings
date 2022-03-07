/*
 * Copyright (C) 2020 Chupligin Sergey <neochapay@gmail.com>
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

import org.nemomobile.configuration 1.0
import org.nemomobile.systemsettings 1.0

import "../../components"


Page {
    id: wifiPage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("Power save")
    }

    ConfigurationValue{
        id: powerSaveLevel
        key: "/home/glacier/power/powerSaveLevel"
        defaultValue: 5
    }

    DisplaySettings {
        id: displaySettings

        onPowerSaveModeThresholdChanged: {
            console.log("powerSaveModeThreshold: "+displaySettings.powerSaveModeThreshold)
            for (var i = 0; i < thresholdRollerModel.count; ++i) {
                if(thresholdRollerModel.get(i).name == displaySettings.powerSaveModeThreshold) {
                    powerSaveModeThresholdRoller.currentIndex = i

                    console.log("powerSaveModeThresholdRoller: " + powerSaveModeThresholdRoller.currentIndex+" "+thresholdRollerModel.get(i).name)
                }
            }
        }
    }

    ListModel{
        id: thresholdRollerModel
        ListElement { name: "0"}
        ListElement { name: "1"; }
        ListElement { name: "5"; }
        ListElement { name: "10"; }
        ListElement { name: "20"; }
    }

    SettingsColumn{
        id: forcePowerSaveColumn
        spacing: Theme.itemSpacingLarge

        RightCheckBox {
            id: forcePowerSaveCheckBox
            label: qsTr("Force power save")
            checked: displaySettings.powerSaveModeForced
            anchors{
                right: parent.right
                verticalCenter: nameLabel.verticalCenter
            }
            onClicked:{
                displaySettings.powerSaveModeForced = forcePowerSaveCheckBox.checked
                if(forcePowerSaveCheckBox.checked) {
                    displaySettings.powerSaveModeEnabled = true
                }
            }
        }

        GlacierRoller {
            id: powerSaveModeThresholdRoller
            width: parent.width

            clip: true
            model: thresholdRollerModel
            label: qsTr("Power save mode battery level threshold")
            delegate: GlacierRollerItem{
                Text{
                    height: powerSaveModeThresholdRoller.itemHeight
                    verticalAlignment: Text.AlignVCenter
                    text: name
                    color: Theme.textColor
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: (powerSaveModeThresholdRoller.activated && powerSaveModeThresholdRoller.currentIndex === index)
                }
            }
            onCurrentIndexChanged: if(thresholdRollerModel.get(currentIndex).name != displaySettings.powerSaveModeThreshold) {
                                       displaySettings.powerSaveModeThreshold = thresholdRollerModel.get(currentIndex).name
                                   }

        }

        Component.onCompleted: {
            for (var i = 0; i < thresholdRollerModel.count; ++i) {
                if(thresholdRollerModel.get(i).name == displaySettings.powerSaveModeThreshold) {
                    powerSaveModeThresholdRoller.currentIndex = i

                    console.log("powerSaveModeThresholdRoller: " + powerSaveModeThresholdRoller.currentIndex+" "+thresholdRollerModel.get(i).name)
                }
            }
        }
    }
}
