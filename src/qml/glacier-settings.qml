/*
 * Copyright (C) 2017-2025 Chupligin Sergey <neochapay@gmail.com>
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

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Window

import Nemo
import Nemo.Controls

import org.nemomobile.glacier.settings 1.0
import org.nemomobile.systemsettings 1.0

import Glacier.Controls.Settings 1.0

ApplicationWindow{
    id: main

    SettingsModel{
        id: settingsModel
        Component.onCompleted: {
            settingsModel.loadPluginsList();
            Qt.callLater(main.openDefaultPlugin)
        }
    }

    property bool defaultPluginPending: false

    function openDefaultPlugin() {
        // In landscape the main menu is a permanent side panel, so the root grid
        // is redundant. Keep About above it whenever navigation returns to the
        // root page, including after coming back from portrait orientation.
        if (main.isUiPortrait || defaultPluginPending || pageStack.busy || pageStack.depth > 1) {
            return
        }
        defaultPluginPending = true
        // This page is restored automatically, so it must appear without the
        // StackView slide animation (especially visible at application startup).
        pageStack.push(Qt.resolvedUrl("file:///usr/share/glacier-settings/plugins/about/about.qml"),
                       {}, Controls.StackView.Immediate)
    }

    Connections {
        target: pageStack
        function onDepthChanged() {
            if (pageStack.depth > 1) {
                main.defaultPluginPending = false
            }
            Qt.callLater(main.openDefaultPlugin)
        }
        function onBusyChanged(busy) {
            if (!busy) {
                main.defaultPluginPending = false
                Qt.callLater(main.openDefaultPlugin)
            }
        }
    }

    onIsUiPortraitChanged: {
        if (!isUiPortrait) {
            Qt.callLater(openDefaultPlugin)
        }
    }

    mainMenu: Flickable {
        id: mainMenuFlickable
        anchors.fill: parent
        contentHeight: mainMenuColumn.height
        clip: true

        Column {
            id: mainMenuColumn
            width: parent.width

            Repeater {
                model: settingsModel
                delegate: Column {
                    width: mainMenuColumn.width
                    visible: items.length > 0

                    Label {
                        text: title
                        font.capitalization: Font.AllUppercase
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.textColor
                        anchors {
                            left: parent.left
                            leftMargin: Theme.itemSpacingSmall
                        }
                        height: Theme.itemHeightMedium
                        verticalAlignment: Text.AlignVCenter
                    }

                    Repeater {
                        model: items
                        delegate: ListViewItemWithActions {
                            width: mainMenuColumn.width
                            icon: modelData.icon
                            iconVisible: modelData.icon !== ""
                            label: modelData.title
                            description: modelData.enabled ? modelData.description : qsTr("disabled")
                            showNext: false
                            onClicked: {
                                main.push(Qt.resolvedUrl("file:/" + modelData.path))
                            }
                        }
                    }
                }
            }
        }

        ScrollDecorator {
            flickable: mainMenuFlickable
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
        }

        Flickable{
            id: mainArea
            height: mainPage.height-tools.height
            width: mainPage.width

            contentHeight: content.height

            Column {
                id: content
                width: parent.width
                spacing: Theme.dp(20)

                Repeater {
                    id: view
                    width: parent.width
                    height: childrenRect.height

                    model: settingsModel
                    delegate: Item {
                        id: settingsListDelegate
                        height: sectionHeading.height+flow.height
                        width: mainArea.width
                        visible: items.length > 0

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
                                height: Theme.dp(1)
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
                                        console.log("SettingsPage: opening plugin", modelData.title, modelData.path)
                                        pageStack.push(Qt.resolvedUrl("file:/"+modelData.path))
                                        console.log("SettingsPage: push requested", modelData.path)
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
