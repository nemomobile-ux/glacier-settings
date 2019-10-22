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

import MeeGo.Connman 0.2
import org.kde.bluezqt 1.0 as BluezQt
import Nemo.Ssu 1.1 as Ssu

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

        Rectangle{
            id: bluetoothEnable
            width: parent.width
            height: childrenRect.height

            color: "transparent"

            Label {
                id: nameLabel
                text: qsTr("Enable Bluetooth")
                anchors {
                    left: bluetoothEnable.left
                }
                wrapMode: Text.Wrap
                font.bold: true
            }

            CheckBox {
                id: columnCheckBox
                checked: bluetoothModel.powered
                anchors {
                    right: bluetoothEnable.right
                    verticalCenter: nameLabel.verticalCenter
                }
                onClicked: {
                    bluetoothModel.powered = columnCheckBox.checked
                    columnCheckBox.indeterminate = true
                    bluetoothTimer.start()
                }
            }
        }


        Label {
            id: bluetoothNameLabel
            text: qsTr("Device name");
            font.bold: true
        }

        TextField {
            id: bluetoothNameInput
            text: _adapter.name

            width: parent.width

            font.pixelSize: Theme.fontSizeLarge

            onEditingFinished: {
                if (_adapter) {
                    var newName = text.length ? text : Ssu.DeviceInfo.displayName(Ssu.DeviceInfo.DeviceModel);
                    if (_adapter.name != newName) {
                        _adapter.name = newName
                    } else {
                        text = _adapter.name
                    }
                }
            }
        }

        Rectangle{
            width: parent.width
            height: childrenRect.height
            color: "transparent"

            Label{
                id: visibilityLabel
                text: qsTr("Visibility")
                anchors{
                    left: parent.left
                }
                wrapMode: Text.Wrap
                font.bold: true
            }

            CheckBox {
                id: visibilityCheckBox
                checked: bluetoothModel.powered
                anchors{
                    right: parent.right
                    verticalCenter: visibilityLabel.verticalCenter
                }
                onClicked: {
                    if (!_adapter) {
                        return;
                    }
                    _adapter.discoverable = checked;
                }
            }
        }

        Rectangle{
            width: parent.width
            height: childrenRect.height
            color: "transparent"

            Text{
                id: aviableLabel
                text: qsTr("Aviable devices:")
                color: Theme.textColor
                font.pixelSize: Theme.fontSizeLarge

                anchors{
                    left: parent.left
                }
            }
        }

        Button{
            id: startDiscovery
            text: (_adapter.discovering) ? qsTr("Stop search") : qsTr("Search discovery")

            onClicked: {
                if (_adapter.discovering) {
                    _adapter.stopDiscovery()
                } else {
                    _adapter.startDiscovery()
                }
            }
        }
    }

    Connections{
        target: _adapter
        onDeviceFound: {
            console.log("*** Remote device found:" + device)
        }
    }
}
