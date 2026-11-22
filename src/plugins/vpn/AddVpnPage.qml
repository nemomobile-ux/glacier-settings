/*
 * Copyright (C) 2026 Chupligin Sergey <neochapay@gmail.com>
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

import QtQuick

import Nemo
import Nemo.Controls
import Nemo.Dialogs

import Connman 0.2

import Glacier.Controls.Settings 1.0
import org.nemomobile.glacier.settings.vpn 1.0

Page {
    id: addVpnPage

    readonly property var vpnManager: VpnModel.vpnManager

    headerTools: HeaderToolsLayout {
        showBackButton: true
        title: qsTr("Add VPN")
    }

    VpnFileHelper {
        id: vpnFileHelper
    }

    SettingsColumn {
        id: contentColumn
        spacing: Theme.itemSpacingLarge

        ListViewItemWithActions {
            width: parent.width
            label: qsTr("Create manually")
            description: qsTr("Enter VPN settings by hand")
            iconVisible: false
            showNext: true
            onClicked: {
                main.pageStack.push(Qt.resolvedUrl("VpnEditor.qml"), { connectionPath: "" })
            }
        }

        ListViewItemWithActions {
            width: parent.width
            label: qsTr("Import from file")
            description: qsTr("Import OpenVPN configuration file")
            iconVisible: false
            showNext: true
            onClicked: {
                importDialog.open()
            }
        }
    }

    CustomDialog {
        id: importDialog
        headingText: qsTr("Import VPN")
        subLabelText: qsTr("Enter path to OpenVPN configuration file")
        acceptText: qsTr("Import")
        cancelText: qsTr("Cancel")
        inline: true

        content: [
            TextField {
                id: importPathField
                width: importDialog.width - Theme.itemSpacingLarge * 2
                placeholderText: qsTr("/path/to/config.ovpn")
            }
        ]

        onAccepted: {
            var path = importPathField.text.trim()
            if (path === "") {
                return
            }
            var props = vpnFileHelper.importOpenVpn(path)
            if (props && props["Host"]) {
                if (vpnManager) {
                    vpnManager.createConnection(props)
                }
                importError.visible = false
                main.pageStack.pop()
            } else {
                importError.text = vpnFileHelper.errorString() !== "" ? vpnFileHelper.errorString() : qsTr("Failed to import VPN configuration")
                importError.visible = true
            }
        }
    }

    Label {
        id: importError
        visible: false
        text: qsTr("Failed to import VPN configuration")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.itemSpacingLarge
        color: Theme.errorColor
        wrapMode: Text.WordWrap
        width: parent.width - Theme.itemSpacingLarge * 2
        horizontalAlignment: Text.AlignHCenter
    }
}
