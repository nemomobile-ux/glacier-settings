/*
 * Copyright (C) 2026 Chupligin Sergey <neochapay@gmail.com>
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

#include "ethernetsettingsplugin.h"

EthernetSettingsPlugin::EthernetSettingsPlugin(QObject* parent)
    : m_enabled(false)
    , m_description(tr("Wired network"))
{
    m_manager = NetworkManager::sharedInstance();

    connect(m_manager.data(), &NetworkManager::technologiesChanged, this, &EthernetSettingsPlugin::onTechnologiesChanged);

    m_ethernetTech = m_manager->getTechnology("ethernet");

    if (m_ethernetTech) {
        m_enabled = m_ethernetTech->available();

        connect(m_ethernetTech, &NetworkTechnology::poweredChanged, this, &EthernetSettingsPlugin::onPoweredChanged);
        connect(m_ethernetTech, &NetworkTechnology::connectedChanged, this, &EthernetSettingsPlugin::onConnectedChanged);
        connect(m_ethernetTech, &NetworkTechnology::availableChanged, this, &EthernetSettingsPlugin::onAvailableChanged);
    }
}

void EthernetSettingsPlugin::onPoweredChanged(const bool& powered)
{
    QString newStatus;
    if (powered) {
        if (m_ethernetTech->connected()) {
            newStatus = tr("connected");
        } else {
            newStatus = tr("disconnected");
        }
    } else {
        newStatus = tr("disabled");
    }

    if (newStatus != m_description) {
        m_description = newStatus;
        emit pluginChanged(id());
    }
}

void EthernetSettingsPlugin::onConnectedChanged(const bool& connected)
{
    QString newStatus;
    if (connected) {
        newStatus = tr("connected");
    } else {
        newStatus = tr("disconnected");
    }

    if (newStatus != m_description) {
        m_description = newStatus;
        emit pluginChanged(id());
    }
}

void EthernetSettingsPlugin::onAvailableChanged()
{
    if (!m_ethernetTech) {
        return;
    }

    bool available = m_ethernetTech->available();
    if (m_enabled != available) {
        m_enabled = available;
        emit pluginChanged(id());
    }
}

void EthernetSettingsPlugin::onTechnologiesChanged()
{
    NetworkTechnology* newTech = m_manager->getTechnology("ethernet");
    if (m_ethernetTech == newTech) {
        return;
    }

    bool oldPowered = false;
    bool oldConnected = false;
    bool oldAvailable = m_enabled;

    if (m_ethernetTech) {
        oldPowered = m_ethernetTech->powered();
        oldConnected = m_ethernetTech->connected();

        disconnect(m_ethernetTech, &NetworkTechnology::poweredChanged, this, &EthernetSettingsPlugin::onPoweredChanged);
        disconnect(m_ethernetTech, &NetworkTechnology::connectedChanged, this, &EthernetSettingsPlugin::onConnectedChanged);
        disconnect(m_ethernetTech, &NetworkTechnology::availableChanged, this, &EthernetSettingsPlugin::onAvailableChanged);
    }

    m_ethernetTech = newTech;

    if (m_ethernetTech) {
        m_enabled = m_ethernetTech->available();
        connect(m_ethernetTech, &NetworkTechnology::poweredChanged, this, &EthernetSettingsPlugin::onPoweredChanged);
        connect(m_ethernetTech, &NetworkTechnology::connectedChanged, this, &EthernetSettingsPlugin::onConnectedChanged);
        connect(m_ethernetTech, &NetworkTechnology::availableChanged, this, &EthernetSettingsPlugin::onAvailableChanged);

        bool powered = m_ethernetTech->powered();
        bool connected = m_ethernetTech->connected();
        if (powered != oldPowered || connected != oldConnected || m_enabled != oldAvailable) {
            emit pluginChanged(id());
        }
    } else if (oldAvailable) {
        m_enabled = false;
        emit pluginChanged(id());
    }
}
