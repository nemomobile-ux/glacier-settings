/*
 * Copyright (C) 2019 Chupligin Sergey <neochapay@gmail.com>
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

import org.nemomobile.systemsettings 1.0

import "../../components"

Page {
    id: usbPage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("USB")
    }

    USBSettings{
        id: usbSettings

        onSupportedModesChanged: {
            for(var i = 0; i <= usbSettings.supportedModes.length; i++) {
                if(usbSettings.supportedModes[i] === usbSettings.currentMode) {
                    usbModeRoller.currentIndex = i;
                }
            }
        }

        onCurrentModeChanged: {
            currentModeLabel.text = qsTr("Current mode: ") + formatMode(usbSettings.currentMode)
        }
    }

    Flickable{
        width: parent.width
        height: parent.height-size.dp(80)

        clip: true
        anchors{
            top: parent.top
            topMargin: size.dp(80)
            left: parent.left
            leftMargin: size.dp(20)
        }

        Column{
            width: parent.width
            spacing: Theme.itemSpacingMedium

            Label{
                id: currentModeLabel
                text: qsTr("Current mode: ") + formatMode(usbSettings.currentMode)
            }

            GlacierRoller {
                id: usbModeRoller
                width: parent.width

                clip: true
                model: usbSettings.availableModes
                label: qsTr("Select USB mode")
                delegate: GlacierRollerItem{
                    id: item
                    Text{
                        height: usbModeRoller.itemHeight
                        verticalAlignment: Text.AlignVCenter
                        text: formatMode(modelData)
                        color: Theme.textColor
                        font.pixelSize: Theme.fontSizeMedium
                        font.bold: (usbModeRoller.activated && usbModeRoller.currentIndex === index)
                    }
                }

                onCurrentIndexChanged: {
                    usbSettings.currentMode = usbSettings.supportedModes[currentIndex]
                }
            }
        }
    }

    function formatMode(mode) {
        switch(mode) {
        case "ask":
            return qsTr("Always ask")
        case "mtp_mode":
            return qsTr("MTP")
        case "charging_only":
            return qsTr("Chagring only")
        case "connection_sharing":
            return qsTr("Connection sharing")
        case "developer_mode":
            return qsTr("Developer mode")
        case "busy":
            return qsTr("Busy")
        default:
            return mode
        }
    }
}
