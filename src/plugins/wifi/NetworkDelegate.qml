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

import Glacier.Controls.Settings 1.0

ListViewItemWithActions{
    property bool saved

    // use set height and visible properties to
    // skip drawing of some items
    height: {
        if (visible)
            return Theme.itemHeightMedium
        else
            return 0
    }
    visible: {
        if (saved)
            return modelData.autoConnect
        else
            return !modelData.autoConnect
    }

    label: modelData.name
    width: parent.width

    description: {
        if ((modelData.state === "online") || (modelData.state === "ready")) {
            return qsTr("connected");
        } else if (modelData.state === "association" || modelData.state === "configuration") {
            return qsTr("connecting")+"...";
        } else {
            if (modelData.securityType === NetworkService.SecurityNone) {
                return qsTr("open");
            } else if (modelData.securityType === NetworkService.SecurityUnknown) {
                return qsTr("unknown");
            } else {
                return qsTr("secure");
            }
        }
    }
    icon: (getStrengthIndex(modelData.strength) === "0") ?
              "image://theme/icon_wifi_0" : "image://theme/icon_wifi_focused" +
              getStrengthIndex(modelData.strength)

    onClicked:{
        if (modelData.state === "idle" || modelData.state === "failure"){
            console.log("Show settings page");
            pageStack.push(Qt.resolvedUrl("WifiSettings.qml"),{modelData: modelData});
        } else {
            console.log("Show network status page");
            var component = Qt.createComponent(Qt.resolvedUrl("WifiStatus.qml")).errorString();
            console.log(component);
            pageStack.push(Qt.resolvedUrl("WifiStatus.qml"),{modelData: modelData});
        }
    }

    actions: [
        ActionButton {
            id: removeNetworkButton
            visible: saved
            iconSource: "image://theme/trash"

            onClicked: {
                modelData.remove();
            }
        },
        ActionButton {
            id: disconnectNetworkButton
            iconSource: "image://theme/unlink"
            visible: (modelData.state === "online" || modelData.state === "ready")
            onClicked: {
                modelData.requestDisconnect();
            }
        }
    ]
}
