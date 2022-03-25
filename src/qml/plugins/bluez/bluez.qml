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

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2
import org.kde.bluezqt 1.0 as BluezQt
import Nemo.DBus 2.0

import org.nemomobile.models 1.0

import "../../components"

Page {
    id: bluetoothPage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("Bluetooth")
    }

    property QtObject _bluetoothManager: BluezQt.Manager
    property QtObject _adapter: _bluetoothManager.usableAdapter

    TechnologyModel {
        id: bluetoothModel
        name: "bluetooth"

        onPoweredChanged: {
            bluetoothTimer.stop();
            columnCheckBox.indeterminate = false
            columnCheckBox.checked = bluetoothModel.powered

            if(powered) {
                _adapter.startDiscovery()
            }
        }
    }

    DBusInterface {
        id: btInterface
        service: "org.nemomobile.lipstick"
        path: "/org/nemomobile/lipstick/bluetoothagent"
        iface: "org.nemomobile.lipstick"
    }

    BluezQt.DevicesModel {
        id: bluetoothDevicesModel
    }

    Timer{
        id: bluetoothTimer
        interval: 5000
        repeat: false
        onTriggered: {
            columnCheckBox.indeterminate = false
            columnCheckBox.checked = bluetoothModel.powered
        }
    }

    ScrollDecorator{
        id: bluezScrollDecorator
        flickable: bluetoothFlickable
    }

    Label{
        id: btNotFound
        text: qsTr("Bluetooth adapters not available")
        visible: !bluetoothModel.available
        anchors.centerIn: parent
    }

    Flickable{
        id: bluetoothFlickable
        anchors.fill: parent
        contentWidth: parent.width;
        contentHeight: bluetoothColumn.height+Theme.itemHeightLarge
        visible: bluetoothModel.available

        SettingsColumn{
            id: bluetoothColumn
            height: childrenRect.height
            spacing: Theme.itemSpacingLarge

            RightCheckBox {
                id: columnCheckBox
                checked: bluetoothModel.powered
                label: qsTr("Enable Bluetooth")

                onClicked: {
                    bluetoothModel.powered = columnCheckBox.checked
                    columnCheckBox.indeterminate = true
                    bluetoothTimer.start()
                }
            }


            Label {
                id: bluetoothNameLabel
                text: qsTr("Device name");
                font.bold: true

                visible: bluetoothModel.powered
            }

            TextField {
                id: bluetoothNameInput
                text: _adapter ? _adapter.name : ""

                width: parent.width

                font.pixelSize: Theme.fontSizeLarge
                visible: bluetoothModel.powered

                onEditingFinished: {
                    if (_adapter) {
                        var newName = text.length ? text : _adapter.name
                        if (_adapter.name != newName) {
                            _adapter.name = newName
                        } else {
                            text = _adapter.name
                        }
                    }
                }
            }

            RightCheckBox {
                id: visibilityCheckBox
                checked: bluetoothPage._adapter ? bluetoothPage._adapter.discoverable : false
                visible: bluetoothModel.powered
                label: qsTr("Visibility")

                onClicked: {
                    if (!bluetoothPage._adapter) {
                        console.log("Adapter not found")
                        checked = bluetoothPage._adapter.discoverable
                        return;
                    }
                    bluetoothPage._adapter.discoverable = checked;
                }
            }

            Label{
                id: pairedLabel
                text: qsTr("Paired devices:")
                width: parent.width
                height: visible ? Theme.itemHeightLarge : 0

                font.pixelSize: Theme.fontSizeLarge

                visible: bluetoothModel.powered && pairedListView.count > 0

            }

            BtDevisesList{
                id: pairedListView
                model: SortFilterModel {
                    sourceModel: bluetoothDevicesModel
                    filterRole: "Paired"
                    filterRegExp: "true"
                }
                visible: bluetoothModel.powered
                height: Theme.itemHeightLarge * pairedListView.count
            }


            Label{
                id: aviableLabel
                text: qsTr("Devices nearby:")

                width: parent.width
                height: visible ? Theme.itemHeightLarge : 0

                font.pixelSize: Theme.fontSizeLarge

                visible: bluetoothModel.powered && nearbyListView.count > 0

                anchors{
                    left: parent.left
                }
            }

            BtDevisesList{
                id: nearbyListView
                model: SortFilterModel {
                    sourceModel: bluetoothDevicesModel
                    filterRole: "Paired"
                    filterRegExp: "false"
                }
                visible: bluetoothModel.powered
                height: Theme.itemHeightLarge * nearbyListView.count
            }


            Button{
                id: startDiscovery
                text: _adapter ? (_adapter.discovering) ? qsTr("Stop search") : qsTr("Start discovery") : ""
                visible: bluetoothModel.powered
                width: parent.width

                onClicked: {
                    if (_adapter.discovering) {
                        _adapter.stopDiscovery()
                    } else {
                        _adapter.startDiscovery()
                    }
                }
            }
        }
    }
}
