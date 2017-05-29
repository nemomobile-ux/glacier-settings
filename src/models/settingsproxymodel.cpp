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
#include "settingsproxymodel.h"
#include "settingsmodel.h"

#include <QSortFilterProxyModel>
#include <QDebug>

SettingsProxyModel::SettingsProxyModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{
    setSortRole(Qt::UserRole);
    setDynamicSortFilter(true);
}

QObject *SettingsProxyModel::model()
{
    return sourceModel();
}

void SettingsProxyModel::setModel(QObject *model)
{
    if(sourceModel() != model)
    {
        setSourceModel(qobject_cast<QAbstractListModel*>(model));
        emit modelChanged();

        sort(0);
    }
}

bool SettingsProxyModel::lessThan(const QModelIndex &left, const QModelIndex &right) const
{
    QJsonObject leftData = qobject_cast<SettingsModel*>(sourceModel())->data(left);
    QJsonObject rightData = qobject_cast<SettingsModel*>(sourceModel())->data(right);

    QString leftCategory = leftData.value("category").toString();
    QString rightCategory = rightData.value("category").toString();

    if(leftCategory == rightCategory)
    {
        QString leftName = leftData.value("name").toString();
        QString rightName = rightData.value("name").toString();

        return leftName > rightName;
    }
    return SettingsModel::compareCategories(leftCategory,rightCategory) > 0;
}


