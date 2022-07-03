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

#include "mobilesettingsplugin.h"

MobileSettingsPlugin::MobileSettingsPlugin(QObject *parent) :
    m_enabled(false)
  , m_qOfonoManager(new QOfonoManager())
{
    if(m_qOfonoManager->modems().count() > 0) {
        m_enabled = true;
    }

    connect(m_qOfonoManager, &QOfonoManager::modemsChanged, this, &MobileSettingsPlugin::modemsChanged);
}

bool MobileSettingsPlugin::enabled()
{
    return m_enabled;
}

void MobileSettingsPlugin::modemsChanged(const QStringList &modems)
{
    bool newEnabled;
    if(modems.count() > 0) {
        newEnabled = true;
    } else {
        newEnabled = false;
    }

    if(newEnabled != m_enabled) {
        m_enabled = newEnabled;
        emit pluginChanged(id());
    }
}
