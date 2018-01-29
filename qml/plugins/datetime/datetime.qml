/*
 * Copyright (C) 2018 Chupligin Sergey <neochapay@gmail.com>
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

    SettingsColumn{
        Item{
            id: dateView
            width: parent.width
            height: parent.width/5*3

            TimePicker{
                id: timePicker
                height: parent.height
                width: height

                hours: currentDate.getHours()
                minutes: currentDate.getMinutes()

                active: false
            }
            Item{
                id: dateLabel
                width: parent.width-timePicker.width

                height: parent.height

                anchors.left: timePicker.right

                Text{
                    id: dayLabel
                    text: "00"
                    width: parent.width/2
                    anchors{
                        bottom: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }
                    font.pixelSize: dateLabel.height/3
                    fontSizeMode: Text.Fit
                    color: Theme.accentColor
                }

                Text {
                    id: monthLabel
                    text: monthNames[currentDate.getMonth()]
                    width: parent.width/2
                    font.pixelSize: dateLabel.height
                    horizontalAlignment: Text.AlignHCenter
                    anchors{
                        left: dayLabel.left
                        top: dayLabel.bottom
                        topMargin: Theme.itemSpacingExtraSmall
                    }
                    fontSizeMode: Text.Fit
                    color: Theme.accentColor
                    opacity: 0.5
                }


                Text {
                    id: yearLabel
                    text: currentDate.getFullYear()
                    width: parent.width/2
                    font.bold: true
                    font.pixelSize: dateLabel.height
                    horizontalAlignment: Text.AlignHCenter
                    anchors{
                        left: monthLabel.left
                        top: monthLabel.bottom
                        topMargin: Theme.itemSpacingExtraSmall
                    }
                    fontSizeMode: Text.Fit
                    color: Theme.accentColor
                    opacity: 0.5
                }
            }
        }

        Item{
            width: parent.width
            height: automaticTimeUpdateCheckbox.height
            id: dateRow
            Label{
                text: qsTr("Date")
            }
            Label{
                text: currentDate.toLocaleDateString();
                anchors.right: parent.right
            }
        }

        Item{
            width: parent.width
            height: automaticTimeUpdateCheckbox.height
            id: timeRow
            Label{
                text: qsTr("Time")
            }

            Label{
                text: currentDate.toLocaleTimeString()
                anchors.right: parent.right
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
