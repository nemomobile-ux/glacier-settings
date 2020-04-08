/*
 * Copyright (C) 2018-2019 Chupligin Sergey <neochapay@gmail.com>
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

    property date currentDate: new Date()

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


    SettingsColumn{
        Row{
            id: dateView
            width: parent.width

            TimePicker{
                id: timePicker
                height: width
                width: listViewPage.width/2

                hours: currentDate.getHours()
                minutes: currentDate.getMinutes()
            }

            Column{
                id: dateLabel
                width: parent.width/2

                Text{
                    id: dayLabel
                    text: currentDate.getDate()
                    width: parent.width
                    height: timePicker.height/3
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Theme.fontSizeExtraLarge
                    color: Theme.accentColor
                }

                Text {
                    id: monthLabel
                    text: monthNames[currentDate.getMonth()]
                    width: parent.width
                    height: timePicker.height/3
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: Theme.fontSizeExtraLarge
                    color: Theme.accentColor
                }

                Text {
                    id: yearLabel
                    text: currentDate.getFullYear()
                    width: parent.width
                    height: timePicker.height/3
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Theme.fontSizeExtraLarge
                    color: Theme.accentColor
                }
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
                }
            }

        }

        CheckBox{
            id: automaticTimeUpdateCheckbox
            text: qsTr("Automatic time update")
            checked: dateTimeSettings.automaticTimeUpdate
            onClicked:{
                dateTimeSettings.automaticTimeUpdate = automaticTimeUpdateCheckbox.checked
            }
        }

        CheckBox{
            id: automaticTimezoneUpdateCheckbox
            text: qsTr("Automatic time zone update")
            checked: dateTimeSettings.automaticTimezoneUpdate
            onClicked:{
                dateTimeSettings.automaticTimezoneUpdate = automaticTimezoneUpdateCheckbox.checked
            }
        }

    }
}
