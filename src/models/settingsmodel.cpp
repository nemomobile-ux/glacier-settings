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


QStringList SettingsModel::defaultCategories = {
    QT_TR_NOOP("Personalization"),
    QT_TR_NOOP("Network"),
    QT_TR_NOOP("Security"),
    QT_TR_NOOP("Development"),
    QT_TR_NOOP("Info"),
    QT_TR_NOOP("Other")
};

QMap<QString, QString> SettingsModel::extraTranlation = QMap<QString, QString>();

SettingsModel::SettingsModel(QObject *parent) :
    QAbstractListModel(parent)
  , m_pluginsDir("/usr/share/glacier-settings/plugins/")
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
        if(!loadConfig(fileInfo.fileName())) {
            qWarning() << "Wrong plugin config";
        }
    }

    if(rowCount() == 0) {
        qWarning() << "Plugins directory is empty";
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

    /*Remove empty categories*/
    for(const QString &category : qAsConst(defaultCategories)) {
        if(pluginsInCategory(category).count() == 0) {
            defaultCategories.removeAll(category);
        }
    }
}

bool SettingsModel::loadConfig(QString configFileName)
{
    /*
     * in first check plugin configs into device specific
     * dir.
    */
    QFile dsPluginConfig("/etc/glacier-settings/plugins/"+configFileName);
    if(dsPluginConfig.exists()) {
        qDebug() << "Load device speciffic plugin config" << "/etc/glacier-settings/plugins/"+configFileName;

        dsPluginConfig.open(QIODevice::ReadOnly | QIODevice::Text);
        QJsonDocument dsConfig = QJsonDocument::fromJson(dsPluginConfig.readAll());
        QJsonObject dsConfigObject = dsConfig.object();

        if(dsConfigObject.contains("enabled")) {
            if(!dsConfigObject["enabled"].toBool()) {
                qDebug() << "Disabled by device specifig config";
                return false;
            }
        }
    }

    QFile pluginConfig(m_pluginsDir+configFileName);
    pluginConfig.open(QIODevice::ReadOnly | QIODevice::Text);
    QJsonDocument config = QJsonDocument::fromJson(pluginConfig.readAll());
    QJsonObject configObject = config.object();

    for (const QString &role : configObject.keys()) {
        if (!m_roleNames.contains(role)) {
            m_roleNames << role;
            hash.insert(Qt::UserRole+hash.count() ,role.toLatin1());
        }
    }

    if(configObject.contains("title")
            && configObject.contains("category")
            && configObject.contains("path")) {

        if (configObject.contains("translation_dir")
                && configObject.contains("translation_file")) {
            QString t_dir = configObject["translation_dir"].toString();
            QString t_file = configObject["translation_file"].toString();
            qDebug() << "extra translation files " << configObject["title"].toString() << "" << t_dir << " " << t_file;
            extraTranlation[t_dir] = t_file;
        }

        m_pluginsData.append(configObject);
        return true;
    } else {
        return false;
    }
}

bool SettingsModel::pluginAviable(QString name)
{
    if(name.length() == 0) {
        return false;
    }

    QFile pluginConfig(m_pluginsDir+"/"+name+".json");

    return pluginConfig.exists();
}

QVariantList SettingsModel::pluginsInCategory(QString category) const
{
    QVariantList pluginsInCat;

    for (const QJsonValue &item : m_pluginsData) {
        if(item.toObject().value("category").toString() == category) {
            QVariantMap map = item.toObject().toVariantMap();
            QString title = map["title"].toString();
            QString path = map["path"].toString();
            map["title"] = QCoreApplication::translate(path.toLatin1(), title.toLatin1());
            pluginsInCat.append(map);
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
        return tr(item.toString().toLatin1());
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
