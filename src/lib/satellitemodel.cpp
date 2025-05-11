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

#include "satellitemodel.h"
#include "logging.h"
#include <QFile>
#include <QTimer>

SatelliteModel::SatelliteModel(QObject* parent)
    : QAbstractListModel(parent)
    , source(0)
    , m_componentCompleted(false)
    , m_running(false)
    , m_runningRequested(false)
    , isSingle(false)
    , singleRequestServed(false)
    , m_isValid(false)
{
    source = QGeoSatelliteInfoSource::createDefaultSource(this);
    QStringList aS = QGeoSatelliteInfoSource::availableSources();
    for (int i = 0; i < aS.size(); ++i) {
        qCDebug(lcGlacierSettingsCoreLog) << " - " << aS[i];
    }

    if (source) {
        m_isValid = true;
    } else {
        qCDebug(lcGlacierSettingsCoreLog) << "No satellite data source found. Changing to demo mode.";
    }

    source->setUpdateInterval(3000);
    connect(source, SIGNAL(satellitesInViewUpdated(QList<QGeoSatelliteInfo>)),
        this, SLOT(satellitesInViewUpdated(QList<QGeoSatelliteInfo>)));
    connect(source, SIGNAL(satellitesInUseUpdated(QList<QGeoSatelliteInfo>)),
        this, SLOT(satellitesInUseUpdated(QList<QGeoSatelliteInfo>)));
    connect(source, SIGNAL(error(QGeoSatelliteInfoSource::Error)),
        this, SLOT(error(QGeoSatelliteInfoSource::Error)));
    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(updateDemoData()));
    timer->start(3000);
}

int SatelliteModel::rowCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent);
    if (!m_isValid)
        return 0;

    return knownSatellites.count();
}

QVariant SatelliteModel::data(const QModelIndex& index, int role) const
{
    if (!m_isValid)
        return QVariant();

    if (!index.isValid() || index.row() < 0)
        return QVariant();

    if (index.row() >= knownSatellites.count()) {
        qCWarning(lcGlacierSettingsCoreLog) << "SatelliteModel: Index out of bound";
        return QVariant();
    }

    const QGeoSatelliteInfo& info = knownSatellites.at(index.row());
    switch (role) {
    case IdentifierRole:
        return info.satelliteIdentifier();
    case InUseRole:
        return satellitesInUse.contains(info.satelliteIdentifier());
    case SignalStrengthRole:
        return info.signalStrength();
    case ElevationRole:
        if (!info.hasAttribute(QGeoSatelliteInfo::Elevation))
            return QVariant();
        return info.attribute(QGeoSatelliteInfo::Elevation);
    case AzimuthRole:
        if (!info.hasAttribute(QGeoSatelliteInfo::Azimuth))
            return QVariant();
        return info.attribute(QGeoSatelliteInfo::Azimuth);
    case SatelliteSystem:
        if (info.satelliteSystem() == QGeoSatelliteInfo::GPS) {
            return QVariant("GPS");
        }
        if (info.satelliteSystem() == QGeoSatelliteInfo::GLONASS) {
            return QVariant("GNS");
        }
        return QVariant("UNK");
    default:
        break;
    }

    return QVariant();
}

QHash<int, QByteArray> SatelliteModel::roleNames() const
{
    QHash<int, QByteArray> roleNames;
    roleNames.insert(IdentifierRole, "satelliteIdentifier");
    roleNames.insert(InUseRole, "isInUse");
    roleNames.insert(SignalStrengthRole, "signalStrength");
    roleNames.insert(ElevationRole, "elevation");
    roleNames.insert(AzimuthRole, "azimuth");
    roleNames.insert(SatelliteSystem, "satelliteSystem");
    return roleNames;
}

void SatelliteModel::componentComplete()
{
    m_componentCompleted = true;
    if (m_runningRequested)
        setRunning(true);
}

bool SatelliteModel::running() const
{
    return m_running;
}

bool SatelliteModel::isSingleRequest() const
{
    return isSingle;
}

void SatelliteModel::setSingleRequest(bool single)
{
    if (running()) {
        qCWarning(lcGlacierSettingsCoreLog) << "Cannot change single request mode while running";
        return;
    }

    if (single != isSingle) { // flag changed
        isSingle = single;
        emit singleRequestChanged();
    }
}

void SatelliteModel::setRunning(bool isActive)
{
    if (m_isValid)
        return;

    if (!m_componentCompleted) {
        m_runningRequested = isActive;
        return;
    }

    if (m_running == isActive)
        return;

    m_running = isActive;

    if (m_running) {
        clearModel();
        if (isSingleRequest())
            source->requestUpdate(10000);
        else
            source->startUpdates();
    } else {
        if (!isSingleRequest())
            source->stopUpdates();
    }

    Q_EMIT runningChanged();
}

int SatelliteModel::entryCount() const
{
    return knownSatellites.count();
}

bool SatelliteModel::canProvideSatelliteInfo() const
{
    return !m_isValid;
}

void SatelliteModel::clearModel()
{
    beginResetModel();
    knownSatelliteIds.clear();
    knownSatellites.clear();
    satellitesInUse.clear();
    endResetModel();
}

void SatelliteModel::updateDemoData()
{
    static bool flag = true;
    QList<QGeoSatelliteInfo> satellites;
    if (flag) {
        for (int i = 0; i < 5; i++) {
            QGeoSatelliteInfo info;
            info.setSatelliteIdentifier(i);
            info.setSignalStrength(20 + 20 * i);
            satellites.append(info);
        }
    } else {
        for (int i = 0; i < 9; i++) {
            QGeoSatelliteInfo info;
            info.setSatelliteIdentifier(i * 2);
            info.setSignalStrength(20 + 10 * i);
            satellites.append(info);
        }
    }

    satellitesInViewUpdated(satellites);
    flag ? satellitesInUseUpdated(QList<QGeoSatelliteInfo>() << satellites.at(2))
         : satellitesInUseUpdated(QList<QGeoSatelliteInfo>() << satellites.at(3));
    flag = !flag;

    emit errorFound(flag);

    if (isSingleRequest() && !singleRequestServed) {
        singleRequestServed = true;
        setRunning(false);
    }
}

void SatelliteModel::error(QGeoSatelliteInfoSource::Error error)
{
    emit errorFound((int)error);
}

QT_BEGIN_NAMESPACE
inline bool operator<(const QGeoSatelliteInfo& a, const QGeoSatelliteInfo& b)
{
    return a.satelliteIdentifier() < b.satelliteIdentifier();
}
QT_END_NAMESPACE

void SatelliteModel::satellitesInViewUpdated(const QList<QGeoSatelliteInfo>& infos)
{
    if (!running())
        return;

    int oldEntryCount = knownSatellites.count();

    QSet<int> satelliteIdsInUpdate;
    foreach (const QGeoSatelliteInfo& info, infos) {
        if (info.signalStrength() > 0) {
            satelliteIdsInUpdate.insert(info.satelliteIdentifier());
        }
    }

    QSet<int> toBeRemoved = knownSatelliteIds - satelliteIdsInUpdate;

           // We reset the model as in reality just about all entry values change
           // and there are generally a lot of inserts and removals each time
           // Hence we don't bother with complex model update logic beyond resetModel()
    beginResetModel();

    knownSatellites = infos;
    emit avaiableSattelitesChanged();

           // sort them for presentation purposes
    std::sort(knownSatellites.begin(), knownSatellites.end());

           // remove old "InUse" data
           // new satellites are by default not in "InUse"
           // existing satellites keep their "inUse" state
    satellitesInUse -= toBeRemoved;

    knownSatelliteIds = satelliteIdsInUpdate;
    endResetModel();

    if (oldEntryCount != knownSatellites.count())
        emit entryCountChanged();
}

void SatelliteModel::satellitesInUseUpdated(const QList<QGeoSatelliteInfo>& infos)
{
    if (!running())
        return;

    beginResetModel();

    satellitesInUse.clear();
    foreach (const QGeoSatelliteInfo& info, infos)
        satellitesInUse.insert(info.satelliteIdentifier());

    emit usedSattelitesChanged();
    endResetModel();
}

bool SatelliteModel::isValid() const
{
    return m_isValid;
}
