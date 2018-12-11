import QtQuick 2.6
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2

import "../../components"

Item {
    width: childrenRect.width
    height: childrenRect.height

    property bool saved

    ListViewItemWithActions{
        // use set height and visible properties to
        // skip drawing of some items
        height: {
            if (visible)
                return size.dp(80)
            else
                return 0
        }
        visible: {
            if (saved)
                return modelData.saved
            else
                return !modelData.saved
        }

        label: modelData.name
        width: wifiPage.width

        description: {
            if ((modelData.state === "online") || (modelData.state === "ready")) {
                return qsTr("connected");
            } else if (modelData.state === "association" || modelData.state === "configuration") {
                return qsTr("connecting")+"...";
            } else {
                if (modelData.security[0] === "none") {
                    return qsTr("open");
                } else {
                    return qsTr("secure");
                }
            }
        }
        icon: (getStrengthIndex(modelData.strength) === "0") ?
                  "image://theme/icon_wifi_0" : "image://theme/icon_wifi_focused" +
                  getStrengthIndex(modelData.strength)

        onClicked:{
            if (modelData.state === "idle" || modelData.state === "failure"){
                console.log("Show settings page");
                pageStack.push(Qt.resolvedUrl("WifiSettings.qml"),{modelData: modelData});
            } else {
                console.log("Show network status page");
                var component = Qt.createComponent(Qt.resolvedUrl("WifiStatus.qml")).errorString();
                console.log(component);
                pageStack.push(Qt.resolvedUrl("WifiStatus.qml"),{modelData: modelData});
            }
        }

        actions: Rectangle{
            width: childrenRect.width+size.dp(16)
            height: parent.height
            Image{
                id: removeNetworkButton
                source: "/usr/share/glacier-settings/qml/img/trash.svg"
                width: height
                height: Theme.itemHeightSmall
                fillMode: Image.PreserveAspectFit
                sourceSize{
                    width: width
                    height: height
                }
                anchors{
                    top:parent.top
                    topMargin: size.dp(8)
                    left: parent.left
                    leftMargin: size.dp(8)
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        modelData.remove();
                        model.hideAllActions(-1);
                    }
                }
            }

            Image{
                source: "/usr/share/glacier-settings/qml/img/disconnect.svg"
                visible: (modelData.state === "online" || modelData.state === "ready")

                width: Theme.itemHeightSmall
                height: width
                fillMode: Image.PreserveAspectFit
                sourceSize{
                    width: width
                    height: height
                }
                anchors{
                    top:parent.top
                    topMargin: size.dp(8)
                    left: removeNetworkButton.right

                    leftMargin: size.dp(16)
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        modelData.requestDisconnect();
                        model.hideAllActions(-1);
                    }
                }
            }
        }
    }
}
