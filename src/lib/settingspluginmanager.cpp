/*
 * Copyright (C) 2022-2026 Chupligin Sergey <neochapay@gmail.com>
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

#include "settingspluginmanager.h"
#include "logging.h"

#include <QDir>

SettingsPluginManager::SettingsPluginManager()
{
}

SettingsPluginManager::~SettingsPluginManager()
{
    qDeleteAll(m_hosts);
    m_hosts.clear();
    m_pluginList.clear();
}

void SettingsPluginManager::loadPlugins()
{
    qDeleteAll(m_hosts);
    m_hosts.clear();
    m_pluginList.clear();

    QDir pluginsDir(QString(INSTALLLIBDIR) + "/glacier-settings/");
    pluginsDir.setFilter(QDir::Files);
    pluginsDir.setNameFilters({ "*.so" });

    for (const QString& file : pluginsDir.entryList()) {
        const QString path = pluginsDir.absoluteFilePath(file);
        SettingsPluginHost* shp = new SettingsPluginHost(path, this);
        if (!shp->valid()) {
            qCWarning(lcGlacierSettingsCoreLog) << "Failed to load plugin:" << path;
            delete shp;
            continue;
        }
        GlacierSettingsPlugin* plugin = shp->get();
        m_hosts.push_back(shp);
        m_pluginList.push_back(plugin);
        connect(plugin, &GlacierSettingsPlugin::pluginChanged, this, &SettingsPluginManager::pluginDataChanged);

    }
    emit pluginListUpated();
}
