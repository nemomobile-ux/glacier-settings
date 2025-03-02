/*
 * Copyright (C) 2019-2022 Chupligin Sergey <neochapay@gmail.com>
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
import Nemo
import Nemo.Controls
import org.nemomobile.systemsettings 1.0
import Glacier.Controls.Settings 1.0

Page {
    id: usbPage

    function formatMode(mode) {
        switch (mode) {
        case "ask":
            return qsTr("Always ask");
        case "mtp_mode":
            return qsTr("MTP");
        case "charging_only":
            return qsTr("Charging only");
        case "connection_sharing":
            return qsTr("Connection sharing");
        case "developer_mode":
            return qsTr("Developer mode");
        case "busy":
            return qsTr("Busy");
        default:
            return mode;
        }
    }

    ListModel {
        id: modesModel
    }

    USBSettings {
        id: usbSettings

        onSupportedModesChanged: {
            modesModel.clear();
            modesModel.append({
                "label": formatMode("ask"),
                "mode": "ask"
            });
            for (var i = 0; i < usbSettings.supportedModes.length; i++) {
                var mode = usbSettings.supportedModes[i];
                var label = formatMode(mode);
                modesModel.append({
                    "label": label,
                    "mode": mode
                });
            }
        }
    }

    Label {
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: Theme.fontSizeLarge
        font.family: Theme.fontFamily
        color: Theme.textColor
        text: qsTr("No USB mode available")
        visible: modesModel.count === 0
    }

    Spinner {
        anchors.centerIn: parent
        enabled: usbSettings.currentMode === "busy"
        visible: enabled
    }

    ListView {
        anchors.fill: parent
        clip: true
        model: modesModel

        delegate: ListViewItemWithActions {
            label: model.label
            description: usbSettings.currentMode === model.mode ? qsTr("Active") : ""
            showNext: false
            iconVisible: false
            selected: usbSettings.configMode === model.mode
            onClicked: {
                usbSettings.configMode = model.mode;
                usbSettings.currentMode = model.mode;
            }
        }

    }

    headerTools: HeaderToolsLayout {
        id: header

        showBackButton: true
        title: qsTr("USB")
    }

}
