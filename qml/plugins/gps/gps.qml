import QtQuick 2.0
import QtQuick.Window 2.1

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2
import org.nemomobile.systemsettings 1.0

Page {
    id: gpsPage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("Location settings")
    }

    TechnologyModel {
        id: gpsModel
        name: "gps"
    }

    LocationSettings {
        id: locationSettings
    }

    Rectangle{
        id: gpsEnable
        width: parent.width
        height: childrenRect.height

        color: "transparent"

        Label {
            id: nameLabel
            text: qsTr("Enable location")
            anchors {
                left: gpsEnable.left
                leftMargin: size.dp(20)
            }
            wrapMode: Text.Wrap
            font.pointSize: size.dp(22)
            font.bold: true
            color: "#ffffff"
        }

        CheckBox {
            id: gpsCheckBox
            checked: gpsModel.powered
            anchors {
                right: gpsEnable.right
                rightMargin: size.dp(20)
                verticalCenter: nameLabel.verticalCenter
            }
            onClicked: {
                gpsModel.powered = gpsCheckBox.checked
                locationSettings.locationEnabled = gpsCheckBox.checked
            }
        }
    }
}
