/*
 * Copyright (C) 2019-2021 Chupligin Sergey <neochapay@gmail.com>
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

import MeeGo.QOfono 0.2

import "../../components"

Page {
    id: mobilePage
    property var modems: []

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("Mobile networks")
    }

    OfonoConnMan {
        id: cellularNetworkTechnology
        modemPath:ofonoManager.defaultModem
    }

    OfonoRadioSettings{
        id: radioSettings
        modemPath:ofonoManager.defaultModem
    }

    OfonoManager {
        id: ofonoManager
        onModemsChanged: {
            recalcModel()
        }

        Component.onCompleted: {
            recalcModel()
        }

        function recalcModel() {
            mobilePage.modems = [];
            for(var i = 0; i < ofonoManager.modems.length; i++) {
                mobilePage.modems.push(modems[i]);
            }
            simList.model = mobilePage.modems;
            if(mobilePage.modems.length > 0) {
                noSimLabel.visible = false;
            } else {
                noSimLabel.visible = true;
            }
        }
    }


    Label{
        id: noSimLabel
        visible: mobilePage.modems.length === 0
        text: qsTr("SIM cards unavailable")
        anchors.centerIn: parent
    }


    SettingsColumn{
        id:mobilePageSettingsColumn
        visible: !noSimLabel.visible
        spacing: Theme.itemSpacingLarge

        ListView{
            id: simList
            width: parent.width
            height: childrenRect.height

            model:  mobilePage.modems

            clip: true

            delegate: ListViewItemWithActions{
                id: mFromList
                label: simManager.present? qsTr("Unknow") : qsTr("No sim")
                description: (modemId.powered ? qsTr("Enabled") : qsTr("Disabled")) + " " + cellularRegistration.status
                height: Theme.itemHeightLarge
                iconVisible: false
                showNext: false

                OfonoModem{
                    id: modemId
                    modemPath: modelData

                    onPoweredChanged: {
                        if(powered) {
                            cellularRegistration.registration()
                            cellularRegistration.modemPath = modemId.modemPath
                        }
                    }
                }

                OfonoSimManager{
                    id: simManager
                    modemPath: modelData
                }

                OfonoNetworkRegistration{
                    id: cellularRegistration
                    modemPath: modelData

                    onNameChanged: {
                        mFromList.label = name
                    }
                }

                actions:[
                    ActionButton {
                        iconSource: "image://theme/power-off"
                        onClicked: {
                            if(modemId.powered) {
                                modemId.powered = false
                            } else {
                                modemId.powered = true
                            }
                        }
                    }
                ]
            }
        }

        CheckBox {
            id: autoConnectCheckBox
            width: parent.width
            height: Theme.itemHeightLarge

            checked: cellularNetworkTechnology.powered
            text: qsTr("Connect to internet")

            onClicked: {
                cellularNetworkTechnology.powered = !cellularNetworkTechnology.powered
            }
        }

        CheckBox {
            id: roamingCheckBox
            width: parent.width

            checked: cellularNetworkTechnology.roamingAllowed
            text: qsTr("Enable data roaming")

            onClicked: {
                cellularNetworkTechnology.roamingAllowed = !cellularNetworkTechnology.roamingAllowed
            }
        }

        GlacierRoller{
            id: techSelector
            width: parent.width
            label: qsTr("Preferred network")

            model: radioSettings.availableTechnologies

            delegate: GlacierRollerItem{
                Text{
                    id: tech
                    verticalAlignment: Text.AlignVCenter
                    height: techSelector.itemHeight
                    text: modelData
                    color: Theme.textColor
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: modelData == radioSettings.technologyPreference
                }
            }

            onCurrentIndexChanged: {
                radioSettings.technologyPreference = radioSettings.availableTechnologies[currentIndex]
            }
        }

    }
}
