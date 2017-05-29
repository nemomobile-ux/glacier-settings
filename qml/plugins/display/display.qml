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

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0

import "../../components"

Page {
    id: listViewPage

    headerTools: HeaderToolsLayout { showBackButton: true; title: qsTr("Display settings")}

    DisplaySettings{
        id: displaySettings
    }

    Component.onCompleted: {
        console.log(displaySettings.blankTimeout)
    }


    SettingsColumn{
        id: display

        Label{
            id: brightnessLabel
            text: qsTr("Brightness");
        }

        Slider{
            id: brightnessSlider
            width: parent.width

            minimumValue: 0
            maximumValue: displaySettings.maximumBrightness
            value: displaySettings.brightness
            stepSize: 1
            onValueChanged: {
                displaySettings.brightness = value
            }
            enabled: !displaySettings.autoBrightnessEnabled
        }

        Rectangle{
            id: autoBrightnessSettings
            width: parent.width
            height: childrenRect.height

            color: "transparent"

            Label{
                id: autoBrightnessLabel
                text: qsTr("Auto brightness");
                anchors{
                    left: parent.left
                    top: parent.top
                }
            }

            CheckBox{
                id: autoBrightnessCheck
                checked: displaySettings.autoBrightnessEnabled
                anchors{
                    right: parent.right
                    verticalCenter: autoBrightnessLabel.verticalCenter
                }
                onClicked: displaySettings.autoBrightnessEnabled = checked
            }
        }


        Label{
            id: dimTimeoutLabel
            text: qsTr("Dim timeout");
        }

        Slider{
            id: dimTimeoutSlider
            width: parent.width
            minimumValue: 0
            maximumValue: 60
            value: displaySettings.dimTimeout
            stepSize: 10
            onValueChanged: {
                displaySettings.dimTimeout = value
            }
        }


        Label{
            id: blankTimeoutLabel
            text: qsTr("Blank timeout");
        }

        Slider{
            id: blankTimeoutSlider
            width: parent.width

            minimumValue: 0
            maximumValue: 60
            value: displaySettings.blankTimeout
            stepSize: 10
            onValueChanged: {
                displaySettings.blankTimeout = value
            }
        }
    }
}

