#include "settingsmodel.h"

#include <QAbstractListModel>

SettingsModel::SettingsModel(QObject *parent) :
  QAbstractListModel(parent)
{
    hash.insert(Qt::UserRole ,QByteArray("title"));
    hash.insert(Qt::UserRole+1 ,QByteArray("category"));
    hash.insert(Qt::UserRole+2 ,QByteArray("path"));
}


void SettingsModel::fill()
{
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
