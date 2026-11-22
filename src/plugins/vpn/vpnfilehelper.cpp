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

#include "vpnfilehelper.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QRegularExpression>
#include <QStandardPaths>
#include <QUrl>

VpnFileHelper::VpnFileHelper(QObject* parent)
    : QObject(parent)
{
}

QString VpnFileHelper::writeEmbeddedFile(const QString& baseName, const QString& suffix, const QString& content)
{
    QString dirPath = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation)
        + QStringLiteral("/glacier-settings/vpn");
    QDir dir;
    if (!dir.mkpath(dirPath)) {
        return QString();
    }

    QString filePath = dirPath + QLatin1Char('/') + baseName + QLatin1Char('.') + suffix;
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate | QIODevice::Text)) {
        return QString();
    }
    file.write(content.toUtf8());
    file.close();
    return filePath;
}

QVariantMap VpnFileHelper::importOpenVpn(const QString& fileUrl)
{
    m_error.clear();

    QString path = fileUrl;
    QUrl url(fileUrl);
    if (url.isLocalFile()) {
        path = url.toLocalFile();
    }

    QFile file(path);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        m_error = QStringLiteral("Cannot open file");
        return QVariantMap();
    }

    const QString content = QString::fromUtf8(file.readAll());
    file.close();

    const QString baseName = QFileInfo(path).completeBaseName();
    const QStringList lines = content.split(QRegularExpression(QStringLiteral("\\r?\\n")));

    QVariantMap props;
    QVariantMap provider;
    QStringList extraOptions;
    QMap<QString, QString> embedded;
    QString currentEmbed;
    QStringList embeddedContent;
    QString proto = QStringLiteral("udp");
    QString port = QStringLiteral("1194");

    for (const QString& rawLine : lines) {
        if (!currentEmbed.isEmpty()) {
            if (rawLine.contains(QRegularExpression(QStringLiteral("^\\s*</([^>]+)>")))) {
                embedded.insert(currentEmbed, embeddedContent.join(QLatin1Char('\n')));
                currentEmbed.clear();
                embeddedContent.clear();
            } else {
                embeddedContent.append(rawLine);
            }
            continue;
        }

        const QString trimmed = rawLine.trimmed();
        if (trimmed.isEmpty() || trimmed.startsWith(QLatin1Char('#')) || trimmed.startsWith(QLatin1Char(';'))) {
            continue;
        }

        QRegularExpressionMatch embedMatch = QRegularExpression(QStringLiteral("^\\s*<([^/>]+)>")).match(rawLine);
        if (embedMatch.hasMatch()) {
            currentEmbed = embedMatch.captured(1).trimmed();
            embeddedContent.clear();
            continue;
        }

        const QStringList parts = trimmed.split(QRegularExpression(QStringLiteral("\\s+")));
        if (parts.isEmpty()) {
            continue;
        }
        const QString key = parts.at(0);
        const QString value = parts.size() > 1 ? parts.mid(1).join(QLatin1Char(' ')) : QString();

        if (key == QLatin1String("remote")) {
            if (parts.size() > 1)
                props.insert(QStringLiteral("Host"), parts.at(1));
            if (parts.size() > 2)
                port = parts.at(2);
            if (parts.size() > 3)
                proto = parts.at(3);
        } else if (key == QLatin1String("proto")) {
            proto = value;
        } else if (key == QLatin1String("port")) {
            port = value;
        } else if (key == QLatin1String("dev")) {
            provider.insert(QStringLiteral("DeviceType"), value.contains(QLatin1String("tap")) ? QStringLiteral("tap") : QStringLiteral("tun"));
        } else if (key == QLatin1String("remote-cert-tls") && value == QLatin1String("server")) {
            extraOptions.append(QStringLiteral("--remote-cert-tls server"));
        } else if (key == QLatin1String("comp-lzo")) {
            extraOptions.append(value.isEmpty() ? QStringLiteral("--comp-lzo") : QStringLiteral("--comp-lzo ") + value);
        } else if (key == QLatin1String("auth-user-pass")) {
            provider.insert(QStringLiteral("AuthUserPass"), true);
        } else if (key == QLatin1String("cipher")) {
            provider.insert(QStringLiteral("OpenVPN.Cipher"), value);
        } else if (key == QLatin1String("auth")) {
            provider.insert(QStringLiteral("OpenVPN.Auth"), value);
        } else if (key == QLatin1String("ca")) {
            provider.insert(QStringLiteral("OpenVPN.CACert"), value);
        } else if (key == QLatin1String("cert")) {
            provider.insert(QStringLiteral("OpenVPN.Cert"), value);
        } else if (key == QLatin1String("key")) {
            provider.insert(QStringLiteral("OpenVPN.Key"), value);
        }
    }

    if (!props.contains(QStringLiteral("Host"))) {
        m_error = QStringLiteral("No remote host found in OpenVPN config");
        return QVariantMap();
    }

    const QString host = props.value(QStringLiteral("Host")).toString();
    props.insert(QStringLiteral("Type"), QStringLiteral("openvpn"));
    props.insert(QStringLiteral("Name"), baseName.isEmpty() ? host : baseName);
    props.insert(QStringLiteral("Domain"), QStringLiteral("local"));

    provider.insert(QStringLiteral("Host"), host);
    provider.insert(QStringLiteral("OpenVPN.Port"), port);
    provider.insert(QStringLiteral("OpenVPN.Proto"), proto);
    if (!provider.contains(QStringLiteral("DeviceType"))) {
        provider.insert(QStringLiteral("DeviceType"), QStringLiteral("tun"));
    }

    if (embedded.contains(QStringLiteral("ca"))) {
        QString p = writeEmbeddedFile(baseName, QStringLiteral("ca.crt"), embedded.value(QStringLiteral("ca")));
        if (!p.isEmpty())
            provider.insert(QStringLiteral("OpenVPN.CACert"), p);
    }
    if (embedded.contains(QStringLiteral("cert"))) {
        QString p = writeEmbeddedFile(baseName, QStringLiteral("client.crt"), embedded.value(QStringLiteral("cert")));
        if (!p.isEmpty())
            provider.insert(QStringLiteral("OpenVPN.Cert"), p);
    }
    if (embedded.contains(QStringLiteral("key"))) {
        QString p = writeEmbeddedFile(baseName, QStringLiteral("client.key"), embedded.value(QStringLiteral("key")));
        if (!p.isEmpty())
            provider.insert(QStringLiteral("OpenVPN.Key"), p);
    }

    if (!extraOptions.isEmpty()) {
        QString configPath = writeEmbeddedFile(baseName, QStringLiteral("conf"), extraOptions.join(QLatin1Char('\n')) + QLatin1Char('\n'));
        if (!configPath.isEmpty()) {
            provider.insert(QStringLiteral("OpenVPN.ConfigFile"), configPath);
        }
    }

    props.insert(QStringLiteral("Provider"), provider);
    return props;
}
