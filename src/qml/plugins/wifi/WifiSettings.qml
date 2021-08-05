/*
 * Copyright (C) 2017-2021 Chupligin Sergey <neochapay@gmail.com>
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

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import MeeGo.Connman 0.2
import Nemo.Dialogs 1.0

import "../../components"

Page {
    id: wifiSettingsPage
    property var modelData

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("Connect to")+" "+modelData.name
    }

    TechnologyModel {
        id: networkingModel
        name: "wifi"
        property bool sheetOpened
        property string networkName
    }

    UserAgent {
        id: userAgent
        onUserInputRequested: {
            console.log("USER INPUT REQUESTED");
            var view = {
                "fields": []
            };
            for (var key in fields) {
                view.fields.push({
                                     "name": key,
                                     "id": key.toLowerCase(),
                                     "type": fields[key]["Type"],
                                     "requirement": fields[key]["Requirement"]
                                 });
                console.log(key + ":");
                for (var inkey in fields[key]) {
                    console.log("    " + inkey + ": " + fields[key][inkey]);
                }
            }
            userAgent.sendUserReply({"Passphrase": passphrase.text})
        }

        onErrorReported: {
            console.log("Got error from model: " + error);
            failDialog.subLabelText = error;
            failDialog.open();
        }
    }

    Component.onCompleted: {
        networkingModel.networkName.text = modelData.name;
    }

    Spinner {
        id: spinner
        anchors.centerIn: parent
        enabled: true;
        visible: false;
    }

    SettingsColumn{
        visible: !spinner.visible

        Label{
            id: currentModeLabel
            text: qsTr("Password: ")
        }

        TextField{
            id: passphrase
            text: modelData.passphrase
            echoMode: TextInput.Password
            width: parent.width
        }

        Button{
            id: connectButton
            height: Theme.itemHeightSmall
            width: parent.width

            onClicked: {
                modelData.passphrase = passphrase.text;
                modelData.requestConnect();
                networkingModel.networkName.text = modelData.name;
                spinner.visible = true;
            }
            text: qsTr("Connect")
        }
    }

    Connections {
        target: modelData
        function onConnectRequestFailed(error) {
            console.log(error)
            failDialog.subLabelText = error;
            failDialog.open();
            spinner.visible = false;
        }

        function onConnectedChanged(connected) {
            if(connected) {
                pageStack.pop();
                spinner.visible = false;
            }
        }
    }


    Dialog{
        id: failDialog
        acceptText: qsTr("Ok")
        headingText: qsTr("Connection failed")

        inline: false

        icon: "image://theme/exclamation-triangle"

        onAccepted: {
            failDialog.close();
        }
    }
}
