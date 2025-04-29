/*
 * Copyright (C) 2020-2025 Chupligin Sergey <neochapay@gmail.com>
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

ListView {
    id: btDeviceList
    width: parent.width
    height: contentHeight

    clip: true

    delegate: ListViewItemWithActions {
        id: item
        label: model.FriendlyName
        description: model.Address
        width: btDeviceList.width
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
            return "image://theme/desktop"
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
