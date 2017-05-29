/*
 * Copyright (C) 2017 Chupligin Sergey <neochapay@gmail.com>
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

class SettingsModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)

public:
    explicit SettingsModel(QObject *parent = 0);
    void init();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    QJsonObject data(const QModelIndex &index) const;
    QHash<int, QByteArray> roleNames() const {return hash;}

    bool insertRows(int position, int rows, QJsonObject &item, const QModelIndex &index = QModelIndex());
    bool removeRows(int position, int rows, const QModelIndex &index = QModelIndex());

    QList<QJsonObject> settingsList;

    QString path(){return m_pluginsDir;}
    void setPath(QString path);

    static int compareCategories(QString leftCategory, QString rightCategory);

    const static QStringList defaultCategories;

signals:
    void pathChanged();

public slots:
    void addItem(QJsonObject item);
    QJsonObject get(int idx){return settingsList[idx];}
    void remove(int idx);

private:
    QHash<int,QByteArray> hash;
    QString m_pluginsDir;
    QStringList m_roleNames;
    bool loadConfig(QString configFileName);
};

#endif // SETTINGSMODEL_H
