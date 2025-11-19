/*
 * Copyright (C) 2021-2025 Chupligin Sergey <neochapay@gmail.com>
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

#include "timezonesmodel.h"

TimeZonesModel::TimeZonesModel(QObject* parent)
    : QAbstractListModel(parent)
{
    m_tzInfo = std::make_shared<TimeZoneInfo>();

    m_roleNames << "name";
    m_roleNames << "area";
    m_roleNames << "city";
    m_roleNames << "countryCode";
    m_roleNames << "countryName";
    m_roleNames << "comments";
    m_roleNames << "offset";

    for (const QString& role : m_roleNames) {
        m_hash.insert(Qt::UserRole + m_hash.count(), role.toLatin1());
    }

    m_zones = m_tzInfo->systemTimeZones();
}

int TimeZonesModel::rowCount(const QModelIndex& parent) const
{
    return m_zones.count();
}

QVariant TimeZonesModel::data(const QModelIndex& index, int role) const
{
    Q_UNUSED(role);
    if (!index.isValid())
        return QVariant();

    if (index.row() >= m_zones.count()) {
        return QVariant();
    }

    TimeZoneInfo item = m_zones.at(index.row());

    if (role == Qt::UserRole) {
        return item.name();
    } else if (role == Qt::UserRole + 1) {
        return item.area();
    } else if (role == Qt::UserRole + 2) {
        return item.city();
    } else if (role == Qt::UserRole + 3) {
        return item.countryCode();
    } else if (role == Qt::UserRole + 4) {
        return item.countryName();
    } else if (role == Qt::UserRole + 5) {
        return item.comments();
    } else if (role == Qt::UserRole + 6) {
        return item.offset();
    }
    return QVariant();
}

void TimeZonesModel::search(QString searchString)
{
    beginResetModel();
    if (searchString.isEmpty()) {
        m_zones = m_tzInfo->systemTimeZones();
    } else {
        m_zones.clear();
        foreach (const TimeZoneInfo& zone, m_tzInfo->systemTimeZones()) {
            QString zoneNameStr = zone.name();
            if (zoneNameStr.contains(searchString, Qt::CaseInsensitive)) {
                m_zones.append(zone);
            }
        }
    }
    endResetModel();
}
