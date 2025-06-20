/*
 * Copyright (C) 2019-2022 Chupligin Sergey <neochapay@gmail.com>
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
import Nemo
import Nemo.Controls

import Nemo.Dialogs 1.0


import org.nemomobile.systemsettings 1.0
import org.nemomobile.devicelock 1.0

import Glacier.Controls.Settings 1.0

Page {
    id: deviceLockPadPage

    property AuthenticationInput authenticationInput
    property SecurityCodeSettings securityCodeSettings
    property bool changeCode: false
    property bool confirmed: false

    headerTools: HeaderToolsLayout {
        id: toolsLayout
        showBackButton: true;
        title: qsTr("Enter security code")
    }

    Component.onCompleted: {
        authenticationInput.authorize()
    }

    SettingsColumn {
        anchors.fill: parent

        TextField {
            id: lockCodeField

            width: parent.width

            readOnly: true
            echoMode: TextInput.PasswordEchoOnEdit
            font.pixelSize: Theme.fontSizeMedium
            maximumLength: authenticationInput.maximumCodeLength
        }

        Grid {
            id: codePad
            height: parent.height
            spacing: Theme.itemSpacingMedium

            columns: 3
            Repeater {
                model: ["1","2","3","4","5","6","7","8","9","<","0","OK"]
                delegate:
                    Rectangle {
                    id:button
                    width: deviceLockPadPage.width/3 > deviceLockPadPage.height/4 ? (deviceLockPadPage.height/4 - 2*Theme.itemSpacingMedium) : (deviceLockPadPage.width/3 - 2*Theme.itemSpacingMedium)
                    height: width

                    color: buttonMouse.pressed ? Theme.accentColor : "transparent"
                    radius: Theme.itemSpacingMedium

                    Text {
                        id: numLabel
                        text: modelData
                        font.pixelSize: Theme.fontSizeLarge
                        anchors.centerIn: parent
                        color: if(modelData == "OK" && ( lockCodeField.length < authenticationInput.minimumCodeLength
                                                        || lockCodeField.length > authenticationInput.maximumCodeLength)) {
                                   return Theme.fillDarkColor
                               } else {
                                   return Theme.textColor
                               }

                    }

                    MouseArea{
                        id: buttonMouse
                        anchors.fill: parent

                        onClicked: {
                            if (numLabel.text !== "<" && numLabel.text !== "OK") {
                                lockCodeField.insert(lockCodeField.cursorPosition, numLabel.text)
                            } else {
                                if (numLabel.text === "OK" && numLabel.color != Theme.fillDarkColor) {
                                    if(!deviceLockPadPage.confirmed) {
                                        authenticationInput.enterSecurityCode(lockCodeField.text)
                                    } else {
                                        securityCodeSettings.change(lockCodeField.text)
                                    }

                                } else if (numLabel.text === "<"){
                                    lockCodeField.text = lockCodeField.text.slice(0, -1)
                                }
                            }
                        }

                        onPressAndHold: {
                            if (numLabel.text === "<"){
                                lockCodeField.text = ""
                            }
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: authenticationInput
        function onFeedback(feedback, data) { displayFeedback(feedback, data) }
        function onError(error) { displayError(error) }
        function onAuthenticationEnded(confirmed) {
            if(confirmed) {
                deviceLockPadPage.confirmed = confirmed
                if(changeCode) {
                    lockCodeField.text = "";
                    toolsLayout.title = qsTr("Enter new security code")
                } else {
                    main.pageStack.pop()
                }
            }
        }
    }

    Connections {
        target: securityCodeSettings
        function onChangingChanged() {
            main.pageStack.pop();
        }
    }

    Dialog{
        id: simpleDialog
        inline: false
        acceptText: qsTr("Ok")

        icon: "image://theme/exclamation-triangle"

        onAccepted: {
            simpleDialog.close();
        }
    }


    function displayFeedback(feedback, data) {
        switch(feedback) {

        case AuthenticationInput.EnterSecurityCode:
            toolsLayout.title = qsTr("Enter current security code")
            lockCodeField.text = "";
            break

        case AuthenticationInput.EnterNewSecurityCode:
            toolsLayout.title = qsTr("Enter new security code")
            lockCodeField.text = "";
            break

        case AuthenticationInput.RepeatNewSecurityCode:
            toolsLayout.title = qsTr("Repeat new security code")
            lockCodeField.text = "";
            break

        case AuthenticationInput.SecurityCodesDoNotMatch:
            simpleDialog.headingText = qsTr("Error")
            simpleDialog.subLabelText = qsTr("Security codes don't match")
            simpleDialog.open();
            break

        case AuthenticationInput.SecurityCodeInHistory:
            simpleDialog.headingText = qsTr("Error")
            simpleDialog.subLabelText = qsTr("Don't use previous security code")
            simpleDialog.open();
            break;

        case AuthenticationInput.IncorrectSecurityCode:
            simpleDialog.headingText = qsTr("Incorrect code")
            simpleDialog.subLabelText = (authenticationInput.maximumAttempts !== -1) ? qsTr("%1 of %2 attempts").arg(data.attemptsRemaining).arg(authenticationInput.maximumAttempts) : ""
            simpleDialog.open();

            console.log("Incorrect code")
            if(authenticationInput.maximumAttempts !== -1) {
                console.log("("+(authenticationInput.maximumAttempts-data.attemptsRemaining)+
                            "/"+authenticationInput.maximumAttempts+")")
            }
            lockCodeField.text = "";
            break

        case AuthenticationInput.TemporarilyLocked:
            console.log("Temporarily locked")
            simpleDialog.headingText = qsTr("Error")
            simpleDialog.subLabelText = qsTr("Temporarily locked")
            simpleDialog.open();

        }
    }

    function displayError(error) {
        console.error("displayError "+error)
        simpleDialog.headingText = qsTr("Error")
        simpleDialog.subLabelText = error
        simpleDialog.open();
    }
}
