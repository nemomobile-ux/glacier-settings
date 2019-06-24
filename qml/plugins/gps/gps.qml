/*
 * Copyright (C) 2017 Chupligin Sergey <neochapay@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this library; see the file COPYING.LIB.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */
import QtQuick 2.6
import QtQuick.Window 2.1
import QtPositioning 5.2

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2
import org.nemomobile.systemsettings 1.0

import "../../components/"

Page {
    id: gpsPage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("Location")
    }

    TechnologyModel {
        id: gpsModel
        name: "gps"
    }

    LocationSettings {
        id: locationSettings
    }

    SettingsColumn{
        id: gpsColumn

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
            font.bold: true
            text: qsTr("Latitude")+" : "+positionSource.position.coordinate.latitude
            visible: gpsModel.powered && positionSource.position.coordinate.latitude
        }

        Label{
            id: longitudeLabel
            font.bold: true
            text: qsTr("Longitude")+" : "+positionSource.position.coordinate.longitude
            visible: gpsModel.powered && positionSource.position.coordinate.longitude
        }

        Label{
            id: sourceLabel
            font.bold: true
            text: qsTr("Source")+" : "+printableMethod(positionSource.supportedPositioningMethods)
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
