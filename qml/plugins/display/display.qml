import QtQuick 2.6
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0

import "../../components"

Page {
    id: listViewPage

    headerTools: HeaderToolsLayout { showBackButton: true; title: qsTr("Display settings")}

    DisplaySettings{
        id: displaySettings
    }

    Component.onCompleted: {
        console.log(displaySettings.blankTimeout)
    }


    SettingsColumn{
        id: display

        Label{
            id: brightnessLabel
            text: qsTr("Brightness");
        }

        Slider{
            id: brightnessSlider
            width: parent.width

            minimumValue: 0
            maximumValue: displaySettings.maximumBrightness
            value: displaySettings.brightness
            stepSize: 1
            onValueChanged: {
                displaySettings.brightness = value
            }
            enabled: !displaySettings.autoBrightnessEnabled
        }

        Rectangle{
            id: autoBrightnessSettings
            width: parent.width
            height: childrenRect.height

            color: "transparent"

            Label{
                id: autoBrightnessLabel
                text: qsTr("Auto brightness");
                anchors{
                    left: parent.left
                    top: parent.top
                }
            }

            CheckBox{
                id: autoBrightnessCheck
                checked: displaySettings.autoBrightnessEnabled
                anchors{
                    right: parent.right
                    verticalCenter: autoBrightnessLabel.verticalCenter
                }
                onClicked: displaySettings.autoBrightnessEnabled = checked
            }
        }


        Label{
            id: dimTimeoutLabel
            text: qsTr("Dim timeout");
        }

        Slider{
            id: dimTimeoutSlider
            width: parent.width
            minimumValue: 0
            maximumValue: 60
            value: displaySettings.dimTimeout
            stepSize: 10
            onValueChanged: {
                displaySettings.dimTimeout = value
            }
        }


        Label{
            id: blankTimeoutLabel
            text: qsTr("Blank timeout");
        }

        Slider{
            id: blankTimeoutSlider
            width: parent.width

            minimumValue: 0
            maximumValue: 60
            value: displaySettings.blankTimeout
            stepSize: 10
            onValueChanged: {
                displaySettings.blankTimeout = value
            }
        }
    }
}

