import QtQuick 2.6
import QtQuick.Controls.Nemo 1.0

Column{
    default property alias contentItem: dataItem.children

    width: parent.width

    anchors{
        top: parent.top
        topMargin: size.dp(20)
    }

    Column{
        id: dataItem
        width: parent.width-size.dp(24)*2

        spacing: size.dp(24)
        leftPadding: size.dp(24)
    }
}
