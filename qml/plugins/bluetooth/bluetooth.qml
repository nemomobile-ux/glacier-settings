import QtQuick 2.0
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2
import org.kde.bluezqt 1.0 as BluezQt
import Nemo.Ssu 1.1 as Ssu

Page {
    id: bluetoothPage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("Bluetooth settings")
    }

    property QtObject _adapter: _bluetoothManager && _bluetoothManager.usableAdapter
    property QtObject _bluetoothManager: BluezQt.Manager

    TechnologyModel {
        id: bluetoothModel
        name: "bluetooth"
    }

    Rectangle{
        id: bluetoothEnable
        width: parent.width
        height: childrenRect.height

        color: "transparent"

        Label {
            id: nameLabel
            text: qsTr("Enable Bluetooth")
            anchors {
                left: bluetoothEnable.left
                leftMargin: size.dp(20)
            }
            wrapMode: Text.Wrap
            font.pointSize: size.dp(22)
            font.bold: true
            color: "#ffffff"
        }

        CheckBox {
            id: columnCheckBox
            checked: bluetoothModel.powered
            anchors {
                right: bluetoothEnable.right
                rightMargin: size.dp(20)
                verticalCenter: nameLabel.verticalCenter
            }
            onClicked: {
                bluetoothModel.setPowered(columnCheckBox.checked)
            }
        }
    }


    Rectangle {
        id: bluetoothName
        width: parent.width
        height: childrenRect.height

        visible: bluetoothModel.powered

        color: "transparent"

        anchors {
            top: bluetoothEnable.bottom
            topMargin: size.dp(20)
        }

        Label {
            id: bluetoothNameLabel
            text: qsTr("Device name");
            anchors {
                left: parent.left
                leftMargin: size.dp(20)
            }
        }

        TextField {
            id: bluetoothNameInput
            text: _adapter.name

            font.pointSize: Theme.label.pointSize

            anchors {
                top: bluetoothNameLabel.bottom
                topMargin: size.dp(20)
                left: parent.left
                leftMargin: size.dp(20)
            }
            onEditingFinished: {
                if (_adapter) {
                    var newName = text.length ? text : Ssu.DeviceInfo.displayName(Ssu.DeviceInfo.DeviceModel);
                    if (_adapter.name != newName) {
                        _adapter.name = newName
                    } else {
                        text = _adapter.name
                    }
                }
            }
        }
    }

    Rectangle {
        id: visible
        width: parent.width
        height: childrenRect.height

        visible: bluetoothModel.powered

        color: "transparent"

        anchors {
            top: bluetoothName.bottom
            topMargin: size.dp(20)
        }

        Label {
            id: visibilityLabel
            text: qsTr("Visibility")
            anchors {
                left: parent.left
                leftMargin: size.dp(20)
            }
            wrapMode: Text.Wrap
            font.pointSize: size.dp(22)
            font.bold: true
            color: "#ffffff"
        }

        CheckBox {
            id: visibilityCheckBox

            anchors {
                top: visibilityLabel.bottom
                topMargin: size.dp(20)
                left: parent.left
                leftMargin: size.dp(20)
            }
            onClicked: {
                if (!_adapter) {
                    return;
                }
                _adapter.discoverable = checked;
            }
        }
    }
}
