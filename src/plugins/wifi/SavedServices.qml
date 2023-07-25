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

import Connman 0.2

import Glacier.Controls.Settings 1.0

Page {
    id: savedPage
    headerTools: HeaderToolsLayout{
        id: header
        showBackButton: true
        title: qsTr("Manage saved networks")
    }

    SavedServiceModel{
        id: savedModel
    }

    Component.onCompleted: {
        savedModel.name = "wifi";
    }

    ListView{
        id: savedListView
        y: header.height
        width: parent.width
        height: parent.height - header.height
        model: savedModel
        delegate: ListViewItemWithActions{
            height: size.dp(80)
            label: networkService.name
            width: savedPage.width

            onClicked: {
                pageStack.push(Qt.resolvedUrl("SavedStatus.qml"), {modelData: networkService});
            }
        }
    }

    Label{
        anchors.centerIn: parent
        text: qsTr("No saved wifi networks")
        visible: savedListView.count == 0
    }
}
