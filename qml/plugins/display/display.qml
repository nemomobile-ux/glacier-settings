import QtQuick 2.0
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0

Page {
    id: listViewPage

    headerTools: HeaderToolsLayout { showBackButton: true; title: qsTr("Display settings")}

    DisplaySettings{
        id: displaySettings
    }

    Component.onCompleted: {
        console.log(displaySettings.blankTimeout)
    }

    Rectangle{
        id: brightnessSettings
        width: parent.width
        height: childrenRect.height

        color: "transparent"

        Label{
            id: brightnessLabel
            text: qsTr("Brightness");
            anchors{
                left: parent.left
                leftMargin: 20
                top: parent.top
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

    Rectangle{
        id: autoBrightnessSettings
        width: parent.width
        height: childrenRect.height

        color: "transparent"

        anchors{
            top: brightnessSettings.bottom
            topMargin: 20
        }

        Label{
            id: autoBrightnessLabel
            text: qsTr("Auto brightness");
            anchors{
                left: parent.left
                leftMargin: 20
                top: parent.top
                topMargin: 20
            }
        }

        CheckBox{
            id: autoBrightnessCheck
            checked: displaySettings.autoBrightnessEnabled
            anchors{
                right: parent.right
                rightMargin: 20
                verticalCenter: autoBrightnessLabel.verticalCenter
            }
            onClicked: displaySettings.autoBrightnessEnabled = checked
        }
    }

    Rectangle{
        id: dimTimeoutSettings
        width: parent.width
        height: childrenRect.height

        color: "transparent"

        anchors{
            top: autoBrightnessSettings.bottom
            topMargin: 20
        }

        Label{
            id: dimTimeoutLabel
            text: qsTr("Dim timeout");
            anchors{
                left: parent.left
                leftMargin: 20
                top: parent.top
                topMargin: 20
            }
        }

        Slider{
            id: dimTimeoutSlider
            width: parent.width-40
            anchors{
                left: parent.left
                leftMargin: 20
                top: dimTimeoutLabel.bottom
                topMargin: 20
            }
            minimumValue: 0
            maximumValue: 60
            value: displaySettings.dimTimeout
            stepSize: 10
            onValueChanged: {
                displaySettings.dimTimeout = value
            }
        }
    }

    Rectangle{
        id: blankTimeoutSettings
        width: parent.width
        height: childrenRect.height

        color: "transparent"

        anchors{
            top: dimTimeoutSettings.bottom
            topMargin: 20
        }

        Label{
            id: blankTimeoutLabel
            text: qsTr("Blank timeout");
            anchors{
                left: parent.left
                leftMargin: 20
                top: parent.top
                topMargin: 20
            }
        }

        Slider{
            id: blankTimeoutSlider
            width: parent.width-40
            anchors{
                left: parent.left
                leftMargin: 20
                top: blankTimeoutLabel.bottom
                topMargin: 20
            }
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
