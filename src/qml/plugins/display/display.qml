/*
 * Copyright (C) 2017-2021 Chupligin Sergey <neochapay@gmail.com>
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

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0
import org.nemomobile.glacier.settings 1.0

import Nemo.Configuration 1.0

import "../../components"

Page {
    id: displaySettingsPage

    headerTools: HeaderToolsLayout { showBackButton: true; title: qsTr("Display")}

    ConfigurationValue {
        id: dpScaleFactor
        key: "/nemo/apps/libglacier/dpScaleFactor"
        defaultValue: "0"
    }

    DisplaySettings{
        id: displaySettings

        onDimTimeoutChanged: {
            for(var i=0; i < dimTimeoutModel.count; i++) {
                if(dimTimeoutModel.get(i).value === displaySettings.dimTimeout) {
                    dsisplaySleepRoller.currentIndex = i
                }
            }
        }
    }

    ScrollDecorator{
        id: displayScroolDecorator
        flickable: displaySettingsFlicable
    }

    ThemesModel{
        id: themesModel
    }

    ListModel{
        id: orientationModel
        ListElement{
            name: qsTr("Dynamic")
        }
        ListElement{
            name: qsTr("Portrait")
        }
        ListElement{
            name: qsTr("Landscape")
        }
    }

    ListModel {
        id: dimTimeoutModel
        ListElement {
            name: qsTr("15 sec")
            value: 15
        }
        ListElement {
            name: qsTr("30 sec")
            value: 30
        }
        ListElement {
            name: qsTr("1 min")
            value: 60
        }
        ListElement {
            name: qsTr("2 min")
            value: 120
        }
        ListElement {
            name: qsTr("5 min")
            value: 300
        }
        ListElement {
            name: qsTr("10 min")
            value: 600
        }
    }

    Flickable{
        id: displaySettingsFlicable
        anchors.fill: parent
        contentHeight: displaySettingsColumn.height + Theme.itemSpacingLarge*4

        SettingsColumn{
            id: displaySettingsColumn
            spacing: Theme.itemSpacingLarge

            Label{
                id: brightnessLabel
                text: qsTr("Brightness");
            }

            RightCheckBox{
                id: autoBrightnessCheck
                label: qsTr("Auto brightness");
                checked: displaySettings.autoBrightnessEnabled
                onClicked: displaySettings.autoBrightnessEnabled = checked
            }


            Slider{
                id: brightnessSlider
                width: parent.width
                visible: ! displaySettings.autoBrightnessEnabled

                minimumValue: 0
                maximumValue: displaySettings.maximumBrightness

                value: displaySettings.brightness

                stepSize: 1
                onValueChanged: {
                    displaySettings.brightness = value
                }
                enabled: !displaySettings.autoBrightnessEnabled
            }

            GlacierRoller {
                id: dsisplaySleepRoller
                width: parent.width

                clip: true
                model: dimTimeoutModel
                label: qsTr("Display sleep timeout")

                delegate: GlacierRollerItem{
                    Text{
                        height: dsisplaySleepRoller.itemHeight
                        verticalAlignment: Text.AlignVCenter
                        text: name
                        color: Theme.textColor
                        font.pixelSize: Theme.fontSizeMedium
                        font.bold: (dsisplaySleepRoller.activated && dsisplaySleepRoller.currentIndex === index)
                    }
                }

                onSelect: {
                    displaySettings.dimTimeout = dimTimeoutModel.get(currentItem).value
                }
            }


            GlacierRoller {
                id: orientationLockRoller
                width: parent.width

                clip: true
                model: orientationModel
                label: qsTr("Orientation")

                delegate: GlacierRollerItem{
                    Text{
                        height: orientationLockRoller.itemHeight
                        verticalAlignment: Text.AlignVCenter
                        text: name
                        color: Theme.textColor
                        font.pixelSize: Theme.fontSizeMedium
                        font.bold: (orientationLockRoller.activated && orientationLockRoller.currentIndex === index)
                    }

                    Component.onCompleted: {
                        if(name.toLowerCase() == displaySettings.orientationLock) {
                            orientationLockRoller.currentIndex =  index
                        }
                    }
                }

                onCurrentIndexChanged: {
                    displaySettings.orientationLock = orientationModel.get(orientationLockRoller.currentIndex).name.toLowerCase()
                }
            }

            GlacierRoller {
                id: themeRoller
                width: parent.width

                clip: true
                model: themesModel
                label: qsTr("Theme")

                delegate: GlacierRollerItem{
                    Text{
                        height: themeRoller.itemHeight
                        verticalAlignment: Text.AlignVCenter
                        text: name
                        color: Theme.textColor
                        font.pixelSize: Theme.fontSizeMedium
                        font.bold: (themeRoller.activated && path == Theme.themePath)
                    }

                    Component.onCompleted: {
                        if(path == Theme.themePath) {
                            themeRoller.currentIndex =  index
                        }
                    }
                }

                onCurrentIndexChanged: {
                    //displaySettings.orientationLock = orientationModel.get(orientationLockRoller.currentIndex).name.toLowerCase()
                    Theme.loadTheme(themesModel.getPath(currentIndex))
                }
            }

            Label{
                id: scaleLabel
                text: qsTr("Scaling");
            }

            Slider {
                id: scaleSlider
                value: dpScaleFactor.value == 0 ? size.dpScaleFactor : dpScaleFactor.value
                minimumValue: 0.5
                maximumValue: 2
                stepSize: 0.1
                width: parent.width

                onValueChanged: {
                    dpScaleFactor.value = scaleSlider.value
                }
            }
        }
    }
}

