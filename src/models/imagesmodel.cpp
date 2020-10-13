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
#include "imagesmodel.h"

#include <QAbstractListModel>
#include <QDir>

ImagesModel::ImagesModel(QObject *parent) :
    QAbstractListModel(parent)
{
    hash.insert(Qt::UserRole ,QByteArray("path"));
    m_reqursive = false;
}


void ImagesModel::setPath(QString path)
{
    if(m_imagesDir != path) {
        m_imagesDir = path;
        init();
        emit pathChanged();
    }
}

void ImagesModel::setReqursive(bool reqursive)
{
    m_reqursive = reqursive;
    emit reqursiveChanged();
}

void ImagesModel::init()
{
    QDir imagesPathDir = QDir(m_imagesDir);
    imagesPathDir.setNameFilters(QStringList("*.png, *.jpg, *.jpeg"));

    const QFileInfoList &list = imagesPathDir.entryInfoList();
    QListIterator<QFileInfo> it (list);

    while (it.hasNext ()) {
        const QFileInfo &fileInfo = it.next ();
        imageList.append(fileInfo.absoluteFilePath());
    }
}

int ImagesModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return imageList.count();
}

QVariant ImagesModel::data(const QModelIndex &index, int role) const
{
    Q_UNUSED(role);
    if (!index.isValid())
        return QVariant();

    if (index.row() >= imageList.size())
        return QVariant();

    QString item = imageList.at(index.row());

    if(role == Qt::UserRole)
        return item;

    return QVariant();
}
