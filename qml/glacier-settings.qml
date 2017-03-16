import QtQuick 2.0
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.glacier.settings 1.0
import org.nemomobile.systemsettings 1.0

import "components"

ApplicationWindow{
    id: main

    SettingsProxyModel{
        id: settingsModel
        model: SettingsModel{
            path: "/usr/share/glacier-settings/plugins/"
        }
    }

    initialPage: Page{
        id: mainPage
        headerTools: HeaderToolsLayout {
            id: tools
            title: qsTr("Settings")
        }

        QuickSettings{
            id: quickSettings
            anchors{
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
                top: quickSettings.bottom
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

        ListView {
            id: view
            width: parent.width
            height: parent.height-quickSettings.height

            anchors{
                top: brightnessSlider.bottom
                topMargin: 20
            }

            clip: true
            model: settingsModel
            delegate: ListViewItemWithActions {
                label: title
                icon: "/usr/share/glacier-settings/qml/plugins/"+path+"/"+path+".svg"
                onClicked:{
                    pageStack.push(Qt.resolvedUrl("plugins/"+path+"/"+path+".qml"))
                }
            }
            section.property: "category"
        }
    }
}
