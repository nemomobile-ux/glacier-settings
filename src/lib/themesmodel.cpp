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

#include "themesmodel.h"

#include <QDir>
#include <algorithm>

ThemesModel::ThemesModel(QObject* parent)
    : QAbstractListModel(parent)
{
    m_hash.insert(Qt::UserRole, QByteArray("name"));
    m_hash.insert(Qt::UserRole + 1, QByteArray("path"));

    QDir imagesPathDir = QDir("/usr/lib/qt/qml/QtQuick/Controls/Styles/Nemo/themes/");
    imagesPathDir.setNameFilters(QStringList("*.json"));
    const QFileInfoList& list = imagesPathDir.entryInfoList();

    m_themes.reserve(list.size());
    for (const QFileInfo& fileInfo : list) {
        const QString path = fileInfo.absoluteFilePath();
        QString name = fileInfo.fileName();
        name.remove("glacier_");
        name.remove(".json");
        m_themes.append(qMakePair(name, path));
    }

    std::sort(m_themes.begin(), m_themes.end(), [](const QPair<QString, QString>& a, const QPair<QString, QString>& b) {
        return a.first < b.first;
    });
}

int ThemesModel::rowCount(const QModelIndex& parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return m_themes.count();
}

QVariant ThemesModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_themes.size()) {
        return QVariant();
    }

    const auto& theme = m_themes.at(index.row());
    if (role == Qt::UserRole) {
        return theme.first;
    }

    if (role == Qt::UserRole + 1) {
        return theme.second;
    }

    return QVariant();
}

QString ThemesModel::getPath(int index)
{
    if (index < 0 || index >= m_themes.size()) {
        return QString();
    }

    return m_themes.at(index).second;
}
