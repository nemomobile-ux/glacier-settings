/*
 * Copyright (C) 2022 Chupligin Sergey <neochapay@gmail.com>
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

Item {
    id: rightCheckBox

    property alias label: rightCheckBoxLabel.text
    property alias checked: rightCheckBoxCheckBox.checked
    property alias indeterminate: rightCheckBoxCheckBox.indeterminate

    signal clicked();

    width: parent.width
    height: visible ? Theme.itemHeightLarge : 0

    Label {
        id: rightCheckBoxLabel
        width: parent.width - rightCheckBoxCheckBox.width
        anchors {
            left: parent.left
            leftMargin: Theme.itemHeightLarge/2
            right: rightCheckBoxCheckBox.left
            verticalCenter: parent.verticalCenter
        }
        wrapMode: Text.Wrap

        MouseArea {
            anchors.fill: parent;
            onClicked: {
                rightCheckBoxCheckBox.checked = !rightCheckBoxCheckBox.checked
                rightCheckBox.clicked();
            }
        }
    }

    CheckBox {
        id: rightCheckBoxCheckBox
        anchors {
            right: rightCheckBox.right
            rightMargin: Theme.itemHeightMedium/2
            verticalCenter: rightCheckBoxLabel.verticalCenter
        }

        onClicked: {
            rightCheckBox.clicked();
        }
    }
}
