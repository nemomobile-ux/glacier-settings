#include "settingsmodel.h"

#include <QAbstractListModel>
#include <QDebug>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>

/*
 * Orgeding categoty DRAFT
 *
 * Settings part:
 * Personalization
 *  - Display
 *  - Sounds
 * Network
 *  - Cellural
 *  - WiFi
 *  - NFC
 * Development
 *  - Devmode
 * Info
 *  - About
 * Other
*/

const QStringList SettingsModel::defaultCategories = {
    "Personalization"
    , "Network"
    , "Development"
    , "Info"
    , "Other"
};

SettingsModel::SettingsModel(QObject *parent) :
    QAbstractListModel(parent)
{
    m_roleNames << "title";
    m_roleNames << "category";
    m_roleNames << "path";

    for (const QString &role : m_roleNames) {
        hash.insert(Qt::UserRole+hash.count() ,role.toLatin1());
    }
}


void SettingsModel::setPath(QString path)
{
    if(m_pluginsDir != path)
    {
        m_pluginsDir = path;
        init();

        emit pathChanged();
    }
}

int SettingsModel::compareCategories(QString leftCategory, QString rightCategory)
{
    if(leftCategory == rightCategory)
    {
        return 0;
    }
    else if(defaultCategories.contains(leftCategory) && defaultCategories.contains(rightCategory))
    {
        return defaultCategories.indexOf(leftCategory)-defaultCategories.indexOf(rightCategory);
    }
    else if(defaultCategories.contains(leftCategory))
    {
        return -1;
    }
    else
    {
        return 1;
    }

}

void SettingsModel::init()
{
    settingsList.clear();

    QDir pluginsPath = QDir(m_pluginsDir);
    qDebug() << "Start scan plugins dir " << pluginsPath.absolutePath();
    pluginsPath.setNameFilters(QStringList("*.json"));

    const QFileInfoList &list = pluginsPath.entryInfoList();
    QListIterator<QFileInfo> it (list);

    while (it.hasNext ()) {
        const QFileInfo &fileInfo = it.next ();
        qDebug() << "Load " << fileInfo.fileName();
        if(!loadConfig(m_pluginsDir+fileInfo.fileName()))
        {
            qWarning() << "Wrong plugin config";
        }
    }

    if(rowCount() == 0)
    {
        qWarning() << "Plugins directory is empty";
    }
}

bool SettingsModel::loadConfig(QString configFileName)
{
    QFile pluginConfig(configFileName);
    pluginConfig.open(QIODevice::ReadOnly | QIODevice::Text);
    QJsonDocument config = QJsonDocument::fromJson(pluginConfig.readAll());
    QJsonObject configObject = config.object();

    foreach (QString role, configObject.keys()) {
        if (!m_roleNames.contains(role)) {
            m_roleNames << role;
            hash.insert(Qt::UserRole+hash.count() ,role.toLatin1());
        }
    }

    if(configObject.contains("title") && configObject.contains("category") && configObject.contains("path"))
    {
        addItem(configObject);
        return true;
    }
    else
    {
        return false;
    }
}

void SettingsModel::addItem(QJsonObject item)
{

    int count = settingsList.size();
    insertRows(count,1,item);
}


int SettingsModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return settingsList.count();
}

QVariant SettingsModel::data(const QModelIndex &index, int role) const
{
    Q_UNUSED(role);
    if (!index.isValid())
        return QVariant();

    if (index.row() >= settingsList.size())
        return QVariant();

    QJsonObject item = settingsList.at(index.row());

    if(role == Qt::UserRole)
    {
        return item.value("title").toString();
    }
    else if(role == Qt::UserRole+1)
    {
        return item.value("category").toString();
    }
    else if(role == Qt::UserRole+2)
    {
        return item.value("path").toString();
    }
    return QVariant();
}

QJsonObject SettingsModel::data(const QModelIndex &index) const
{
    if (!index.isValid())
        return QJsonObject();

    if (index.row() >= settingsList.size())
        return QJsonObject();

    return settingsList.at(index.row());
}

bool SettingsModel::insertRows(int position, int rows, QJsonObject &item, const QModelIndex &parent)
{
    Q_UNUSED(parent);
    beginInsertRows(QModelIndex(), position, position+rows-1);
    for (int row = 0; row < rows; ++row) {
        settingsList.insert(position, item);
    }
    endInsertRows();
    return true;
}

bool SettingsModel::removeRows(int position, int rows, const QModelIndex &index)
{
    Q_UNUSED(index);
    beginRemoveRows(QModelIndex(), position, position+rows-1);
    for (int row = 0; row < rows; ++row) {
        settingsList.removeAt(position);
    }
    endRemoveRows();
    return true;
}

void SettingsModel::remove(int idx)
{
    this->removeRows(idx,1);
}
