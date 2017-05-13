import QtQuick 2.6
import QtQuick.Window 2.1
import QtPositioning 5.2

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

    Column{
        id: gpsColumn
        anchors{
            top: parent.top
            topMargin: size.dp(20)
        }
        width: parent.width
        padding: size.dp(20)

        Rectangle{
            id: gpsEnable
            width: parent.width-size.dp(20)*2
            height: childrenRect.height

            color: "transparent"

            Label {
                id: nameLabel
                text: qsTr("Enable location")
                anchors {
                    left: gpsEnable.left
                }
                wrapMode: Text.Wrap
                font.bold: true
            }

            CheckBox {
                id: gpsCheckBox
                checked: gpsModel.powered
                anchors {
                    right: gpsEnable.right
                    verticalCenter: nameLabel.verticalCenter
                }
                onClicked: {
                    gpsModel.powered = gpsCheckBox.checked
                    locationSettings.locationEnabled = gpsCheckBox.checked
                }
            }
        }

        Label{
            id: latitudeLabel
            text: "<b>"+qsTr("Latitude")+"</b> : "+positionSource.position.coordinate.latitude
            visible: gpsModel.powered
        }

        Label{
            id: longitudeLabel
            text: "<b>"+qsTr("Longitude")+"</b> : "+positionSource.position.coordinate.longitude
            visible: gpsModel.powered
        }

        Label{
            id: sourceLabel
            text: "<b>"+qsTr("Source")+"</b> : "+printableMethod(positionSource.supportedPositioningMethods)
            visible: gpsModel.powered
        }
    }

    PositionSource {
        id: positionSource
        onPositionChanged: {
            latitudeLabel.text = positionSource.position.coordinate.latitude
            longitudeLabel.text = positionSource.position.coordinate.longitude
        }
    }

    function printableMethod(method) {
        if (method === PositionSource.SatellitePositioningMethods)
            return qsTr("Satellite");
        else if (method === PositionSource.NoPositioningMethods)
            return qsTr("Not available")
        else if (method === PositionSource.NonSatellitePositioningMethods)
            return qsTr("Non-satellite")
        else if (method === PositionSource.AllPositioningMethods)
            return qsTr("Multiple")
        return qsTr("source error");
    }
}
