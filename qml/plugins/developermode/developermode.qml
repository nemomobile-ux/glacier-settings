import QtQuick 2.0
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0

Page {
    id: listViewPage

    headerTools: HeaderToolsLayout {
        showBackButton: true;
        title: qsTr("Developer mode")
    }

    DeveloperModeSettings{
        id: devModeSettings
    }

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
                leftMargin: 20
            }
        }

        CheckBox{
            id: enableDevModeCheck
            checked: devModeSettings.developerModeEnabled
            anchors{
                right: parent.right
                rightMargin: 20
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

        anchors{
            top: enableDevMode.bottom
            topMargin: 20
        }

        Label{
            id: remoteLoginEnabledLabel
            text: qsTr("Enable remote login");
            anchors{
                left: parent.left
                leftMargin: 20
            }
        }

        CheckBox{
            id: remoteLoginEnabledCheck
            checked: devModeSettings.remoteLoginEnabled
            anchors{
                right: parent.right
                rightMargin: 20
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

        anchors{
            top: remoteLoginEnabled.bottom
            topMargin: 20
        }

        Label{
            id: wlanIpAddressLabel
            text: qsTr("Wlan IP address");
            anchors{
                left: parent.left
                leftMargin: 20
            }
        }

        TextField{
            id: wlanIpAddressInput
            text: devModeSettings.wlanIpAddress
            anchors{
                right: parent.right
                rightMargin: 20
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

        anchors{
            top: wlanIpAddress.bottom
            topMargin: 20
        }

        Label{
            id: usbIpAddressLabel
            text: qsTr("USB IP address");
            anchors{
                left: parent.left
                leftMargin: 20
            }
        }

        TextField{
            id: usbIpAddressInput
            text: devModeSettings.usbIpAddress

            anchors{
                right: parent.right
                rightMargin: 20
            }
            validator: RegExpValidator {
                regExp:  /^((?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.){0,3}(?:[0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$/

            }
        }
    }
}
