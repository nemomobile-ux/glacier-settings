/*
 * Copyright (C) 2021 Chupligin Sergey <neochapay@gmail.com>
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

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0

import "../../components"

Page {
    id: storagePage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("Storage")
    }

    PartitionModel{
        id: partionModel
    }

    ListView{
        id: languageList
        width: parent.width - Theme.itemSpacingLarge*2
        height: parent.height - Theme.itemSpacingLarge*2

        anchors{
            top: parent.top
            topMargin: Theme.itemSpacingLarge
            left: parent.left
            leftMargin: Theme.itemSpacingLarge
        }

        spacing: Theme.itemSpacingLarge

        model: partionModel
        delegate: Rectangle{
            width: parent.width
            height: Theme.itemHeightLarge
            color: Theme.fillColor

            Rectangle{
                id: used
                height: parent.height
                color: Theme.accentColor
                width: parent.width*bytesFree/bytesTotal
            }

            Label{
                text: mountPath + " (" + formatDiskSize(bytesFree) + " / " + formatDiskSize(bytesTotal) + ")"
                anchors.centerIn: parent
            }
        }
    }


    function formatDiskSize(num) {
        return parseFloat(num/1073741824).toFixed(2) + "GB";
    }
}
