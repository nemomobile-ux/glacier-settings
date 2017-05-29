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
#ifndef IMAGESMODEL_H
#define IMAGESMODEL_H

#include <QObject>
#include <QAbstractListModel>

class ImagesModel:public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)
    Q_PROPERTY(bool reqursive READ reqursive WRITE setReqursive NOTIFY reqursiveChanged)

public:
    explicit ImagesModel(QObject *parent);
    void init();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const {return hash;}

    QList<QString> imageList;

    QString path(){return m_imagesDir;}
    void setPath(QString path);

    bool reqursive(){return m_reqursive;}
    void setReqursive(bool reqursive);

signals:
    void pathChanged();
    void reqursiveChanged();

private:
    QHash<int,QByteArray> hash;
    QString m_imagesDir;
    bool m_reqursive;
};

#endif // IMAGESMODEL_H
