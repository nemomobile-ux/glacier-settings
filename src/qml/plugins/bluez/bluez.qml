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
        service: "org.glacier.lipstick"
        path: "/bluetooth"
        iface: "org.glacier.lipstick"
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

    SettingsColumn{
        id: bluetoothColumn
        width: parent.width
        height: parent.height

        CheckBox {
            id: columnCheckBox
            checked: bluetoothModel.powered
            text: qsTr("Enable Bluetooth")

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
            text: _adapter.name

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

        CheckBox {
            id: visibilityCheckBox
            checked: bluetoothModel.powered
            visible: bluetoothModel.powered
            text: qsTr("Visibility")

            onClicked: {
                if (!_adapter) {
                    return;
                }
                _adapter.discoverable = checked;
            }
        }

        Text{
            id: pairedLabel
            text: qsTr("Paired devices:")
            color: Theme.textColor
            font.pixelSize: Theme.fontSizeLarge

            visible: bluetoothModel.powered && pairedListView.count > 0

            anchors{
                left: parent.left
            }
        }

        BtDevisesList{
            id: pairedListView
            model: SortFilterModel {
                sourceModel: bluetoothDevicesModel
                filterRole: "Paired"
                filterRegExp: "true"
            }
            visible: bluetoothModel.powered
        }


        Text{
            id: aviableLabel
            text: qsTr("Devices nearby:")
            color: Theme.textColor
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
        }


        Button{
            id: startDiscovery
            text: (_adapter.discovering) ? qsTr("Stop search") : qsTr("Start discovery")
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

    function formatIcon(devType) {
        /* Aviable types
        0  - Phone,
        1  - Modem,
        2  - Computer,
        3  - Network,
        4  - Headset,
        5  - Headphones,
        6  - AudioVideo,
        7  - Keyboard,
        8  - Mouse,
        9  - Joypad,
        10 - Tablet,
        11 - Peripheral,
        12 - Camera,
        13 - Printer,
        14 - Imaging,
        15 - Wearable,
        16 - Toy,
        17 - Health,
        18 - Uncategorized
         */
        switch(devType){
        case 0:
        case 1:
        case 10:
            return "image://theme/mobile"
        case 2:
            return "image://theme/descktop"
        case 3:
            return "image://theme/globe"
        case 4:
        case 5:
            return "image://theme/headphones"
        case 7:
            return "image://theme/keyboard-o"
        case 8:
            return "image://theme/mouse-pointer"
        case 9:
        case 16:
            return "image://theme/gamepad"
        case 11:
        case 13:
            return "image://theme/printer"
        case 12:
        case 14:
            return "image://theme/camera"
        case 15:
            return "image://theme/clock-o"
        case 17:
            return "image://theme/medkit"
        default:
            return "image://theme/circle"
        }

    }
}
