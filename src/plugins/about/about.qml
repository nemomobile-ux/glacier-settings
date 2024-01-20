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

import Nemo.Controls

import Nemo.Dialogs 1.0

import org.nemomobile.systemsettings 1.0

import Glacier.Controls.Settings 1.0

Page {
    id: aboutPage

    property int magicCount: 0

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("About")
    }

    ScrollDecorator{
        id: decorator
        flickable: mainContent
    }

    AboutSettings{
        id: aboutSettings
    }

    DeviceInfo{
        id: deviceInfo
    }

    onMagicCountChanged: {
        if(magicCount == 5)
        {
            pageStack.push(Qt.resolvedUrl("/usr/share/glacier-settings/qml/plugins/about/magic.qml"))
        }
    }

    Flickable {
        id: mainContent
        width: aboutPage.width
        height: aboutPage.height
        contentHeight: glacierLogo.height+abloutGreed.height+Theme.itemSpacingLarge*2

        Image {
            id: glacierLogo
            source: "file:///usr/share/glacier-settings/plugins/about/icon-glacier-icon.png"
            anchors{
                top: parent.top
                topMargin: Theme.itemSpacingLarge
                horizontalCenter: parent.horizontalCenter
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    ++magicCount
                    magicTimer.restart()
                }
            }
        }

        Timer{
            id: magicTimer
            interval: 500
            onTriggered: {
                magicCount = 0
            }
        }

        Column{
            id: abloutGreed
            width: parent.width-Theme.itemSpacingMedium
            spacing: Theme.itemSpacingExtraSmall

            anchors{
                top: glacierLogo.bottom
                topMargin: Theme.itemSpacingLarge
                left: parent.left
                leftMargin: Theme.itemSpacingMedium
            }

            Label{
                width: parent.width
                text: qsTr("Vendor")
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }

            Label{
                width: parent.width
                text: aboutSettings.vendorName
            }

            Label{
                width: parent.width
                text: qsTr("Vendor version")
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }

            Label{
                width: parent.width
                text: aboutSettings.vendorVersion
            }

            Label{
                width: parent.width
                text: qsTr("Software version")
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }

            Label{
                width: parent.width
                text: aboutSettings.softwareVersion != "" ? aboutSettings.softwareVersion : qsTr("n/a")
            }

            Label{
                width: parent.width
                text: qsTr("Adaptation version")
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }

            Label{
                width: parent.width
                text: aboutSettings.adaptationVersion != "" ? aboutSettings.adaptationVersion : qsTr("n/a")
            }

            Label{
                width: parent.width
                text: qsTr("Serial number")
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }

            Label{
                width: parent.width
                text: aboutSettings.serial != "" ? aboutSettings.serial : qsTr("n/a")
            }

            Label{
                width: parent.width
                text: qsTr("IMEI")
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }

            Label{
                width: parent.width
                text: (deviceInfo.imeiNumbers !== undefined && deviceInfo.imeiNumbers[0] !== undefined) ? deviceInfo.imeiNumbers[0] : qsTr("n/a")
            }

            Label{
                width: parent.width
                visible: deviceInfo.imeiNumbers !== undefined && deviceInfo.imeiNumbers[1] !== undefined
                text: visible ? deviceInfo.imeiNumbers[1] : qsTr("n/a")
            }

            Label{
                width: parent.width
                text: qsTr("Wlan MAC")
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
            }

            Label{
                width: parent.width
                text: ((deviceInfo.wlanMacAddress != undefined) && (deviceInfo.wlanMacAddress !== "")) ? deviceInfo.wlanMacAddress : qsTr("n/a")
            }
        }
    }
}
