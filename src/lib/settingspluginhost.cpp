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

#include "settingspluginhost.h"
#include "logging.h"
#include <QGuiApplication>

SettingsPluginHost::SettingsPluginHost(const QString& fileName, QObject* parent)
    : QObject(parent)
    , m_loader(nullptr)
    , m_myappTranslator(nullptr)
    , m_fileName(fileName)
    , m_valid(false)
{
    m_loader = new QPluginLoader(fileName);
    QObject* plugin = m_loader->instance();
    if (plugin) {
        m_plugin = qobject_cast<GlacierSettingsPlugin*>(plugin);
        if (!m_plugin) {
            qCWarning(lcGlacierSettingsCoreLog) << "Can't cast plugin";
            m_loader->unload();
        } else {
            m_valid = true;
        }

        m_myappTranslator = new QTranslator(qApp);
        if (m_myappTranslator->load(QLocale(), m_plugin->id(), QLatin1String("_"), QLatin1String("/usr/share/glacier-settings/translations/"))) {
            if (qApp->installTranslator(m_myappTranslator)) {
                qCDebug(lcGlacierSettingsCoreLog) << "Plugin " << m_plugin->id() << " installTranslator() success" << QLocale::system().name();
            } else {
                qCWarning(lcGlacierSettingsCoreLog) << "Plugin " << m_plugin->id() << " installTranslator() failed" << QLocale::system().name();
            }
        } else {
            qCWarning(lcGlacierSettingsCoreLog) << "Plugin " << m_plugin->id() << " translation.load() failed" << QLocale::system().name();
        }

    } else {
        qCDebug(lcGlacierSettingsCoreLog) << "Plugin not found" << fileName << m_loader->errorString();
    }
}

SettingsPluginHost::~SettingsPluginHost()
{
    if(m_myappTranslator) {
        qApp->removeTranslator(m_myappTranslator);
    }

    if(m_loader) {
        m_loader->unload();
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
