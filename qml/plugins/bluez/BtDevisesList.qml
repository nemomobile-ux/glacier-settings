/*
 * Copyright (C) 2020 Chupligin Sergey <neochapay@gmail.com>
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

ListView {
    id: btDeviceList
    width: parent.width
    height: childrenRect.height

    clip: true

    delegate: ListViewItemWithActions {
        id: item
        label: model.FriendlyName
        description: model.Address
        width: parent.width
        height: Theme.itemHeightLarge
        showNext: false
        icon: formatIcon(model.Type)

        onClicked: {
            if(model.Paired) {
                btInterface.call("connectDevice", [Address])
            }
        }

        actions:[
            ActionButton {
                iconSource: model.Paired ? "image://theme/chain-broken" : "image://theme/link"
                onClicked: {
                    var device = _bluetoothManager.deviceForAddress(model.Address)
                    if(!device) {
                        return
                    }

                    if(model.Paired) {
                        //disconect
                        console.log("UNPAIR!!!")
                        btInterface.call("unPair", [Address])
                    } else {
                        //connect
                        console.log("PAIR!!!")
                        btInterface.call("pair", [Address])
                    }
                }
            }
        ]
    }
}
