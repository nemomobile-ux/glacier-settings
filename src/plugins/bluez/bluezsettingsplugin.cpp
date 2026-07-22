/*
 * Copyright (C) 2022-2025 Chupligin Sergey <neochapay@gmail.com>
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

#include "bluezsettingsplugin.h"
#include <BluezQt/InitManagerJob>
#include <QDebug>
#include <connman-qt6/networktechnology.h>

BluezSettingsPlugin::BluezSettingsPlugin(QObject* parent)
    : m_btTechnology(nullptr)
    , m_manager(new BluezQt::Manager(this))
    , m_enabled(false)
{
    m_networkManager = NetworkManager::sharedInstance();
    if (!m_networkManager) {
        qWarning() << "Network manager not available";
        return;
    }

    connect(m_networkManager.data(), &NetworkManager::technologiesChanged, this, &BluezSettingsPlugin::updateBluetoothTechnology);
    connect(m_manager, &BluezQt::Manager::deviceAdded, this, &BluezSettingsPlugin::onBtDeviceChanged);
    connect(m_manager, &BluezQt::Manager::deviceRemoved, this, &BluezSettingsPlugin::onBtDeviceChanged);

    updateBluetoothTechnology();

    BluezQt::InitManagerJob* job = m_manager->init();
    if (job) {
        connect(job, &BluezQt::InitManagerJob::result, this, &BluezSettingsPlugin::recalcPluginStatus);
        job->start();
    }
}

bool BluezSettingsPlugin::enabled()
{
    return m_enabled;
}

void BluezSettingsPlugin::recalcPluginStatus()
{
    bool enabled = false;

    if (m_btTechnology != nullptr
        && m_btTechnology->available()
        && !m_manager->adapters().isEmpty()) {
        enabled = true;
    }

    if (enabled != m_enabled) {
        m_enabled = enabled;
        emit pluginChanged(id());
    }
}

void BluezSettingsPlugin::updateBluetoothTechnology()
{
    if (m_btTechnology != nullptr) {
        m_btTechnology->disconnect();
    }

    m_btTechnology = m_networkManager->getTechnology("bluetooth");

    if (m_btTechnology) {
        connect(m_btTechnology, &NetworkTechnology::availableChanged, this, &BluezSettingsPlugin::recalcPluginStatus);
    } else {
        qWarning() << "Bluetooth technology not available in network manager";
        return;
    }

    recalcPluginStatus();
}

void BluezSettingsPlugin::onBtDeviceChanged(BluezQt::DevicePtr device)
{
    Q_UNUSED(device)
    recalcPluginStatus();
}
