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
import QtQuick.Window 2.1

import QtMultimedia 5.15

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0

import "../../components"

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


        Label{
            text: qsTr("Ringer Volume");
        }

        Slider{
            width: parent.width

            minimumValue: 0
            maximumValue: 100
            value: profile.ringerVolume
            stepSize: 1
            onValueChanged: {
                profile.ringerVolume = value
            }
        }

        GlacierRoller {
            id: vibraModeRoller
            label: qsTr("Vibra Mode")
            width:  parent.width

// enum:
//        VibraAlways,
//        VibraSilent,
//        VibraNormal,
//        VibraNever

            model: ListModel {
                ListElement { name: qsTr("Always") }
                ListElement { name: qsTr("Silent") }
                ListElement { name: qsTr("Normal") }
                ListElement { name: qsTr("Never") }
            }
            delegate: GlacierRollerItem{
                Text{
//                        height: serverType.itemHeight
                    verticalAlignment: Text.AlignVCenter
                    text: name
                    color: Theme.textColor
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: (profile.vibraMode === index)
                }
            }
        }



        Label{
            text: qsTr("System sound level");
        }

        Slider{
            width: parent.width

            minimumValue: 0
            maximumValue: 100
            value: profile.systemSoundLevel
            stepSize: 1
            onValueChanged: {
                profile.systemSoundLevel = value
            }
        }

        Label{
            text: qsTr("Touch screen Tone Level");
        }

        Slider{
            width: parent.width

            minimumValue: 0
            maximumValue: 100
            value: profile.touchscreenToneLevel
            stepSize: 1
            onValueChanged: {
                profile.touchscreenToneLevel = value
            }
        }


        Rectangle{
            width: parent.width
            height: childrenRect.height
            color: "transparent"

            Label{
                text: qsTr("Ringer tone");
                anchors.left: parent.left
                anchors.top: parent.top
            }

            CheckBox{
                checked: profile.ringerToneEnabled
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onClicked: profile.ringerToneEnabled = checked
            }
        }

        ListViewItemWithActions {
            label: qsTr("Ringer tone file")
            description: profile.ringerToneFile
            width: parent.width
            iconVisible: false
            visible: profile.ringerToneEnabled
            onClicked: {
                console.log("select profile.ringerToneFile" + profile.ringerToneFile)
            }
            actions: [
                ActionButton {
                    iconSource: soundPlayer.playbackState === MediaPlayer.PlayingState ? "image://theme/pause" : "image://theme/play";
                    onClicked: {
                        if (soundPlayer.playbackState === MediaPlayer.PlayingState) {
                            soundPlayer.stop();
                        } else {
                            soundPlayer.source = "/usr/share/sounds/glacier/stereo/ring-1.ogg"
                            // soundPlayer.source = profile.ringerToneFile
                            soundPlayer.play();
                        }
                        
                    }
                }
            ]
        }



        Rectangle{
            width: parent.width
            height: childrenRect.height
            color: "transparent"

            Label{
                text: qsTr("Message tone");
                anchors.left: parent.left
                anchors.top: parent.top
            }

            CheckBox{
                checked: profile.messageToneEnabled
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                onClicked: profile.messageToneEnabled = checked
            }
        }

        ListViewItemWithActions {
            label: qsTr("Message tone file")
            description: profile.messageToneFile
            iconVisible: false
            visible: profile.messageToneEnabled
            onClicked: {
                console.log("profile.messageToneFile")
            }
        }


    } // Column
    } // Flickable

    ScrollDecorator{
            id: decorator
            flickable: mainFlickable
    }

    
}