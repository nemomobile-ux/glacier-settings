/*
 * Copyright (C) 2021 Chupligin Sergey <neochapay@gmail.com>
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

import org.nemomobile.systemsettings 1.0

import org.nemomobile.glacier.settings 1.0

import "../../components"

Page {
    id: dataTimeSetupTimeZone

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Setup time zone")
    }

    TimeZonesModel{
        id: timeZonesModel
    }

    DateTimeSettings{
        id: dateTimeSettings
    }

    SettingsColumn {
        id: timezoneSettingsCollumn
        anchors.fill: parent

        Row{
            id: searchLineItem
            width: parent.width
            height: searchLine.height
            spacing: Theme.itemSpacingMedium

            TextField{
                id: searchLine
                width: parent.width-searchLine.height-Theme.itemSpacingMedium*2
                onTextChanged: {
                    timeZonesModel.search(searchLine.text);
                }
            }

            Image {
                id: searchLineImage
                source: "image://theme/search"
                width: height
                height: searchLine.height
            }
        }

        ListView{
            id: timeZonesList
            width: parent.width
            height: parent.height

            model: timeZonesModel
            delegate: Rectangle{
                width: timeZonesList.width
                height: Theme.itemHeightLarge

                color: Theme.backgroundColor
                Label {
                    color: dateTimeSettings.timezone == name ? Theme.accentColor : Theme.textColor
                    text: name
                    anchors{
                        left: parent.left
                        leftMargin: Theme.itemSpacingSmall
                        verticalCenter: parent.verticalCenter
                    }

                    font.pixelSize: Theme.fontSizeMedium
                    clip: true
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        dateTimeSettings.timezone = name
                    }
                }
            }
        }
    }
}
