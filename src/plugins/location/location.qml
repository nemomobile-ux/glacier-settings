/*
 * Copyright (C) 2017-2022 Chupligin Sergey <neochapay@gmail.com>
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

import Nemo
import Nemo.Controls

import Nemo.Configuration 1.0

import org.nemomobile.systemsettings 1.0
import org.nemomobile.glacier.settings 1.0

import Glacier.Controls.Settings 1.0

Page {
    id: gpsPage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("Location")
    }

    SatelliteModel {
        id: satelliteModel
        running: true
    }

    LocationSettings{
        id: locationSettings
    }

    Flickable {
        id: mainFlickable
        anchors.fill: parent;
        contentWidth: parent.width;
        contentHeight: gpsColumn.childrenRect.height + 2*Theme.itemSpacingLarge

        SettingsColumn{
            id: gpsColumn
            spacing: Theme.itemSpacingLarge

            RightCheckBox{
                id: locationEnable
                label: qsTr("Enable location")
                checked: locationSettings.locationEnabled
                onCheckedChanged: {
                    locationSettings.locationEnabled = locationEnable.checked
                }
            }

            RightCheckBox{
                id: gpsEnabled
                label: qsTr("Enable sattelites location")
                checked: locationSettings.gpsEnabled
                visible: locationSettings.gpsAvailable
                onCheckedChanged: {
                    locationSettings.gpsEnabled = gpsEnabled.checked
                }
            }

            RightCheckBox{
                id: gpsFlightModeEnabled
                label: qsTr("Use sattelites location in flight mode")
                checked: locationSettings.gpsFlightMode
                visible: locationSettings.gpsAvailable
                onCheckedChanged: {
                    locationSettings.gpsFlightMode = gpsFlightModeEnabled.checked
                }
            }

            RightCheckBox{
                id: onlineServicesEnabled
                label: qsTr("Enable online location services")
                checked: locationSettings.hereState == LocationSettings.OnlineAGpsEnabled || locationSettings.mlsEnabled || locationSettings.yandexOnlineState == LocationSettings.OnlineAGpsEnabled
                visible: locationSettings.hereAvailable || locationSettings.mlsAvailable || locationSettings.yandexAvailable
                onCheckedChanged: {
                    if(onlineServicesEnabled.checked) {
                        locationSettings.hereState = LocationSettings.OnlineAGpsEnabled
                        locationSettings.yandexOnlineState = LocationSettings.OnlineAGpsEnabled
                    } else {
                        locationSettings.hereState = LocationSettings.OnlineAGpsDisabled
                        locationSettings.yandexOnlineState = LocationSettings.OnlineAGpsDisabled
                    }
                    locationSettings.mlsEnabled = onlineServicesEnabled.checked
                }
            }

            Label{
                id: latitudeLabel
                font.bold: true
                text: qsTr("Latitude")+" : " + qsTr("unavailable")
                visible: locationSettings.locationEnabled
            }

            Label{
                id: longitudeLabel
                font.bold: true
                text: qsTr("Longitude")+" : " + qsTr("unavailable")
                visible: locationSettings.locationEnabled
            }

            Label{
                id: sourceLabel
                font.bold: true
                text: qsTr("Source")+" : "+printableMethod(positionSource.supportedPositioningMethods)
                visible: locationSettings.locationEnabled
            }

            Rectangle{
                id: satView
                width: parent.width
                height: width
                color: "transparent"
                clip: true
                visible: locationSettings.gpsEnabled

                Row {
                    property int rows: 13
                    spacing: satView.width/39

                    Rectangle {
                        id: scale
                        width: satView.width/13
                        height: satView.height
                        color: signalColor(100)
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: lawngreenRect.top
                            font.pixelSize: Theme.fontSizeTiny
                            text: "50"
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            font.pixelSize: Theme.fontSizeTiny
                            text: "100"
                        }

                        Rectangle {
                            id: redRect
                            width: parent.width
                            color: signalColor(0)
                            height: parent.height*10/100
                            anchors.bottom: parent.bottom
                            Text {
                                id: strengthLabel
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                font.pixelSize: Theme.fontSizeTiny
                                text: "00"
                            }
                        }
                        Rectangle {
                            id: orangeRect
                            height: parent.height*10/100
                            anchors.bottom: redRect.top
                            width: parent.width
                            color: signalColor(10)
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                font.pixelSize: Theme.fontSizeTiny
                                text: "10"
                            }
                        }
                        Rectangle {
                            id: goldRect
                            height: parent.height*10/100
                            anchors.bottom: orangeRect.top
                            width: parent.width
                            color: signalColor(20)
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                font.pixelSize: Theme.fontSizeTiny
                                text: "20"
                            }
                        }
                        Rectangle {
                            id: yellowRect
                            height: parent.height*10/100
                            anchors.bottom: goldRect.top
                            width: parent.width
                            color: signalColor(30)
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                font.pixelSize: Theme.fontSizeTiny
                                text: "30"
                            }
                        }
                        Rectangle {
                            id: lawngreenRect
                            height: parent.height*10/100
                            anchors.bottom: yellowRect.top
                            width: parent.width
                            color: signalColor(40)
                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                font.pixelSize: Theme.fontSizeTiny
                                text: "40"
                            }
                        }
                    }

                    Repeater {
                        id: repeater
                        model: satelliteModel
                        delegate: Rectangle {
                            height: satView.height
                            width: Theme.itemHeightExtraSmall
                            color: "transparent"

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: parent.height*signalStrength/100
                                color: signalColor(signalStrength);
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                text: satelliteIdentifier
                                font.pixelSize: Theme.fontSizeTiny
                                font.bold: isInUse
                            }
                        }
                    }
                }
            }
        }
    }
    ScrollDecorator{
        id: decorator
        flickable: mainFlickable
    }


    PositionSource {
        id: positionSource
        onPositionChanged: {
            if(!isNaN(positionSource.position.coordinate.latitude)) {
                latitudeLabel.text = qsTr("Latitude")+" : "+positionSource.position.coordinate.latitude
            }
            if(!isNaN(positionSource.position.coordinate.longitude)) {
                longitudeLabel.text = qsTr("Longitude")+" : "+positionSource.position.coordinate.longitude
            }
        }
        active: true
        updateInterval: 10000
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

    function signalColor(signalLevel){
        if(signalLevel>=50) {
            return "#32cd32";
        }
        if(signalLevel < 50 && signalLevel >= 40) {
            return "#7cFc00";
        }
        if(signalLevel < 40 && signalLevel >= 30) {
            return "yellow";
        }
        if(signalLevel < 30 && signalLevel >= 20) {
            return "#ffd700";
        }
        if(signalLevel < 20 && signalLevel >= 10) {
            return "#ffa500";
        }
        return "red";
    }
}
