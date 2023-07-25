/*
 * Copyright (C) 2022 Chupligin Sergey <neochapay@gmail.com>
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

import Nemo.Controls

import org.nemomobile.systemsettings 1.0

import Glacier.Controls.Settings 1.0

Page {
    id: batteryHealthPage

    headerTools: HeaderToolsLayout {
        id: header
        showBackButton: true;
        title: qsTr("Battery health")
    }

    BatteryStatus{
        id: batteryStatus
    }

    SettingsColumn{
        id: powerStatusColumn
        spacing: Theme.itemSpacingLarge

        Label{
            id: chargeEnableLimitLabel
            text: qsTr("Charger enable limit")
        }

        Slider {
            id: chargeEnableLimitSlider
            value: batteryStatus.chargeEnableLimit
            showValue: true
            from: 1
            to: 100
            stepSize: 1
            alwaysUp: true
            onValueChanged: {
                batteryStatus.chargeEnableLimit = chargeEnableLimitSlider.value
            }
        }

        Label{
            id: chargeDisableLimitLabel
            text: qsTr("Charger disable limit")
        }

        Slider {
            id: chargeDisableLimitSlider
            value: batteryStatus.chargeDisableLimit
            showValue: true
            from: 1
            to: 100
            stepSize: 1
            alwaysUp: true
            onValueChanged: {
                batteryStatus.chargeDisableLimit = chargeDisableLimitSlider.value
            }
        }
    }
}
