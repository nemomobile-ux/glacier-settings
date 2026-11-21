/*
 *
 * Copyright (C) 2022-2025 Chupligin Sergey <neochapay@gmail.com>
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
import QtMultimedia
import Qt.labs.folderlistmodel

import Nemo
import Nemo.Controls

import Glacier.Controls.Settings 1.0

Page {
    id: selectRingTonePage

    property string selectedFile
    property var fileSelectedCallback
    headerTools: HeaderToolsLayout { showBackButton: true; title: qsTr("Select file")}

    FolderListModel {
        id: dirModel
        folder: "file:///usr/share/sounds/glacier/stereo"
    }

    ListView {
        id: view
        anchors.fill: parent
        clip: true
        model: dirModel
        delegate: ListViewItemWithActions {
            id: item
            label: fileName
            description: (selectedFile == fileName) ? qsTr("selected") : ""
            showNext: false
//            icon: iconSource
            iconVisible: false

            width: selectRingTonePage.width !== null ? selectRingTonePage.width : 200
            height: Theme.itemHeightLarge

            onClicked: {
                selectedFile = fileUrl
            }

            actions:[
                ActionButton {
                    iconSource: soundPlayer.playbackState === MediaPlayer.PlayingState ? "image://theme/pause" : "image://theme/play";
                    onClicked: {
                        if (soundPlayer.playbackState === MediaPlayer.PlayingState) {
                            soundPlayer.stop();
                        } else {
                            soundPlayer.source = fileUrl
                            Qt.callLater(() => soundPlayer.play())
                            console.log(soundPlayer.source)
                        }
                    }
                }

            ]
        }
    }

    ScrollDecorator{
        id: decorator
        flickable: view
    }

    function selectFile(newFile) {
        if (fileSelectedCallback) {
            selectedFile = newFile
            fileSelectedCallback(newFile)
        }
    }
}
