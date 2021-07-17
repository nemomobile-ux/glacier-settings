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
    id: deviceLockPadPage

    property AuthenticationInput authenticationInput

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Enter code")
    }

    SettingsColumn {
        anchors.fill: parent

        TextField {
            id: lockCodeField

            width: parent.width

            readOnly: true
            echoMode: TextInput.PasswordEchoOnEdit
            font.pixelSize: Theme.fontSizeMedium
        }

        Grid {
            id: codePad
            height: parent.height

            columns: 3
            Repeater {
                model: ["1","2","3","4","5","6","7","8","9","<","0","OK"]
                delegate:
                    Rectangle {
                    id:button
                    width: root.width/3 > root.height/4 ? root.height/4 : root.width/3
                    height: width

                    color: "transparent"

                    Text {
                        id: numLabel
                        text: modelData
                        font.pixelSize: Theme.fontSizeLarge
                        anchors.centerIn: parent
                        color: "white"
                    }

                    MouseArea{
                        anchors.fill: parent

                        onClicked: {
                            if (numLabel.text !== "<" && numLabel.text !== "OK") {
                                lockCodeField.insert(lockCodeField.cursorPosition, numLabel.text)
                            } else {
                                if (numLabel.text === "OK") {
                                    authenticationInput.enterSecurityCode(lockCodeField.text)

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

        onFeedback: displayFeedback(feedback, data)
        onError: displayError(error)
    }

    function displayFeedback(feedback, data) {

        switch(feedback) {

        case AuthenticationInput.EnterSecurityCode:
            console.log("Enter security code")
            break

        case AuthenticationInput.IncorrectSecurityCode:
            console.log("Incorrect code")
            if(authenticationInput.maximumAttempts !== -1) {
                console.log("("+(authenticationInput.maximumAttempts-data.attemptsRemaining)+
                                                   "/"+authenticationInput.maximumAttempts+")")
            }
            break

        case AuthenticationInput.TemporarilyLocked:
            console.log("Temporarily locked")
        }
    }

    function displayError(error) {
        console.log("displayError "+error)
    }
}
