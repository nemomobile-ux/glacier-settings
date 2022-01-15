/*
 * Copyright (C) 2017 Chupligin Sergey <neochapay@gmail.com>
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

import Nemo.Dialogs 1.0

import org.nemomobile.systemsettings 1.0

import "../../components"

Page {
    id: languagePage

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Language")
    }

    LanguageModel{
        id: languageModel
    }

    ListView{
        id: languageList
        width: parent.width
        height: parent.height

        model: languageModel
        delegate: Rectangle{
            width: parent.width
            height: Theme.itemHeightLarge

            color: (index === languageModel.currentIndex) ? Theme.accentColor : "transparent"
            Label {
                color: Theme.textColor
                text: name
                anchors{
                    left: parent.left
                    leftMargin: Theme.itemSpacingSmall
                    verticalCenter: parent.verticalCenter
                }

                font.pixelSize: Theme.fontSizeMedium
                clip: true
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if(index !== languageModel.currentIndex)
                    {
                        languageDialog.locale = locale
                        languageDialog.visible = true;
                    }
                }
            }
        }
    }

    QueryDialog {
        id: languageDialog

        visible: false
        inline: false

        property string locale: ""

        cancelText: qsTr("Cancel")
        acceptText: qsTr("Accept")
        headingText: qsTr("Change language?")
        subLabelText: qsTr("Do you want to change locale and reboot?")

        onAccepted: {
            languageModel.setSystemLocale(locale,LanguageModel.UpdateAndReboot)
        }

        onCanceled: {
            locale = ""
        }

        onSelected: {
            visible = false
        }
    }
}
