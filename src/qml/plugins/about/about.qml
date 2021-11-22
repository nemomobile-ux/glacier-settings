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

import Nemo.Dialogs 1.0

import org.nemomobile.systemsettings 1.0

import "../../components"

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
            source: "/usr/share/glacier-settings/qml/plugins/about/icon-glacier-icon.png"
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
            spacing: Theme.itemSpacingSmall

            anchors{
                top: glacierLogo.bottom
                topMargin: Theme.itemSpacingLarge
                left: parent.left
                leftMargin: Theme.itemSpacingMedium
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: qsTr("Vendor")
                font.pixelSize: Theme.fontSizeSmall
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: aboutSettings.vendorName
                font.bold: true
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: qsTr("Vendor version")
                font.pixelSize: Theme.fontSizeSmall
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: aboutSettings.vendorVersion
                font.bold: true
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: qsTr("Software version")
                font.pixelSize: Theme.fontSizeSmall
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: aboutSettings.softwareVersion != "" ? aboutSettings.softwareVersion : "n/a"
                font.bold: true
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: qsTr("Adaptation version")
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: aboutSettings.adaptationVersion != "" ? aboutSettings.adaptationVersion : "n/a"
                font.bold: true
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: qsTr("Serial number")
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: aboutSettings.serial != "" ? aboutSettings.serial : "n/a"
                font.bold: true
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: qsTr("IMEI")
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: aboutSettings.imei != "" ? aboutSettings.imei : "n/a"
                font.bold: true
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: qsTr("Wlan MAC")
                wrapMode: Text.WordWrap
                font.pixelSize: Theme.fontSizeSmall
            }

            Label{
                width: parent.width
                height: Theme.itemHeightLarge
                text: aboutSettings.wlanMacAddress != "" ? aboutSettings.wlanMacAddress : "n/a"
                font.bold: true
            }
        }
    }
}
