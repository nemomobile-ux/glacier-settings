import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.glacier.settings 1.0
import org.nemomobile.systemsettings 1.0

import MeeGo.Connman 0.2

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


    Text {
        id: label
        text: qsTr("Quick settings")
        font.capitalization: Font.AllUppercase
        font.pixelSize: 20
        color: "white"
        anchors{
            left: parent.left
            leftMargin: 10
        }
    }

    Rectangle{
        id: line
        height: 1
        color: "white"
        width: parent.width-label.width-30
        anchors{
            left: label.right
            leftMargin: 10
            verticalCenter: label.verticalCenter
        }
    }


    QuickButton{
        id: wifiButton

        icon: "../img/wifi.svg"

        anchors{
            left: parent.left
            leftMargin: 20
            top: label.bottom
            topMargin: 20
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

        icon: "../img/bluetooth.svg"

        anchors{
            left: wifiButton.right
            leftMargin: 20
            top: label.bottom
            topMargin: 20
        }
    }

    QuickButton{
        id: volumeButton

        icon: "../img/volume.svg"

        anchors{
            left: bluetoothButton.right
            leftMargin: 20
            top: label.bottom
            topMargin: 20
        }
    }

    QuickButton{
        id: gpsButton

        icon: "../img/gps.svg"

        anchors{
            left: volumeButton.right
            leftMargin: 20
            top: label.bottom
            topMargin: 20
        }
    }

    QuickButton{
        id: airplaneButton

        icon: "../img/plane.svg"

        anchors{
            left: gpsButton.right
            leftMargin: 20
            top: label.bottom
            topMargin: 20
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
            leftMargin: 20
            top: wifiButton.bottom
            topMargin: 20
        }
    }

    Slider{
        id: brightnessSlider
        width: parent.width-40
        anchors{
            left: parent.left
            leftMargin: 20
            top: brightnessLabel.bottom
            topMargin: 20
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
