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
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0
import org.nemomobile.devicelock 1.0


import "../../components"

Page {
    id: listViewPage

    property bool reqestAllowUnsuportedToken: false

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Developer mode")
    }

    DeveloperModeSettings{
        id: devModeSettings
    }

    DeviceLockSettings {
        id: deviceLockSettings
    }

    Authenticator {
        id: authenticator
        onAuthenticated: {
            if(reqestAllowUnsuportedToken) {
                deviceLockSettings.setSideloadingAllowed(authenticationToken,!deviceLockSettings.sideloadingAllowed)
                reqestAllowUnsuportedToken = false;
            }
        }
    }

    Connections{
        target: deviceLockSettings.authorization
        onChallengeIssued:{

            authenticator.authenticate(deviceLockSettings.authorization.challengeCode,
                                       deviceLockSettings.authorization.allowedMethods)
        }
    }

    SettingsColumn{

        Rectangle{
            id: enableDevMode
            width: parent.width
            height: childrenRect.height

            color: "transparent"

            Label{
                id: enableDevModeLabel
                text: qsTr("Enable developer mode");
                anchors{
                    left: parent.left
                }
            }

            CheckBox{
                id: enableDevModeCheck
                checked: devModeSettings.developerModeEnabled
                anchors{
                    right: parent.right
                    verticalCenter: enableDevModeLabel.verticalCenter
                }
                onClicked: devModeSettings.setDeveloperMode(checked)
            }
        }

        Rectangle{
            id: allowUntrustedSoftware
            width: parent.width
            height: childrenRect.height

            color: "transparent"

            Label{
                id:allowUntrustedSoftwareLabel
                text: qsTr("Allow install untrusted software");
                anchors{
                    left: parent.left
                }
            }

            CheckBox{
                id: allowUntrustedSoftwareCheck
                checked: deviceLockSettings.sideloadingAllowed
                anchors{
                    right: parent.right
                    verticalCenter: allowUntrustedSoftwareLabel.verticalCenter
                }
                onClicked: {
                    switch(deviceLockSettings.authorization.status) {
                    case Authorization.NoChallenge:
                        reqestAllowUnsuportedToken = true
                        deviceLockSettings.authorization.requestChallenge()
                        break
                    case Authorization.ChallengeIssued:
                        console.error("ChallengeIssued not suppoted in NEMO now...")
                        break
                    default:
                        console.error("Unsupported auth status")
                    }
                }
            }
        }


        Rectangle{
            id: wlanIpAddress
            width: parent.width
            height: childrenRect.height

            visible: devModeSettings.developerModeEnabled

            color: "transparent"

            Label{
                id: wlanIpAddressLabel
                text: qsTr("Wlan IP address");
                anchors{
                    left: parent.left
                }
            }

            TextField{
                id: wlanIpAddressInput
                text: devModeSettings.wlanIpAddress

                anchors{
                    top: wlanIpAddressLabel.bottom
                    topMargin: size.dp(20)
                    left: parent.left
                }
                readOnly: true
            }
        }

        Rectangle{
            id: usbIpAddress
            width: parent.width
            height: childrenRect.height

            visible: devModeSettings.developerModeEnabled

            color: "transparent"

            Label{
                id: usbIpAddressLabel
                text: qsTr("USB IP address");
                anchors{
                    left: parent.left
                }
            }

            TextField{
                id: usbIpAddressInput
                text: devModeSettings.usbIpAddress

                anchors{
                    top: usbIpAddressLabel.bottom
                    topMargin: size.dp(20)
                    left: parent.left
                }
                validator: RegExpValidator {
                    regExp:  /^((?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){0,3}(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$/

                }

                InverseMouseArea {
                    anchors.fill: parent
                    onPressed: {
                        if(usbIpAddressInput.text !== devModeSettings.usbIpAddress && usbIpAddressInput.accepted)
                        {
                            console.log("Change ip")
                            devModeSettings.setUsbIpAddress(usbIpAddressInput.text)
                        }
                    }
                }
            }
        }
    }
}
