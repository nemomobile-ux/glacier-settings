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
#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif
#include <QtGui/QGuiApplication>

#include <QCoreApplication>
#include <QDebug>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScreen>
#include <QtCore/QString>
#include <QtQml>
#include <QtQuick/QQuickView>
#include <QUrl>

#include <cstdlib>

#include <glacierapp.h>

#include "satellitemodel.h"
#include "settingsmodel.h"
#include "themesmodel.h"
#include "timezonesmodel.h"

Q_DECL_EXPORT int main(int argc, char* argv[])
{
    Q_INIT_RESOURCE(glacier_settings);
    setenv("QT_QUICK_CONTROLS_STYLE", "Nemo", 1);

    QGuiApplication* app = GlacierApp::app(argc, argv);
    app->setOrganizationName("NemoMobile");
    QCoreApplication::setApplicationName(QStringLiteral("glacier-settings"));

    QQmlApplicationEngine* engine = GlacierApp::engine(app);

    qmlRegisterType<SettingsModel>("org.nemomobile.glacier.settings", 1, 0, "SettingsModel");
    qmlRegisterType<SatelliteModel>("org.nemomobile.glacier.settings", 1, 0, "SatelliteModel");
    qmlRegisterType<TimeZonesModel>("org.nemomobile.glacier.settings", 1, 0, "TimeZonesModel");
    qmlRegisterType<ThemesModel>("org.nemomobile.glacier.settings", 1, 0, "ThemesModel");

    engine->load(QUrl(QStringLiteral("qrc:/glacier-settings.qml")));
    if (engine->rootObjects().isEmpty()) {
        qCritical() << "Failed to load main QML from resources";
        std::_Exit(-1);
    }

    QQuickWindow* window = qobject_cast<QQuickWindow*>(engine->rootObjects().constFirst());
    if (!window) {
        qCritical() << "Root object is not a QQuickWindow";
        std::_Exit(-1);
    }

    engine->rootContext()->setContextProperty(QStringLiteral("__window"), window);
    window->setTitle(QObject::tr("Settings"));
    window->setIcon(QIcon(QStringLiteral("/usr/share/glacier-settings/glacier-settings.png")));
    window->show();

    return app->exec();
}
