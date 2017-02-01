import QtQuick 2.0
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.systemsettings 1.0

ApplicationWindow{
    id: main
    initialPage: Page{
        id: mainPage
        headerTools: HeaderToolsLayout {
            id: tools
            title: qsTr("Settings")
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
        }

        ListView {
            id: view
            width: parent.width
            height: parent.height-brightnessSlider.height-brightnessLabel.height

            anchors{
                top: brightnessSlider.bottom
                topMargin: 20
            }

            clip: true
            model: settingsModel
            delegate: ListViewItemWithActions {
                label: title
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("plugins/"+path+"/"+path+".qml"))
                }
            }
            section.property: "category"
        }
    }
}
