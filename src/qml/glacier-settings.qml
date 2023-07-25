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
import QtQuick.Window 2.1

import Nemo.Controls

import org.nemomobile.glacier.settings 1.0
import org.nemomobile.systemsettings 1.0

import Glacier.Controls.Settings 1.0

ApplicationWindow{
    id: main

    SettingsModel{
        id: settingsModel
    }

    SettingsService{
        id: setingService

        onOpenSettingsPage: {
            if(settingsModel.pluginAviable(plugin)) {
                pageStack.push(Qt.resolvedUrl("file:/"+settingsModel.pluginQmlPath(plugin)))
                main.show()
            } else {
                console.error("Wrong plugin "+plugin)
            }
        }
    }

    initialPage: Page{
        id: mainPage

        allowedOrientations:  Qt.PortraitOrientation | Qt.LandscapeOrientation | Qt.InvertedLandscapeOrientation | Qt.InvertedPortraitOrientation

        headerTools: HeaderToolsLayout {
            id: tools
            title: qsTr("Settings")

            tools: [
                AiroplaneButton {
                    id: airoplaneButton
                },
                WifiButton{
                    id: wifiButton
                },
                VolumeButton {
                    id: volumeButton
                }
            ]

            drawerLevels: [
                Row {
                    id: brightnessRow
                    width: mainPage.width
                    spacing: size.dp(40)
                    padding: size.dp(40)

                    Slider{
                        id: brightnessSlider
                        width: parent.width-brightnessIcon.width-size.dp(120)

                        from: 0
                        to: displaySettings.maximumBrightness
                        value: displaySettings.brightness
                        stepSize: 1
                        onValueChanged: {
                            displaySettings.brightness = value
                        }
                        enabled: !displaySettings.autoBrightnessEnabled

                        DisplaySettings{
                            id: displaySettings
                        }
                    }

                    ToolButton {
                        id: brightnessIcon
                        iconSource: "image://theme/sun"
                        anchors.verticalCenter: brightnessSlider.verticalCenter
                        height: Theme.itemHeightMedium
                        width: height
                        active: displaySettings.autoBrightnessEnabled
                        onClicked: {
                            displaySettings.autoBrightnessEnabled = !displaySettings.autoBrightnessEnabled
                        }
                    }
                }
            ]
        }

        Flickable{
            id: mainArea
            height: mainPage.height-tools.height
            width: mainPage.width

            contentHeight: content.height

            Column {
                id: content
                width: parent.width
                spacing: size.dp(20)

                Repeater {
                    id: view
                    width: parent.width
                    height: childrenRect.height

                    model: settingsModel
                    delegate: Item {
                        id: settingsListDelegate
                        height: sectionHeading.height+flow.height
                        width: mainArea.width
                        visible: items != ""

                        Item {
                            id: sectionHeading
                            width: parent.width
                            height: Theme.itemHeightMedium

                            Text {
                                id: sectionText
                                text: title
                                font.capitalization: Font.AllUppercase
                                font.pixelSize: Theme.fontSizeSmall
                                color: Theme.textColor
                                anchors{
                                    left: parent.left
                                    leftMargin: Theme.itemSpacingSmall
                                    verticalCenter: parent.verticalCenter
                                }
                            }

                            Rectangle{
                                id: line
                                height: size.dp(1)
                                color: Theme.textColor
                                width: content.width-sectionText.width-Theme.itemHeightExtraSmall
                                anchors{
                                    left: sectionText.right
                                    leftMargin: Theme.itemSpacingSmall
                                    verticalCenter: sectionText.verticalCenter
                                }
                            }
                        }

                        Flow{
                            id: flow
                            width: parent.width
                            anchors.top: sectionHeading.bottom
                            Repeater{
                                id: list
                                width: parent.width
                                height: isUiPortrait ?
                                            Theme.itemHeightMedium*items.length :
                                            Theme.itemHeightMedium*Math.ceil(items.length/2)
                                model: items

                                delegate: ListViewItemWithActions {
                                    width: isUiPortrait ? parent.width : parent.width/2
                                    label: modelData.title
                                    icon: modelData.icon
                                    description: modelData.enabled ? modelData.description : qsTr("disabled")
                                    onClicked:{
                                        pageStack.push(Qt.resolvedUrl("file:/"+modelData.path))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        ScrollDecorator{
            id: decorator
            flickable: mainArea
        }
    }
}
