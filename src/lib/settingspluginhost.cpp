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

#include "settingspluginhost.h"
#include "logging.h"
#include <QGuiApplication>
#include <QTranslator>

SettingsPluginHost::SettingsPluginHost(const QString& fileName, QObject* parent)
    : QObject(parent)
    , m_fileName(fileName)
    , m_valid(false)
{
    QPluginLoader pluginLoader(fileName);
    QObject* plugin = pluginLoader.instance();
    if (plugin) {
        m_plugin = qobject_cast<GlacierSettingsPlugin*>(plugin);
        if (!m_plugin) {
            qCWarning(lcGlacierSettingsCoreLog) << "Can't cast plugin";
            pluginLoader.unload();
        } else {
            m_valid = true;
        }

        QTranslator* myappTranslator = new QTranslator(qApp);
        if (myappTranslator->load(QLocale(), m_plugin->id(), QLatin1String("_"), QLatin1String("/usr/share/glacier-settings/translations/"))) {
            if (qApp->installTranslator(myappTranslator)) {
                qCDebug(lcGlacierSettingsCoreLog) << "Plugin " << m_plugin->id() << " installTranslator() success" << QLocale::system().name();
            } else {
                qCWarning(lcGlacierSettingsCoreLog) << "Plugin " << m_plugin->id() << " installTranslator() failed" << QLocale::system().name();
            }
        } else {
            qCWarning(lcGlacierSettingsCoreLog) << "Plugin " << m_plugin->id() << " translation.load() failed" << QLocale::system().name();
        }

    } else {
        qCDebug(lcGlacierSettingsCoreLog) << "Plugin not found" << fileName << pluginLoader.errorString();
    }
}

SettingsPluginHost::~SettingsPluginHost()
{
    if (m_plugin) {
        delete m_plugin;
    }
}

GlacierSettingsPlugin* SettingsPluginHost::get()
{
    if (!m_plugin) {
        return nullptr;
    }
    return m_plugin;
}

GlacierSettingsPlugin::PluginCategory SettingsPluginHost::category()
{
    if (!m_plugin) {
        return GlacierSettingsPlugin::PluginCategory::Other;
    }

    return m_plugin->category();
}

QString SettingsPluginHost::title()
{
    if (!m_plugin) {
        return "";
    }
    return m_plugin->title();
}

QString SettingsPluginHost::qmlPath()
{
    if (!m_plugin) {
        return "";
    }
    return m_plugin->qmlPath();
}

QString SettingsPluginHost::icon()
{
    if (!m_plugin) {
        return "";
    }
    return m_plugin->icon();
}

bool SettingsPluginHost::enabled()
{
    if (!m_plugin) {
        return false;
    }
    return m_plugin->enabled();
}
