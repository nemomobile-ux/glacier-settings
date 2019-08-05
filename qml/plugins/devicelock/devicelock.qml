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
import org.nemomobile.devicelock 1.0

import "../../components"

Page {
    id: deviceLockPage

    property var token: undefined

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Device lock")
    }

    DeviceLockSettings{
        id: lockSettings
    }

    SecurityCodeSettings{
        id: secCodeSettings
    }

    ListModel{
        id: autoLockModel
        ListElement{
            name: qsTr("Newer")
            time: -1
        }
        ListElement{
            name: qsTr("Without deay")
            time: 0
        }
        ListElement{
            name: qsTr("1 min")
            time: 1
        }
        ListElement{
            name: qsTr("5 min")
            time: 5
        }
        ListElement{
            name: qsTr("10 min")
            time: 10
        }
        ListElement{
            name: qsTr("15 min")
            time: 15
        }
        ListElement{
            name: qsTr("30 min")
            time: 30
        }
        ListElement{
            name: qsTr("1 hour")
            time: 60
        }
    }

    SettingsColumn{
        id: lockColumn

        Rectangle{
            id: useLockArea
            width: parent.width
            height: childrenRect.height
            color: "transparent"

            Label{
                id: useLockLabel
                text: qsTr("Enable device lock")
                anchors{
                    left: parent.left
                }
                wrapMode: Text.Wrap
            }

            CheckBox {
                id: useLockCheckBox
                checked: false //fix it!
                anchors{
                    right: parent.right
                    verticalCenter: useLockLabel.verticalCenter
                }
                onClicked:{
                }
            }
        }

        Rectangle{
            id: showNotifyArea
            width: parent.width
            height: childrenRect.height
            color: "transparent"

            Label{
                id: showNotifyLabel
                text: qsTr("Show notify when device locked")
                anchors{
                    left: parent.left
                }
                width: parent.width-showNotifyCheckBox.width
                wrapMode: Text.Wrap
            }

            CheckBox {
                id: showNotifyCheckBox
                checked: lockSettings.showNotifications
                anchors{
                    right: parent.right
                    verticalCenter: showNotifyLabel.verticalCenter
                }
                onClicked:{
                    lockSettings.showNotifications = showNotifyCheckBox.checked
                }
            }
        }

        GlacierRoller {
            id: autoLockRoller
            width: parent.width

            clip: true
            model: autoLockModel
            label:  qsTr("Auto lock device")

            delegate: GlacierRollerItem{
                Text{
                    height: autoLockRoller.itemHeight
                    verticalAlignment: Text.AlignVCenter
                    text: name
                    color: Theme.textColor
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: (autoLockRoller.activated && autoLockRoller.currentIndex === index)
                }

                Component.onCompleted: {
                    if(time == lockSettings.automaticLocking) {
                        autoLockRoller.currentIndex = index
                    }
                }
            }

            onCurrentIndexChanged: {
                var changedTime = autoLockModel.get(autoLockRoller.currentIndex).time
                if(changedTime != lockSettings.automaticLocking) {
                    lockSettings.setAutomaticLocking(token,changedTime)
                }
            }
        }
    }
}
