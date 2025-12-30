/*
 * Copyright (C) 2017-2025 Chupligin Sergey <neochapay@gmail.com>
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

#ifndef SATELLITEMODEL_H
#define SATELLITEMODEL_H

#include <QAbstractListModel>
#include <QSet>
#include <QTimer>
#include <QtPositioning/QGeoSatelliteInfoSource>
#include <QtQml/QQmlParserStatus>
#include <QtQml/qqml.h>

#include "glaciersettings_global.h"

class GLACIERSETTINGS_EXPORT SatelliteModel : public QAbstractListModel, public QQmlParserStatus {
    Q_OBJECT
    Q_PROPERTY(bool isValid READ isValid NOTIFY isValidChanged FINAL)
    Q_PROPERTY(bool running READ running WRITE setRunning NOTIFY runningChanged)
    Q_PROPERTY(bool satelliteInfoAvailable READ canProvideSatelliteInfo NOTIFY canProvideSatelliteInfoChanged)
    Q_PROPERTY(int entryCount READ entryCount NOTIFY entryCountChanged)
    Q_PROPERTY(bool singleRequestMode READ isSingleRequest WRITE setSingleRequest NOTIFY singleRequestChanged)
    Q_PROPERTY(int usedSattelites READ usedSattelites NOTIFY usedSattelitesChanged)
    Q_PROPERTY(int avaiableSattelites READ avaiableSattelites NOTIFY avaiableSattelitesChanged)
    Q_INTERFACES(QQmlParserStatus)
public:
    explicit SatelliteModel(QObject* parent = 0);
    virtual ~SatelliteModel();

    enum {
        IdentifierRole = Qt::UserRole + 1,
        InUseRole,
        SignalStrengthRole,
        ElevationRole,
        AzimuthRole,
        SatelliteSystem
    };

    // From QAbstractListModel
    int rowCount(const QModelIndex& parent) const;
    QVariant data(const QModelIndex& index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    // From QQmlParserStatus
    void classBegin() { }
    void componentComplete();

    bool running() const;
    void setRunning(bool isActive);

    bool isSingleRequest() const;
    void setSingleRequest(bool single);

    int entryCount() const;

    bool canProvideSatelliteInfo() const;

    int usedSattelites() { return satellitesInUse.count(); }
    int avaiableSattelites() { return knownSatellites.count(); }

    bool isValid() const;

signals:
    void runningChanged();
    void entryCountChanged();
    void errorFound(int code);
    void canProvideSatelliteInfoChanged();
    void singleRequestChanged();
    void usedSattelitesChanged();
    void avaiableSattelitesChanged();

    void isValidChanged();

public slots:
    void clearModel();
    void updateDemoData();

private slots:
    void error(QGeoSatelliteInfoSource::Error error);
    void satellitesInViewUpdated(const QList<QGeoSatelliteInfo>& infos);
    void satellitesInUseUpdated(const QList<QGeoSatelliteInfo>& infos);

private:
    QGeoSatelliteInfoSource* m_source;
    bool m_componentCompleted;
    bool m_running;
    bool m_runningRequested;
    QList<QGeoSatelliteInfo> knownSatellites;
    QSet<int> knownSatelliteIds;
    QSet<int> satellitesInUse;
    bool isSingle;
    bool singleRequestServed;
    bool m_isValid;
};

#endif // SATELLITEMODEL_H
