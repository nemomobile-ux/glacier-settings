import QtQuick 2.6
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2

import "../../components"

Page {
    id: savedPage
    headerTools: HeaderToolsLayout{
        id: header
        showBackButton: true
        title: qsTr("Manage saved networks")
    }

    SavedServiceModel{
        id: savedModel
    }

    Component.onCompleted: {
        savedModel.name = "wifi";
    }

    ListView{
        y: header.height
        width: parent.width
        height: parent.height - header.height
        model: savedModel
        delegate: ListViewItemWithActions{
            height: size.dp(80)
            label: networkService.name
            width: savedPage.width

            onClicked: {
                pageStack.push(Qt.resolvedUrl("SavedStatus.qml"), {modelData: networkService});
            }
        }
    }
}
