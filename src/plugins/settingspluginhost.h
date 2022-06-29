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

#ifndef SETTINGSPLUGINHOST_H
#define SETTINGSPLUGINHOST_H

#include <QObject>
#include <QPluginLoader>

#include "glaciersettingsplugin.h"
#include "glaciersettings_global.h"

class QPluginLoader;

class GLACIERSETTINGS_EXPORT SettingsPluginHost: public QObject
{
public:
    SettingsPluginHost(const QString& fileName, QObject *parent = 0);
    ~SettingsPluginHost();

    bool load();
    GlacierSettingsPlugin* get();
    GlacierSettingsPlugin::PluginCategory category();
    QString title();
    QString qmlPath();
    QString icon();
    bool enabled();
    bool valid() {return m_valid;}

private:
    QPluginLoader* m_loader;
    GlacierSettingsPlugin* m_plugin;
    QString m_fileName;

    bool m_valid;
};

#endif // SETTINGSPLUGINHOST_H
