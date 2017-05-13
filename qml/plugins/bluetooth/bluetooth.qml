import QtQuick 2.6
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2
import org.kde.bluezqt 1.0 as BluezQt
import Nemo.Ssu 1.1 as Ssu

import "../../components"

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

    SettingsColumn{
        id: bluetoothColumn

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
                }
                wrapMode: Text.Wrap
                font.bold: true
            }

            CheckBox {
                id: columnCheckBox
                checked: bluetoothModel.powered
                anchors {
                    right: bluetoothEnable.right
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

            Label {
                id: bluetoothNameLabel
                text: qsTr("Device name");
                anchors {
                    left: parent.left
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

            Label {
                id: visibilityLabel
                text: qsTr("Visibility")
                anchors {
                    left: parent.left
                }
                wrapMode: Text.Wrap
                font.bold: true
            }

            CheckBox {
                id: visibilityCheckBox

                anchors {
                    right: visible.right
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
}
