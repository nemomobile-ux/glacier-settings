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

Rectangle {
    id: quickButton

    property bool activated: false
    property string icon

    signal clicked

    width: visible ? height : 0
    height: visible ? Theme.itemHeightLarge : 0

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
            id: quickButtonMouseArea
            anchors.fill: parent
            onClicked: {
                quickButton.clicked()
            }
        }
    }
}
