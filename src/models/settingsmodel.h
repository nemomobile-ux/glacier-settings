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
#ifndef SETTINGSMODEL_H
#define SETTINGSMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QJsonObject>
#include <QJsonArray>

class SettingsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit SettingsModel(QObject *parent = 0);
    void init();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    QVariantMap data(const QModelIndex &index) const;
    QHash<int, QByteArray> roleNames() const {return hash;}

    static int compareCategories(QString leftCategory, QString rightCategory);

    static QStringList defaultCategories;
    static QMap<QString, QString> extraTranlation;

    Q_INVOKABLE bool pluginAviable(QString name);

private:
    QVariantMap get(int idx) const;
    QHash<int,QByteArray> hash;
    const QString m_pluginsDir;
    QStringList m_roleNames;
    QJsonArray m_pluginsData; //plugins list

    QVariantList pluginsInCategory(QString category) const;
    bool loadConfig(QString configFileName);
};

#endif // SETTINGSMODEL_H
