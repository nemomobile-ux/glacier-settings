import QtQuick 2.0

Rectangle {
    id: quickButton

    property bool activated: true
    property string icon

    width: (parent.width-120)/5
    height: width

    color: "transparent"

    Image {
        id: image
        source: icon
        width: parent.width*0.8
        height: width

        sourceSize.width: width
        sourceSize.height: height

        anchors.centerIn: parent
    }
}
