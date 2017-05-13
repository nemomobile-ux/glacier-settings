import QtQuick 2.6
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0


import "../../components"

Page {
    id: listViewPage

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Developer mode")
    }

    DeveloperModeSettings{
        id: devModeSettings
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
            id: remoteLoginEnabled
            width: parent.width
            height: childrenRect.height

            color: "transparent"

            Label{
                id: remoteLoginEnabledLabel
                text: qsTr("Enable remote login");
                anchors{
                    left: parent.left
                }
            }

            CheckBox{
                id: remoteLoginEnabledCheck
                checked: devModeSettings.remoteLoginEnabled
                anchors{
                    right: parent.right
                    verticalCenter: remoteLoginEnabledLabel.verticalCenter
                }
                onClicked: devModeSettings.setRemoteLogin(checked)
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
            }
        }
    }
}
