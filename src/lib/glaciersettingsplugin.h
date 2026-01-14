/*
 * Copyright (C) 2022-2026 Chupligin Sergey <neochapay@gmail.com>
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

#ifndef GLACIERSETTINGSPLUGIN_H
#define GLACIERSETTINGSPLUGIN_H

#include "glaciersettings_global.h"
#include <QObject>

class GLACIERSETTINGS_EXPORT GlacierSettingsPlugin : public QObject {
    Q_OBJECT
    Q_DISABLE_COPY(GlacierSettingsPlugin)

public:
    explicit GlacierSettingsPlugin(QObject* parent = nullptr)
        : QObject(parent) {}

    enum PluginCategory : quint8 {
        Personalization,
        Network,
        Security,
        Development,
        Info,
        Other = 255
    };
    Q_ENUM(PluginCategory)

    ~GlacierSettingsPlugin() override = default;
    virtual PluginCategory category() const = 0;
    virtual QString id() const = 0;
    virtual QString title() const = 0;
    virtual QString description() const = 0;
    virtual QString qmlPath() const = 0;
    virtual QString icon() const = 0;
    virtual bool enabled() = 0;

signals:
    void pluginChanged(QString id);
};

Q_DECLARE_INTERFACE(GlacierSettingsPlugin, "Glacier.SettingsPlugin/1.0")
#endif // GLACIERSETTINGSPLUGIN_H
