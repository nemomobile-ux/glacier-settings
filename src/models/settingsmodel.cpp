/*
 * Copyright (C) 2017-2022 Chupligin Sergey <neochapay@gmail.com>
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

#include <QGuiApplication>
#include <QTranslator>
#include <QCoreApplication>
#include <QAbstractListModel>
#include <QDebug>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QMetaEnum>

#include "glaciersettingsplugin.h"
#include "settingspluginhost.h"

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

QMap<QString, QString> SettingsModel::extraTranlation = QMap<QString, QString>();

SettingsModel::SettingsModel(QObject *parent) :
    QAbstractListModel(parent)
  , m_pluginManager(new SettingsPluginManager())
{
    m_roleNames << "title";
    m_roleNames << "items";

    for (const QString &role : qAsConst(m_roleNames)) {
        hash.insert(Qt::UserRole+hash.count() ,role.toLatin1());
    }

    init();
}

int SettingsModel::compareCategories(QString leftCategory, QString rightCategory)
{
    return 0;
    /*if(leftCategory == rightCategory) {
        return 0;
    } else if (defaultCategories.contains(leftCategory) && defaultCategories.contains(rightCategory)) {
        return defaultCategories.indexOf(leftCategory)-defaultCategories.indexOf(rightCategory);
    } else if(defaultCategories.contains(leftCategory)) {
        return -1;
    } else {
        return 1;
    }*/
}

void SettingsModel::init()
{
    if(m_pluginManager->getPlugins().count() == 0) {
        qWarning() << "Plugins not installed";
        return;
    }

    for(GlacierSettingsPlugin* plugin :m_pluginManager->getPlugins()) {
        qDebug() << "Load " << plugin->title();
        if(!plugin->enabled()) {
            qWarning() << "Plugin disabled";
            continue;
        }

        QJsonObject pluginObject;
        pluginObject["titile"] = plugin->title();
        pluginObject["category"] = plugin->category();
        pluginObject["path"] = plugin->qmlPath();

        m_pluginsData.append(pluginObject);
    }

    QCoreApplication *app = QCoreApplication::instance();
    for (QMap<QString, QString>::const_iterator i = extraTranlation.constBegin(); i != extraTranlation.constEnd(); ++i) {

        QTranslator* myappTranslator = new QTranslator(app);
        if (myappTranslator->load(QLocale(), i.value(), QLatin1String("_"), i.key() )) {
            qDebug() << "translation.load() success" << i.key() << i.value() << QLocale::system().name();
            if (app->installTranslator(myappTranslator)) {
                qDebug() << "installTranslator() success"  << i.key() << i.value() << QLocale::system().name();
            } else {
                qDebug() << "installTranslator() failed" << i.key() << i.value() << QLocale::system().name();
            }
        } else {
            qDebug() << "translation.load() failed"  << i.key() << i.value() << QLocale::system().name();
        }

    }

    /*Remove empty categories
    for(int i = 0; i < defaultCategories.keyCount(); i++ )
        if(pluginsInCategory((GlacierSettingsPlugin::PluginCategory)defaultCategories.value(i)).count() == 0) {
            defaultCategories.removeAll(defaultCategories.value(i);
        }
    }*/
}

bool SettingsModel::pluginAviable(QString name)
{
    if(name.length() == 0) {
        return false;
    }

    for(GlacierSettingsPlugin* plugin :m_pluginManager->getPlugins()) {
        if(plugin->title() == name) {
            return true;
        }
    }

    return false;
}

QVariantList SettingsModel::pluginsInCategory(GlacierSettingsPlugin::PluginCategory category) const
{
    QVariantList pluginsInCat;

    for (GlacierSettingsPlugin* item : m_pluginManager->getPlugins()) {
        if(item->category() == category) {
            QVariantMap map;
            map["title"] = item->title();
            map["icon"] = item->icon();
            map["path"] = item->qmlPath();
            map["description"] = item->description();
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

int SettingsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return defaultCategories.keyCount();
}


QVariantMap SettingsModel::get(int idx) const
{
    return QVariantMap{
        {"title", m_pluginManager->getPlugins().at(idx)->title() },
        {"items", pluginsInCategory(m_pluginManager->getPlugins().at(idx)->category())}
    };
}

QVariant SettingsModel::data(const QModelIndex &index, int role) const
{
    Q_UNUSED(role);
    if (!index.isValid())
        return QVariant();

    if (index.row() >= defaultCategories.keyCount())
        return QVariant();

    QVariant item = defaultCategories.value(index.row());

    if(role == Qt::UserRole) {
        return categoryToString((GlacierSettingsPlugin::PluginCategory)item.toUInt());
    } else if(role == Qt::UserRole+1) {
        return pluginsInCategory((GlacierSettingsPlugin::PluginCategory)item.toUInt());
    }
    return QVariant();
}

QVariantMap SettingsModel::data(const QModelIndex &index) const
{
    if (!index.isValid())
        return QVariantMap();

    if (index.row() >= defaultCategories.keyCount())
        return QVariantMap();

    return get(index.row());
}
