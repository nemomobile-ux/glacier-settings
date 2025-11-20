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

#include "datetimesettingsplugin.h"

DateTimeSettingsPlugin::DateTimeSettingsPlugin(QObject* parent)
    : m_enabled(false)
{
    if (!m_timed.settings_changed_connect(this, SLOT(onTimedSignal(const Maemo::Timed::WallClock::Info&, bool)))) {
        qWarning("Connection to timed signal failed: '%s'", Maemo::Timed::bus().lastError().message().toStdString().c_str());
    }
}

void DateTimeSettingsPlugin::onTimedSignal(const Maemo::Timed::WallClock::Info& info, bool time_changed)
{
    if (!m_enabled) {
        m_enabled = true;
        emit pluginChanged(id());
    }
}
