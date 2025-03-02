/*
 *
 * Copyright (C) 2022 Chupligin Sergey <neochapay@gmail.com>
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

import QtMultimedia

import Nemo
import Nemo.Controls

import org.nemomobile.systemsettings 1.0

import Glacier.Controls.Settings 1.0

Page {
    id: profilePage

    headerTools: HeaderToolsLayout { showBackButton: true; title: qsTr("Sounds")}

    Component.onCompleted: {
        console.log("profile.ringerVolume              "+ profile.ringerVolume)
        console.log("profile.vibraMode                 "+ profile.vibraMode)
        console.log("profile.systemSoundLevel          "+ profile.systemSoundLevel)
        console.log("profile.touchscreenToneLevel      "+ profile.touchscreenToneLevel)
        console.log("profile.touchscreenVibrationLevel "+ profile.touchscreenVibrationLevel)

        console.log("profile.ringerToneFile            "+ profile.ringerToneFile          )
        console.log("profile.messageToneFile           "+ profile.messageToneFile         )
        console.log("profile.chatToneFile              "+ profile.chatToneFile            )
        console.log("profile.mailToneFile              "+ profile.mailToneFile            )
        console.log("profile.internetCallToneFile      "+ profile.internetCallToneFile    )
        console.log("profile.calendarToneFile          "+ profile.calendarToneFile        )
        console.log("profile.clockAlarmToneFile        "+ profile.clockAlarmToneFile      )

        console.log("profile.ringerToneEnabled         "+ profile.ringerToneEnabled       )
        console.log("profile.messageToneEnabled        "+ profile.messageToneEnabled      )
        console.log("profile.chatToneEnabled           "+ profile.chatToneEnabled         )
        console.log("profile.mailToneEnabled           "+ profile.mailToneEnabled         )
        console.log("profile.internetCallToneEnabled   "+ profile.internetCallToneEnabled )
        console.log("profile.calendarToneEnabled       "+ profile.calendarToneEnabled     )
        console.log("profile.clockAlarmToneEnabled     "+ profile.clockAlarmToneEnabled   )

    }

    ProfileControl {
        id: profile
    }


    MediaPlayer {
        id: soundPlayer
    }


    Flickable {
        id: mainFlickable
        height: profilePage.height-tools.height
        width: profilePage.width

        contentHeight: column.height


    SettingsColumn{
        id: column
        spacing: Theme.itemSpacingLarge

        Label {
            text: qsTr("Ringer Volume");
        }
        Slider {
            showValue: true
            alwaysUp: true
            from: 0
            to: 100
            value: profile.ringerVolume
            stepSize: 1
            onValueChanged: {
                profile.ringerVolume = value
            }
        }

        GlacierRoller {
            id: vibraModeRoller
            label: qsTr("Vibrations mode")
            width:  parent.width
            currentIndex: profile.vibraMode

            // enum: VibraAlways, VibraSilent, VibraNormal, VibraNever

            model: ListModel {
                ListElement { name: qsTr("Always") }
                ListElement { name: qsTr("Silent") }
                ListElement { name: qsTr("Normal") }
                ListElement { name: qsTr("Never") }
            }
            delegate: GlacierRollerItem{
                Text{
                    verticalAlignment: Text.AlignVCenter
                    text: name
                    color: Theme.textColor
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: (profile.vibraMode === index)
                }
            }
        }



        Label {
            text: qsTr("System sound level");
        }

        Slider {
            showValue: false
            alwaysUp: false
            from: 0
            to: 2
            value: profile.systemSoundLevel
            stepSize: 1
            onValueChanged: {
                profile.systemSoundLevel = value
            }
        }

        Label {
            text: qsTr("Touch screen tone level");
        }

        Slider {
            showValue: false
            alwaysUp: false
            from: 0
            to: 2
            value: profile.touchscreenToneLevel
            stepSize: 1
            onValueChanged: {
                profile.touchscreenToneLevel = value
            }
        }


        Label {
            text: qsTr("Touch screen vibration level");
        }

        Slider {
            showValue: false
            alwaysUp: false
            from: 0
            to: 2
            value: profile.touchscreenVibrationLevel
            stepSize: 1
            onValueChanged: {
                profile.touchscreenVibrationLevel = value
            }
        }

//// files ////

        // ringer
        SoundLabel {
            label: qsTr("Ringer tone")
            description: profile.ringerToneFile
            selectedFile: profile.ringerToneFile
            onSelectedFileChanged: {
                profile.ringerToneFile = selectedFile
            }

            checked: profile.ringerToneEnabled
            onClicked: profile.ringerToneEnabled = checked
        }


        // message
        SoundLabel {
            label: qsTr("Message tone")
            description: profile.messageToneFile
            selectedFile: profile.messageToneFile
            onSelectedFileChanged: {
                profile.messageToneFile = selectedFile
            }

            checked: profile.messageToneEnabled
            onClicked: profile.messageToneEnabled = checked
        }


        // chat
        SoundLabel {
            label: qsTr("Chat tone")
            description: profile.chatToneFile
            selectedFile: profile.chatToneFile
            onSelectedFileChanged: {
                profile.chatToneFile = selectedFile
            }

            checked: profile.chatToneEnabled
            onClicked: profile.chatToneEnabled = checked
        }


        // mail
        SoundLabel {
            label: qsTr("Mail tone")
            description: profile.mailToneFile
            selectedFile: profile.mailToneFile
            onSelectedFileChanged: {
                profile.mailToneFile = selectedFile
            }

            checked: profile.mailToneEnabled
            onClicked: profile.mailToneEnabled = checked
        }


        // internetCall
        SoundLabel {
            label: qsTr("Internet call tone")
            description: profile.internetCallToneFile
            selectedFile: profile.internetCallToneFile
            onSelectedFileChanged: {
                profile.internetCallToneFile = selectedFile
            }

            checked: profile.internetCallToneEnabled
            onClicked: profile.internetCallToneEnabled = checked
        }


        // calendar
        SoundLabel {
            label: qsTr("Calendar tone")
            description: profile.calendarToneFile
            selectedFile: profile.calendarToneFile
            onSelectedFileChanged: {
                profile.calendarToneFile = selectedFile
            }

            checked: profile.calendarToneEnabled
            onClicked: profile.calendarToneEnabled = checked
        }


        // clockAlarm
        SoundLabel {
            label: qsTr("Alarm clock tone")
            description: profile.clockAlarmToneFile
            selectedFile: profile.clockAlarmToneFile
            onSelectedFileChanged: {
                profile.clockAlarmToneFile = selectedFile
            }

            checked: profile.clockAlarmToneEnabled
            onClicked: profile.clockAlarmToneEnabled = checked
        }







    } // Column
    } // Flickable

    ScrollDecorator{
            id: decorator
            flickable: mainFlickable
    }

}
