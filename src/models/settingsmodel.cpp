/*
 * Copyright (C) 2017-2020 Chupligin Sergey <neochapay@gmail.com>
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
#include <QDebug>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>

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


const QStringList SettingsModel::defaultCategories = {
    "Personalization",
    "Network",
    "Security",
    "Development",
    "Info",
    "Other"
};

SettingsModel::SettingsModel(QObject *parent) :
    QAbstractListModel(parent)
{
    m_roleNames << "title";
    m_roleNames << "items";

    for (const QString &role : m_roleNames) {
        hash.insert(Qt::UserRole+hash.count() ,role.toLatin1());
    }
}


void SettingsModel::setPath(QString path)
{
    if(m_pluginsDir != path) {
        m_pluginsDir = path;
        init();

        emit pathChanged();
    }
}

int SettingsModel::compareCategories(QString leftCategory, QString rightCategory)
{
    if(leftCategory == rightCategory) {
        return 0;
    } else if (defaultCategories.contains(leftCategory) && defaultCategories.contains(rightCategory)) {
        return defaultCategories.indexOf(leftCategory)-defaultCategories.indexOf(rightCategory);
    } else if(defaultCategories.contains(leftCategory)) {
        return -1;
    } else {
        return 1;
    }
}

void SettingsModel::init()
{
    QDir pluginsPath = QDir(m_pluginsDir);
    qDebug() << "Start scan plugins dir " << pluginsPath.absolutePath();
    pluginsPath.setNameFilters(QStringList("*.json"));

    const QFileInfoList &list = pluginsPath.entryInfoList();
    QListIterator<QFileInfo> it (list);

    while (it.hasNext ()) {
        const QFileInfo &fileInfo = it.next ();
        qDebug() << "Load " << fileInfo.fileName();
        if(!loadConfig(m_pluginsDir+fileInfo.fileName())) {
            qWarning() << "Wrong plugin config";
        }
    }

    if(rowCount() == 0)
        qWarning() << "Plugins directory is empty";
}

bool SettingsModel::loadConfig(QString configFileName)
{
    QFile pluginConfig(configFileName);
    pluginConfig.open(QIODevice::ReadOnly | QIODevice::Text);
    QJsonDocument config = QJsonDocument::fromJson(pluginConfig.readAll());
    QJsonObject configObject = config.object();

    for (QString role : configObject.keys()) {
        if (!m_roleNames.contains(role)) {
            m_roleNames << role;
            hash.insert(Qt::UserRole+hash.count() ,role.toLatin1());
        }
    }

    if(configObject.contains("title") && configObject.contains("category") && configObject.contains("path")) {
        m_pluginsData.append(configObject);
        return true;
    } else {
        return false;
    }
}

bool SettingsModel::pluginAviable(QString name)
{
    if(name.length() == 0)
        return false;

    QFile pluginConfig(m_pluginsDir+"/"+name+".json");

    return pluginConfig.exists();
}

QVariant SettingsModel::pluginsInCategory(QString category) const
{
    QVariantList pluginsInCat;

    for (const QJsonValue &item : m_pluginsData) {
        if(item.toObject().value("category").toString() == category) {
            pluginsInCat.append(item.toObject().toVariantMap());
        }
    }
    return pluginsInCat;
}

int SettingsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return defaultCategories.count();
}


QVariantMap SettingsModel::get(int idx) const
{
    QString title = defaultCategories.at(idx);

    return QVariantMap{
        {"title", title },
        {"items", pluginsInCategory(title)}
    };
}

QVariant SettingsModel::data(const QModelIndex &index, int role) const
{
    Q_UNUSED(role);
    if (!index.isValid())
        return QVariant();

    if (index.row() >= defaultCategories.count())
        return QVariant();

    QVariant item = defaultCategories.at(index.row());

    if(role == Qt::UserRole) {
        return item;
    } else if(role == Qt::UserRole+1) {
        return pluginsInCategory(item.toString()) ;
    }
    return QVariant();
}

QVariantMap SettingsModel::data(const QModelIndex &index) const
{
    if (!index.isValid())
        return QVariantMap();

    if (index.row() >= defaultCategories.size())
        return QVariantMap();

    return get(index.row());
}
