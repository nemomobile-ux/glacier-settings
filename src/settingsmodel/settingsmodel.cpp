#include "settingsmodel.h"

#include <QAbstractListModel>
#include <QDebug>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>

SettingsModel::SettingsModel(QString pluginsDir, QObject *parent) :
    QAbstractListModel(parent)
{
    hash.insert(Qt::UserRole ,QByteArray("title"));
    hash.insert(Qt::UserRole+1 ,QByteArray("category"));
    hash.insert(Qt::UserRole+2 ,QByteArray("path"));

    m_pluginsDir = pluginsDir;
}


void SettingsModel::init()
{
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

    settingsItem item;
    item.title = configObject.value("title").toString();
    item.category = configObject.value("category").toString();
    item.path = configObject.value("path").toString();

    if(item.title.length() > 0 and item.category.length() > 0 and item.path.length() > 0)
    {
        addItem(item);
        return true;
    }
    else
    {
        return false;
    }
}

void SettingsModel::addItem(settingsItem item)
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

    settingsItem item = settingsList.at(index.row());

    if(role == Qt::UserRole)
    {
        return item.title;
    }
    else if(role == Qt::UserRole+1)
    {
        return item.category;
    }
    else if(role == Qt::UserRole+2)
    {
        return item.path;
    }
    return QVariant();
}

bool SettingsModel::insertRows(int position, int rows, settingsItem &item, const QModelIndex &parent)
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
