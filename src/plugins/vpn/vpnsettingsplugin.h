/*
 * Copyright (C) 2026 Chupligin Sergey <neochapay@gmail.com>
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

#ifndef USBSETTINGSPLUGIN_H
#define USBSETTINGSPLUGIN_H

#include "glaciersettingsplugin.h"

class VpnSettingsPlugin : public GlacierSettingsPlugin {
    Q_OBJECT
    Q_INTERFACES(GlacierSettingsPlugin)
    Q_PLUGIN_METADATA(IID "Glacier.SettingsPlugin")
public:
    VpnSettingsPlugin(QObject* parent = nullptr);
    PluginCategory category() const { return PluginCategory::Network; }
    QString id() const { return "vpn"; }
    QString title() const { return tr("VPN"); }
    QString description() const { return tr("Manage vpn settings"); }
    QString qmlPath() const { return "/usr/share/glacier-settings/plugins/vpn/vpn.qml"; }
    QString icon() const { return "/usr/share/glacier-settings/plugins/vpn/vpn.svg"; }
    bool enabled() { return true; }
};

#endif // VPNSETTINGSPLUGIN_H
