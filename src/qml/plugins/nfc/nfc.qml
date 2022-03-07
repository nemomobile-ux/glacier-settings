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

import org.nemomobile.systemsettings 1.0

import "../../components"

Page {
    id: nfcPage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("NFC")
    }

    NfcSettings{
        id: nfcSettings
    }

    Label{
        id: noNfcLabel
        visible: !nfcSettings.available
        text: qsTr("NFC unavailable")
        anchors.centerIn: parent
    }

    SettingsColumn{
        id: nfcColumn
        spacing: Theme.itemSpacingLarge
        visible: nfcSettings.available


        RightCheckBox {
            id: nfcCheckBox
            checked: nfcSettings.enabled
            label: qsTr("Enable NFC")
            anchors {
                right: nfcEnable.right
                verticalCenter: nameLabel.verticalCenter
            }

            onClicked: {
                nfcSettings.enabled = nfcCheckBox.checked
            }
        }
    }
}

