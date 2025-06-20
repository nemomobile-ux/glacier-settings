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

import Nemo
import Nemo.Controls

import Connman 0.2

import Glacier.Controls.Settings 1.0

Page {
    id: savedWifiStatusPage
    property var modelData

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true
        title: modelData.name
    }

    SettingsColumn{
        id: actionColumn


        RightCheckBox {
            id: columnCheckBox
            label: qsTr("Auto connect")
            checked: modelData.autoConnect
            anchors{
                right: parent.right
                verticalCenter: nameLabel.verticalCenter
            }

            onClicked: {
                modelData.autoConnect = !modelData.autoConnect;
            }
        }

        Rectangle{
            width: parent.width
            height: childrenRect.height

            color: "transparent"

            Button{
                id: disconnectButton
                width: parent.width
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                text: qsTr("Remove")
                onClicked: {
                    modelData.remove();
                    console.log("Remove clicked");
                    main.pageStack.pop();
                }
            }
        }
    }
}
