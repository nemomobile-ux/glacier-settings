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

#include "settingspluginmanager.h"

#include <QDir>

SettingsPluginManager::SettingsPluginManager()
{
    QDir pluginsDir("/usr/lib/glacier-settings/");
    for(const QString& file: pluginsDir.entryList(QDir::Files)) {
        SettingsPluginHost* shp = new SettingsPluginHost(pluginsDir.absoluteFilePath(file), this);
        if(shp) {
            if(shp->valid()) {
                m_pluginList.push_back(shp->get());
                connect(shp->get(), &GlacierSettingsPlugin::pluginChanged, this, &SettingsPluginManager::pluginDataChanged);
            } else {
                qDebug() << "Loading" << pluginsDir.absoluteFilePath(file) << " fail";
            }
        } else {
            qWarning() << "can't load" << pluginsDir.absoluteFilePath(file);
        }
        delete(shp);
    }
}

SettingsPluginManager::~SettingsPluginManager()
{

}
