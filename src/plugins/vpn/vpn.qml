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

import Nemo.Connectivity

Page {
    id: vpnPage
    headerTools: HeaderToolsLayout {
        id: header

        showBackButton: true
        title: qsTr("VPN")
        tools: [
            ToolButton {
                iconSource: "image://theme/plus"
                showCounter: false

                onClicked: pageStack.push(Qt.resolvedUrl("AddVpnPage.qml"))
            }
        ]
    }

    Label{
        id: vpnNotAdded
        text: qsTr("VPN providers not added.")
        visible: SettingsVpnModel.count == 0
        anchors.centerIn: parent
    }

    ListView {
        id: vpnList
        anchors.fill: parent
        model: SettingsVpnModel
        delegate: ListViewItemWithActions {
            label: model.Name
            iconVisible: false
            onClicked: pageStack.push("VpnEditPage.qml", { vpnIndex: index })
        }
    }
}
