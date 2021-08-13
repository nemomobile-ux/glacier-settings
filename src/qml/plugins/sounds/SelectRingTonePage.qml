/*
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

import QtMultimedia 5.15

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.folderlistmodel 1.0

import "../../components"

Page {
    id: selectRingTonePage

    property string selectedFile

    signal newFileSelected(string filename)

    headerTools: HeaderToolsLayout { showBackButton: true; title: qsTr("Select file")}

    FolderListModel {
        id: dirModel
        path: "/usr/share/sounds/glacier/stereo/"
    }

    MediaPlayer {
        id: soundPlayer
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
                newFileSelected(fileName);
            }

            actions:[
                ActionButton {
                    iconSource: soundPlayer.playbackState === MediaPlayer.PlayingState ? "image://theme/pause" : "image://theme/play";
                    onClicked: {
                        if (soundPlayer.playbackState === MediaPlayer.PlayingState) {
                            soundPlayer.stop();
                        } else {
                            soundPlayer.source = "/usr/share/sounds/glacier/stereo/" + fileName
                            soundPlayer.play();
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

}