/*
 * Copyright (C) 2019 Chupligin Sergey <neochapay@gmail.com>
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

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.ofono 1.0

import MeeGo.QOfono 0.2

import "../../components"

Page {
    id: usbPage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("Mobile networks")
    }

    OfonoExtSimListModel {
        id: simModel
    }

    OfonoModemListModel{
        id: modemModel
    }

    ListView{
        id: languageList
        width: parent.width
        height: parent.height

        model:  modemModel//simModel

        clip: true

        delegate: ListViewItemWithActions{
            id: mFromList
            label: path//serviceProviderName
            description: model.enabled ? "Enabled" : "Disabled"
            iconVisible: false
            showNext: model.enabled

            actions:[
                ActionButton {
                    iconSource: "image://theme/power-off"
                    onClicked: {
                        if(model.enabled) {
                            model.enabled = false
                        } else {
                            model.enabled = true
                        }
                    }
                }
            ]
        }
    }
}

