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

import org.nemomobile.systemsettings 1.0

import Glacier.Controls.Settings 1.0

Page {
    id: certificatesPage

    headerTools: HeaderToolsLayout {
        showBackButton: true
        title: qsTr("Certificates")
    }

    CertificateModel {
        id: certificateModel
        bundleType: bundleSelector.currentIndex === 0 ? CertificateModel.TLSBundle
                    : bundleSelector.currentIndex === 1 ? CertificateModel.EmailBundle
                    : CertificateModel.ObjectSigningBundle
    }

    SettingsColumn {
        id: contentColumn
        spacing: Theme.itemSpacingLarge

        GlacierRoller {
            id: bundleSelector
            width: parent.width
            label: qsTr("Certificate bundle")
            currentIndex: 0
            model: [
                qsTr("TLS"),
                qsTr("Email"),
                qsTr("Object signing")
            ]
        }
    }

    ListView {
        id: certificatesList
        anchors {
            top: contentColumn.bottom
            topMargin: Theme.itemSpacingLarge
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
        model: certificateModel

        delegate: ListViewItemWithActions {
            label: model.primaryName
            description: model.secondaryName
            showNext: false
            iconVisible: false
        }

        ScrollDecorator {}
    }

    Label {
        visible: certificatesList.count === 0
        text: qsTr("No certificates found")
        anchors.centerIn: certificatesList
    }
}
