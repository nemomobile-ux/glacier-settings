/*
 * Copyright (C) 2021-2022 Chupligin Sergey <neochapay@gmail.com>
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

#ifndef TIMEZONESMODEL_H
#define TIMEZONESMODEL_H

#include <QObject>
#include <QAbstractListModel>

#include <timezoneinfo.h>

#include "glaciersettings_global.h"

class GLACIERSETTINGS_EXPORT TimeZonesModel:public QAbstractListModel
{
    Q_OBJECT
public:
    explicit TimeZonesModel(QObject *parent = 0);

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const {return m_hash;}

    Q_INVOKABLE void search(QString zoneName);

private:
    QHash<int,QByteArray> m_hash;
    QStringList m_roleNames;

    TimeZoneInfo* m_tzInfo;
    QList<TimeZoneInfo> m_zones;
};

#endif // TIMEZONESMODEL_H
