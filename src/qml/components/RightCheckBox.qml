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
import QtQuick.Window 2.1
import QtPositioning 5.2

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

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
        width: parent.width
        anchors {
            left: rightCheckBox.left
            right: rightCheckBoxCheckBox.left
            verticalCenter: parent.verticalCenter
        }
        wrapMode: Text.Wrap
        font.bold: true
    }


    CheckBox {
        id: rightCheckBoxCheckBox
        anchors {
            right: rightCheckBox.right
            verticalCenter: rightCheckBoxLabel.verticalCenter
        }

        onClicked: {
            rightCheckBox.clicked();
        }
    }
}
