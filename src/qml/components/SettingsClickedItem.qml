/*
 * Copyright (C) 2018-2021 Chupligin Sergey <neochapay@gmail.com>
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

Item{
    id: settingsClickedItem
    height: visible ? Theme.itemHeightLarge : 0
    width: parent.width

    property alias description: descriptionItem.text
    property alias subDescription: subDescriptionItem.text

    signal clicked

    Label {
        id: descriptionItem
        color: Theme.textColor
        anchors{
            left: parent.left
            right: parent.right
        }
        font.pixelSize: Theme.fontSizeMedium
        clip: true
    }

    Label {
        id: subDescriptionItem
        color: Theme.textColor
        anchors{
            left: parent.left
            right: parent.right
            top: descriptionItem.bottom
        }
        font.pixelSize: Theme.fontSizeTiny
        clip: true
    }

    NemoIcon {
        id: arrowItem
        height: parent.height- Theme.itemSpacingSmall
        width: height

        anchors{
            right: parent.right
            rightMargin: Theme.itemSpacingLarge
            verticalCenter: parent.verticalCenter
        }

        sourceSize.width: width
        sourceSize.height: height

        source: "/usr/lib/qt/qml/QtQuick/Controls/Nemo/images/listview-icon-arrow.svg"
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            settingsClickedItem.clicked()
        }
    }
}
