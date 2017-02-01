import QtQuick 2.0
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

ApplicationWindow{
    id: main
    initialPage: Page{
        id: mainPage
        headerTools: HeaderToolsLayout {
            id: tools
            title: qsTr("Settings")
        }

        ListView {
            id: view
            anchors.fill: parent
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
