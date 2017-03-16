import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.glacier.settings 1.0
import org.nemomobile.systemsettings 1.0

Rectangle {
    id: quickSettings
    color: "transparent"

    width: parent.width
    height: childrenRect.height


    Text {
        id: label
        text: qsTr("Quick settings")
        font.capitalization: Font.AllUppercase
        font.pixelSize: 20
        color: "white"
        anchors{
            left: parent.left
            leftMargin: 10
        }
    }

    Rectangle{
        id: line
        height: 1
        color: "white"
        width: parent.width-label.width-30
        anchors{
            left: label.right
            leftMargin: 10
            verticalCenter: label.verticalCenter
        }
    }


    DisplaySettings{
        id: displaySettings
    }

    Label{
        id: brightnessLabel
        text: qsTr("Brightness");
        anchors{
            left: parent.left
            leftMargin: 20
            top: label.bottom
            topMargin: 20
        }
    }
}
