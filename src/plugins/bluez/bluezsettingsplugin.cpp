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

BluezSettingsPlugin::BluezSettingsPlugin(QObject* parent)
    : m_manager(new BluezQt::Manager(this))
    , m_enabled(false)
{
    BluezQt::InitManagerJob* job = m_manager->init();
    if (job != nullptr) {
        job->start();

        connect(m_manager, &BluezQt::Manager::deviceAdded, this, &BluezSettingsPlugin::recalcPluginStatus);
        connect(m_manager, &BluezQt::Manager::deviceRemoved, this, &BluezSettingsPlugin::recalcPluginStatus);
        connect(m_manager, &BluezQt::Manager::deviceChanged, this, &BluezSettingsPlugin::recalcPluginStatus);

        connect(job, &BluezQt::InitManagerJob::result, [=]() {
            bool enabled = m_manager->adapters().count() > 0;
            if (enabled != m_enabled) {
                m_enabled = enabled;
                emit pluginChanged(id());
            }
        });
    }
}

BluezSettingsPlugin::~BluezSettingsPlugin()
{
}

bool BluezSettingsPlugin::enabled()
{
    return m_enabled;
}

void BluezSettingsPlugin::recalcPluginStatus(BluezQt::DevicePtr device)
{
    Q_UNUSED(device)
    bool enabled = m_manager->adapters().count() > 0;
    if (enabled != m_enabled) {
        m_enabled = enabled;
        emit pluginChanged(id());
    }
}
