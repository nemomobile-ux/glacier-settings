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

#ifndef KEYPADSETTINGSPLUGIN_H
#define KEYPADSETTINGSPLUGIN_H

#include "glaciersettingsplugin.h"

class KeypadSettingsPlugin : public GlacierSettingsPlugin {
    Q_OBJECT
    Q_INTERFACES(GlacierSettingsPlugin)
    Q_PLUGIN_METADATA(IID "Glacier.SettingsPlugin")

public:
    explicit KeypadSettingsPlugin(QObject* parent = nullptr);
    PluginCategory category() const { return PluginCategory::Personalization; }
    QString id() const { return "keypad"; }
    QString title() const { return tr("Keypad"); }
    QString description() const { return tr("Hardware keypad backlight settings"); }
    QString qmlPath() const { return "/usr/share/glacier-settings/plugins/keypad/keypad.qml"; }
    QString icon() const { return "/usr/share/glacier-settings/plugins/keypad/keypad.svg"; }
    bool enabled() { return m_enabled; }

private:
    bool m_enabled;
};

#endif // KEYPADSETTINGSPLUGIN_H
