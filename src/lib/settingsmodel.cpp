/*
 * Copyright (C) 2017-2025 Chupligin Sergey <neochapay@gmail.com>
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
#include "settingsmodel.h"

#include <QAbstractListModel>
#include <QCoreApplication>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QMetaEnum>
#include <QTranslator>

#include "glaciersettingsplugin.h"

/*
 * Orgeding category DRAFT
 *
 * Settings part:
 * Personalization
 *  - Display
 *  - Sounds
 * Network
 *  - Cellural
 *  - WiFi
 *  - NFC
 * Security
 *  - Device Lock
 * Development
 *  - Devmode
 * Info
 *  - About
 * Other
 */

QMetaEnum SettingsModel::defaultCategories = QMetaEnum::fromType<GlacierSettingsPlugin::PluginCategory>();

SettingsModel::SettingsModel(QObject* parent)
    : QAbstractListModel(parent)
    , m_pluginManager(new SettingsPluginManager())
    , m_showDisabled(false)
{
    m_roleNames << "title";
    m_roleNames << "items";

    for (const QString& role : std::as_const(m_roleNames)) {
        hash.insert(Qt::UserRole + hash.count(), role.toLatin1());
    }

    connect(m_pluginManager, &SettingsPluginManager::pluginListUpated, this, &SettingsModel::updatePluginsList);
    connect(m_pluginManager, &SettingsPluginManager::pluginDataChanged, this, &SettingsModel::updatePluginData);

    if (qgetenv("SETTINGS_SHOW_DISABLED_PLUGINS") == "1") {
        m_showDisabled = true;
    }
}

bool SettingsModel::pluginAviable(QString name)
{
    if (name.length() == 0) {
        return false;
    }

    for (GlacierSettingsPlugin* plugin : m_pluginList) {
        if (plugin->id() == name) {
            return true;
        }
    }

    return false;
}

QString SettingsModel::pluginQmlPath(QString name)
{
    if (name.length() == 0) {
        return QString();
    }

    for (GlacierSettingsPlugin* plugin : m_pluginList) {
        if (plugin->id() == name) {
            return plugin->qmlPath();
        }
    }

    return QString();
}

void SettingsModel::loadPluginsList()
{
    m_pluginManager->loadPlugins();
}

QVariantList SettingsModel::pluginsInCategory(GlacierSettingsPlugin::PluginCategory category) const
{
    QVariantList pluginsInCat;

    for (GlacierSettingsPlugin* item : m_pluginList) {
        if (item == nullptr || item->category() != category) {
            continue;
        }

        QVariantMap map;
        map["title"] = item->title();
        map["icon"] = item->icon();
        map["path"] = item->qmlPath();
        map["description"] = item->description();
        map["enabled"] = item->enabled();
        if(map["enabled"].toBool() || m_showDisabled) {
            pluginsInCat.append(map);
        }
    }
    return pluginsInCat;
}

QString SettingsModel::categoryToString(GlacierSettingsPlugin::PluginCategory category) const
{
    switch (category) {
    case GlacierSettingsPlugin::Development:
        return tr("Development");
        break;
    case GlacierSettingsPlugin::Info:
        return tr("Info");
        break;
    case GlacierSettingsPlugin::Network:
        return tr("Network");
        break;
    case GlacierSettingsPlugin::Personalization:
        return tr("Personalization");
        break;
    case GlacierSettingsPlugin::Security:
        return tr("Security");
        break;
    default:
        return tr("Other");
        break;
    }
}

void SettingsModel::updatePluginData(QString pluginId)
{
    beginResetModel();
    // TODO: not reset model, just update changed item
    endResetModel();
}

void SettingsModel::updatePluginsList()
{
    beginResetModel();
    m_pluginList = m_pluginManager->getPlugins();
    endResetModel();
}

int SettingsModel::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent);
    return defaultCategories.keyCount();
}

QVariantMap SettingsModel::get(int idx) const
{
    return QVariantMap {
        { "title", m_pluginList.at(idx)->title() },
        { "items", pluginsInCategory(m_pluginList.at(idx)->category()) }
    };
}

QVariant SettingsModel::data(const QModelIndex& index, int role) const
{
    Q_UNUSED(role);
    if (!index.isValid())
        return QVariant();

    if (index.row() >= defaultCategories.keyCount())
        return QVariant();

    QVariant item = defaultCategories.value(index.row());

    if (role == Qt::UserRole) {
        return categoryToString((GlacierSettingsPlugin::PluginCategory)item.toUInt());
    } else if (role == Qt::UserRole + 1) {
        return pluginsInCategory((GlacierSettingsPlugin::PluginCategory)item.toUInt());
    }
    return QVariant();
}

QVariantMap SettingsModel::data(const QModelIndex& index) const
{
    if (!index.isValid())
        return QVariantMap();

    if (index.row() >= defaultCategories.keyCount())
        return QVariantMap();

    return get(index.row());
}
