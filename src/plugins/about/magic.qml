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
import Nemo.Controls

import Nemo.Dialogs 1.0

Page {
    id: aboutPage

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: "☺"
    }
    Flickable{
        width: parent.width
        height: parent.height
        contentHeight: magicLogo.x+magicLogo.height+fortyTwo.height+Theme.itemSpacingHuge*2

        Image {
            id: magicLogo
            width: (aboutPage.width > aboutPage.height) ? aboutPage.height*0.8 : aboutPage.width*0.8
            height: width
            source: "/usr/share/glacier-settings/qml/plugins/about/bluecreature.svg"
            anchors{
                top: parent.top
                topMargin: Theme.itemSpacingHuge
                horizontalCenter: parent.horizontalCenter
            }
            sourceSize{
                width: width
                height: height
            }
        }

        Text {
            id: fortyTwo
            width: parent.width*0.8
            text: qsTr("— Forty two! — Lunkkuool screamed. — And all this that you can tell after seven and a half million years of work?
— I very carefully checked everything — told the computer — and with all determinancy I declare that it and is the answer. It seems to me if to be with you absolutely fair, then all the matter is that you did not know in what a question.")
            anchors{
                top: magicLogo.bottom
                topMargin: Theme.itemSpacingHuge*2
                horizontalCenter: parent.horizontalCenter
            }
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.textColor
            wrapMode: Text.WordWrap
        }
    }
}
