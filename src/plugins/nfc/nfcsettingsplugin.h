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

#ifndef NFCSETTINGSPLUGIN_H
#define NFCSETTINGSPLUGIN_H

#include "glaciersettingsplugin.h"

class NfcSettingsPlugin : public GlacierSettingsPlugin {
    Q_OBJECT
    Q_INTERFACES(GlacierSettingsPlugin)
    Q_PLUGIN_METADATA(IID "Glacier.SettingsPlugin")

public:
    explicit NfcSettingsPlugin(QObject* parent = nullptr);
    PluginCategory category() const { return PluginCategory::Network; }
    QString id() const { return "nfc"; }
    QString title() const { return tr("NFC"); }
    QString description() const { return "Near field communication"; }
    QString qmlPath() const { return "/usr/share/glacier-settings/plugins/nfc/nfc.qml"; }
    QString icon() const { return "/usr/share/glacier-settings/plugins/nfc/nfc.svg"; }
    bool enabled() { return m_enabled; };

private:
    bool m_enabled;
};

#endif // NFCSETTINGSPLUGIN_H
