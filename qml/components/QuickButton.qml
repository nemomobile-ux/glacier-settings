import QtQuick 2.0

Rectangle {
    id: quickButton

    property bool activated: false
    property string icon

    signal clicked

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

        layer.effect: ShaderEffect {
            id: shaderItem
            property color color: quickButton.activated ?  "#ffffff" : "#999999"

            fragmentShader: "
                    varying mediump vec2 qt_TexCoord0;
                    uniform highp float qt_Opacity;
                    uniform lowp sampler2D source;
                    uniform highp vec4 color;
                    void main() {
                        highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
                        gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
                    }
                "
        }

        layer.enabled: true
        layer.samplerName: "source"

        MouseArea{
            id: clickMouseArea
            anchors.fill: parent
            onClicked: {
                clickIcon.clicked()
            }
        }
    }
}
