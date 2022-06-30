/*
 * Copyright (C) 2022 Chupligin Sergey <neochapay@gmail.com>
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

#include <QObject>
#include "glaciersettings_global.h"

class GLACIERSETTINGS_EXPORT GlacierSettingsPlugin : public QObject
{
    Q_OBJECT
public:
    enum PluginCategory{
        Personalization,
        Network,
        Security,
        Development,
        Info,
        Other = 255
    };
    Q_ENUM(PluginCategory)

    virtual ~GlacierSettingsPlugin() {}
    virtual PluginCategory category() = 0;
    virtual QString title() = 0;
    virtual QString description() = 0;
    virtual QString qmlPath() = 0;
    virtual QString icon() = 0;
    virtual bool enabled() = 0;

signals:
    void pluginChanged(QString id);
};

Q_DECLARE_INTERFACE(GlacierSettingsPlugin, "Glacier.SettingsPlugin")

#endif // GLACIERSETTINGSPLUGIN_H
