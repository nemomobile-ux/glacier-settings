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

    property string token;
    property bool requestCodeChange: false

    property int changeAutomaticLockingTo: -2

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Device lock")
    }

    Authenticator{
        id: authenticator

        onAuthenticated: {
            deviceLockPage.token = authenticationToken

            if(deviceLockPage.changeAutomaticLockingTo > -2) {
                lockSettings.setAutomaticLocking(deviceLockPage.token, changeAutomaticLockingTo)
                deviceLockPage.changeAutomaticLockingTo = -2
            }
        }
    }

    DeviceLockSettings{
        id: lockSettings

        authorization {
            onChallengeExpired: {
                deviceLockSettings.authorization.requestChallenge()
            }
        }

        onAutomaticLockingChanged: {
            for(var i = 0; i < autoLockModel.count; i++ ) {
                if(autoLockModel.get(i).time === lockSettings.automaticLocking) {
                    autoLockRoller.currentIndex = i
                }
            }
        }
    }

    Component.onCompleted: {
        lockSettings.authorization.requestChallenge()
    }

    SecurityCodeSettings{
        id: secCodeSettings

        onChanged: {
            deviceLockPage.token = authenticationToken
        }
    }

    AuthenticationInput{
        id: authInput

        active: true
        registered: true

        onAuthenticationStarted: {
            authInput.feedback(feedback, data)
            pageStack.push(Qt.resolvedUrl("DeviceLockPad.qml"), {authenticationInput: authInput,
                               securityCodeSettings: secCodeSettings,
                               changeCode: requestCodeChange})
        }

        onAuthenticationUnavailable: {
            authInput.error(error, data)
        }
    }

    ListModel{
        id: autoLockModel
        ListElement{
            name: qsTr("Never")
            time: -1
        }
        ListElement{
            name: qsTr("Without delay")
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

    Label{
        id: noAuthLabel
        text: qsTr("Lock is not available")
        anchors.centerIn: parent
        visible: authenticator.availableMethods == Authenticator.NoAuthentication
    }

    SettingsColumn{
        id: lockColumn
        spacing: Theme.itemSpacingLarge
        visible: authenticator.availableMethods != Authenticator.NoAuthentication

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
            }

            onCurrentIndexChanged: {
                var changedTime = autoLockModel.get(autoLockRoller.currentIndex).time
                if(changedTime != lockSettings.automaticLocking) {
                    if(deviceLockPage.token.length > 0) {
                        lockSettings.setAutomaticLocking(token,changedTime)
                    } else {
                        deviceLockPage.changeAutomaticLockingTo = changedTime
                        doAuth();
                    }
                }
            }

            Component.onCompleted: {
                for(var i = 0; i < autoLockModel.count; i++ ) {
                    if(autoLockModel.get(i).time === lockSettings.automaticLocking) {
                        autoLockRoller.currentIndex = i
                    }
                }
            }
        }

        CheckBox {
            id: showNotifyCheckBox
            text: qsTr("Show notifications when device locked")
            checked: lockSettings.showNotifications
            onClicked:{
                lockSettings.showNotifications = showNotifyCheckBox.checked
            }
        }

        Button{
            id: changeCode
            text: qsTr("Change security code")
            width: parent.width

            onClicked: {
                deviceLockPage.requestCodeChange = true
                doAuth();
            }
        }
    }

    function doAuth() {
        authenticator.authenticate(lockSettings.authorization.challengeCode, lockSettings.authorization.allowedMethods)
    }
}
