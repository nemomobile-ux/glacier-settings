import QtQuick 2.6
import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.glacier.settings 1.0
import org.nemomobile.systemsettings 1.0

import MeeGo.Connman 0.2
import org.kde.bluezqt 1.0 as BluezQt

Rectangle {
    id: quickSettings
    color: "transparent"

    width: parent.width
    height: childrenRect.height


    TechnologyModel {
        id: wifiNetworkingModel
        name: "wifi"

        onTechnologiesChanged: {
            wifiButton.activated = wifiNetworkingModel.powered
        }

        onPoweredChanged: {
            wifiButton.activated = wifiNetworkingModel.powered
        }
    }

    property QtObject _adapter: _bluetoothManager && _bluetoothManager.usableAdapter
    property QtObject _bluetoothManager: BluezQt.Manager

    TechnologyModel {
        id: bluetoothModel
        name: "bluetooth"

        onTechnologiesChanged: {
            bluetoothButton.activated = bluetoothModel.powered
        }

        onPoweredChanged: {
            bluetoothButton.activated = bluetoothModel.powered
        }
    }

    TechnologyModel {
        id: gpsModel
        name: "gps"

        onTechnologiesChanged: {
            gpsButton.activated = gpsModel.powered
        }

        onPoweredChanged: {
            gpsButton.activated = gpsModel.powered
        }
    }

    LocationSettings {
        id: locationSettings
    }

    NetworkManagerFactory {
        id: connMgr
    }

    Text {
        id: label
        text: qsTr("Quick settings")
        font.capitalization: Font.AllUppercase
        font.pixelSize: size.dp(20)
        color: "white"
        anchors{
            left: parent.left
            leftMargin: size.dp(10)
        }
    }

    Rectangle{
        id: line
        height: 1
        color: "white"
        width: parent.width-label.width-size.dp(30)
        anchors{
            left: label.right
            leftMargin: size.dp(10)
            verticalCenter: label.verticalCenter
        }
    }


    QuickButton{
        id: wifiButton

        icon: "../img/wifi.svg"

        anchors{
            left: parent.left
            leftMargin: size.dp(20)
            top: label.bottom
            topMargin: size.dp(20)
        }

        activated: wifiNetworkingModel.powered
        visible: wifiNetworkingModel.available

        onClicked: {
            if(wifiButton.activated)
            {
                wifiNetworkingModel.powered = false;
            }
            else
            {
                wifiNetworkingModel.powered = true;
            }
        }
    }

    QuickButton{
        id: bluetoothButton
        activated: bluetoothModel.powered && _adapter && _adapter.powered

        icon: "../img/bluetooth.svg"

        anchors{
            left: wifiButton.right
            leftMargin: size.dp(20)
            top: label.bottom
            topMargin: size.dp(20)
        }

        onClicked: {
            if (bluetoothButton.activated)
            {
                bluetoothModel.powered = false;
            }
            else
            {
                bluetoothModel.powered = true;
            }
        }
    }

    QuickButton{
        id: volumeButton

        icon: "../img/volume.svg"

        anchors{
            left: bluetoothButton.right
            leftMargin: size.dp(20)
            top: label.bottom
            topMargin: size.dp(20)
        }
    }

    QuickButton{
        id: gpsButton

        icon: "../img/gps.svg"

        anchors{
            left: volumeButton.right
            leftMargin: size.dp(20)
            top: label.bottom
            topMargin: size.dp(20)
        }
        onClicked: {
            if(gpsButton.activated)
            {
                locationSettings.locationEnabled = false
                gpsModel.powered = false;
            }
            else
            {
                locationSettings.locationEnabled = true
                gpsModel.powered = true;
            }
        }
    }

    QuickButton{
        id: airplaneButton

        icon: "../img/plane.svg"

        anchors{
            left: gpsButton.right
            leftMargin: size.dp(20)
            top: label.bottom
            topMargin: size.dp(20)
        }

        onClicked: {
            if (airplaneButton.activated)
            {
                connMgr.instance.offlineMode = false;
            }
            else
            {
                connMgr.instance.offlineMode = true;
            }
        }
    }

    DisplaySettings{
        id: displaySettings
    }

    Label{
        id: brightnessLabel
        text: qsTr("Brightness");
        anchors{
            left: parent.left
            leftMargin: size.dp(20)
            top: wifiButton.bottom
            topMargin: size.dp(20)
        }
    }

    Slider{
        id: brightnessSlider
        width: parent.width-size.dp(40)
        anchors{
            left: parent.left
            leftMargin: size.dp(20)
            top: brightnessLabel.bottom
            topMargin: size.dp(20)
        }
        minimumValue: 0
        maximumValue: displaySettings.maximumBrightness
        value: displaySettings.brightness
        stepSize: 1
        onValueChanged: {
            displaySettings.brightness = value
        }
        enabled: !displaySettings.autoBrightnessEnabled
    }
}
