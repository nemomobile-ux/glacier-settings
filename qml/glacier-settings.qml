import QtQuick 2.6
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
        Flickable{
            id: mainArea
            height: parent.height-tools.height
            width: parent.width

            contentHeight: quickSettings.height+view.height

            QuickSettings{
                id: quickSettings
                anchors{
                    top: parent.top
                    topMargin: size.dp(20)
                }
            }

            ListView {
                id: view
                width: parent.width
                height: view.contentHeight

                anchors{
                    top: quickSettings.bottom
                    topMargin: size.dp(20)
                }

                clip: true
                model: settingsModel
                delegate: ListViewItemWithActions {
                    label: title
                    icon: "/usr/share/glacier-settings/qml/plugins/"+path+"/"+path+".svg"
                    onClicked:{
                        console.log(Qt.createComponent(Qt.resolvedUrl("plugins/"+path+"/"+path+".qml")).errorString())
                        pageStack.push(Qt.resolvedUrl("plugins/"+path+"/"+path+".qml"))
                    }
                }
                section.property: "category"
            }
        }
    }
}
