/*
 * Copyright (C) 2018-2021 Chupligin Sergey <neochapay@gmail.com>
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
import org.nemomobile.configuration 1.0

import "../../components"

Page {
    id: listViewPage

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Date and time")
    }

    property var monthNames: ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]

    DateTimeSettings{
        id: dateTimeSettings
    }

    ListModel{
        id: timeFormatModel
        ListElement{name: qsTr("12h")}
        ListElement{name: qsTr("24h")}
    }

    ConfigurationValue {
        id: timeFormat
        key: "/home/glacier/timeFormat"
        defaultValue: 1 //24H
    }

    Component.onCompleted: {
        timeFormatRoller.currentIndex = timeFormat.value
    }

    ScrollDecorator{
        id: decorator
        flickable: mainContent
    }

    SettingsColumn{
        id: mainContent
        spacing: Theme.itemSpacingLarge

        CheckBox{
            id: automaticTimeUpdateCheckbox
            text: qsTr("Automatic time update")
            checked: dateTimeSettings.automaticTimeUpdate
            width: parent.width
            onClicked:{
                dateTimeSettings.automaticTimeUpdate = automaticTimeUpdateCheckbox.checked
            }
        }

        SettingsClickedItem{
            id: selectDate
            height: visible ? Theme.itemHeightLarge : 0
            width: parent.width
            visible: !dateTimeSettings.automaticTimeUpdate
            description: qsTr("Select date")
            subDescription: Qt.formatDateTime(new Date(), "dd-MM-yyyy");
            onClicked: {
                pageStack.push(Qt.resolvedUrl("SetupDate.qml"));
            }
        }


        SettingsClickedItem{
            id: selectTime
            height: visible ? Theme.itemHeightLarge : 0
            width: parent.width
            visible: !dateTimeSettings.automaticTimeUpdate
            description: qsTr("Select time")
            subDescription: Qt.formatDateTime(new Date(), "HH:mm");
            onClicked: {
                pageStack.push(Qt.resolvedUrl("SetupTime.qml"));
            }
        }

        CheckBox{
            id: automaticTimezoneUpdateCheckbox
            text: qsTr("Automatic time zone update")
            width: parent.width
            checked: dateTimeSettings.automaticTimezoneUpdate
            onClicked:{
                dateTimeSettings.automaticTimezoneUpdate = automaticTimezoneUpdateCheckbox.checked
            }
        }

        SettingsClickedItem{
            id: selectTimeZone
            height: visible ? Theme.itemHeightLarge : 0
            width: parent.width
            visible: !dateTimeSettings.automaticTimezoneUpdate
            description: qsTr("Current time zone")
            subDescription: dateTimeSettings.timezone

            onClicked: {
                pageStack.push(Qt.resolvedUrl("SetupTimezone.qml"));
            }
        }


        GlacierRoller {
            id: timeFormatRoller
            width: parent.width

            clip: true
            model: timeFormatModel
            label: qsTr("Time format")
            delegate:GlacierRollerItem{
                Text{
                    height: timeFormatRoller.itemHeight
                    verticalAlignment: Text.AlignVCenter
                    text: name
                    color: Theme.textColor
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: (timeFormatRoller.activated && timeFormatRoller.currentIndex === index)
                }
            }

            onCurrentIndexChanged: {
                if(timeFormat.value != currentIndex) {
                    timeFormat.value = currentIndex

                    if(currentIndex === 0) {
                        dateTimeSettings.setHourMode(dateTimeSettings.TwentyFourHours)
                    } else {
                        dateTimeSettings.setHourMode(dateTimeSettings.TwelveHours)
                    }
                }
            }

        }
    }
}
