/*
 * Copyright (C) 2026 Chupligin Sergey <neochapay@gmail.com>
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

import Nemo
import Nemo.Controls

import Connman 0.2

import Glacier.Controls.Settings 1.0

Page {
    id: ethernetPage

    headerTools: HeaderToolsLayout {
        showBackButton: true
        title: qsTr("Ethernet")
    }

    TechnologyModel {
        id: ethernetModel
        name: "ethernet"
    }

    Timer {
        id: ethernetTimer
        interval: 5000
        repeat: false
        onTriggered: {
            ethernetEnable.indeterminate = false
            ethernetEnable.checked = ethernetModel.powered
        }
    }

    SettingsColumn {
        id: actionColumn
        anchors.fill: parent

        RightCheckBox {
            id: ethernetEnable
            label: qsTr("Enable Ethernet")
            checked: ethernetModel.powered
            width: parent.width

            onClicked: {
                ethernetModel.powered = !ethernetModel.powered
                ethernetEnable.indeterminate = true
                ethernetTimer.start()
            }
        }

        Label {
            visible: ethernetModel.powered
            text: qsTr("Connections")
            font.pixelSize: Theme.fontSizeLarge
            color: Theme.textColor
        }

        ListView {
            visible: ethernetModel.powered
            width: parent.width
            height: parent.height - ethernetEnable.height - Theme.itemHeightLarge
            clip: true
            model: ethernetModel

            delegate: ListViewItemWithActions {
                label: modelData.name !== "" ? modelData.name : qsTr("Wired connection")
                description: {
                    if (modelData.state === "online" || modelData.state === "ready") {
                        return qsTr("connected")
                    } else if (modelData.state === "association" || modelData.state === "configuration") {
                        return qsTr("connecting...")
                    }
                    return qsTr("disconnected")
                }
                iconVisible: false
                showNext: true

                onClicked: {
                    main.pageStack.push(Qt.resolvedUrl("EthernetSettings.qml"), { modelData: modelData })
                }

                actions: [
                    ActionButton {
                        iconSource: "image://theme/unlink"
                        visible: modelData.state === "online" || modelData.state === "ready"
                        onClicked: modelData.requestDisconnect()
                    }
                ]
            }

            ScrollDecorator {}
        }
    }

    Label {
        visible: !ethernetModel.powered
        text: qsTr("Ethernet is disabled")
        anchors.centerIn: parent
    }
}
