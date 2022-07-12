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

#include "wifisettingsplugin.h"

#include <networktechnology.h>

WiFiSettingsPlugin::WiFiSettingsPlugin(QObject *parent) :
    m_enabled(false)
  , m_description(tr("Wireless networks"))
{
    m_manager = NetworkManagerFactory::createInstance();

    connect(m_manager, &NetworkManager::technologiesChanged, this, &WiFiSettingsPlugin::onTechnologiesChanged);

    m_wifiTech = m_manager->getTechnology("wifi");

    if(m_wifiTech) {
        m_enabled = true;

        connect(m_wifiTech, &NetworkTechnology::poweredChanged, this, &WiFiSettingsPlugin::onPoweredChanded);
        connect(m_wifiTech, &NetworkTechnology::connectedChanged, this, &WiFiSettingsPlugin::onConnectedChanged);
    } else {
        qDebug() << "WiFi not found";
    }
}

void WiFiSettingsPlugin::onPoweredChanded(const bool &powered)
{
    QString newStatus;
    if(powered) {
        newStatus = tr("enabled");
    } else {
        newStatus = tr("disabled");
    }

    if(newStatus != m_description) {
        m_description = newStatus;
        emit pluginChanged(id());
    }
}

void WiFiSettingsPlugin::onConnectedChanged(const bool &connected)
{
    QString newStatus;
    if(connected) {
        newStatus = tr("connected");
    } else {
        newStatus = tr("diconnected");
    }

    if(newStatus != m_description) {
        m_description = newStatus;
        emit pluginChanged(id());
    }
}

void WiFiSettingsPlugin::onTechnologiesChanged()
{
    NetworkTechnology *newTech = m_manager->getTechnology("wifi");
    if(m_wifiTech == newTech) {
        return;
    }

    bool oldPowered, oldConnected = false;

    if (m_wifiTech) {
        oldPowered = m_wifiTech->powered();
        oldConnected = m_wifiTech->connected();

        disconnect(m_wifiTech, &NetworkTechnology::poweredChanged, this, &WiFiSettingsPlugin::onPoweredChanded);
        disconnect(m_wifiTech, &NetworkTechnology::connectedChanged, this, &WiFiSettingsPlugin::onConnectedChanged);
    }

    m_wifiTech = newTech;

    if (m_wifiTech) {
        connect(m_wifiTech, &NetworkTechnology::poweredChanged, this, &WiFiSettingsPlugin::onPoweredChanded);
        connect(m_wifiTech, &NetworkTechnology::connectedChanged, this, &WiFiSettingsPlugin::onConnectedChanged);


        bool powered = m_wifiTech->powered();
        bool connected = m_wifiTech->connected();
        if (powered != oldPowered || connected != oldConnected) {
            emit pluginChanged(id());
        }
    }
}
