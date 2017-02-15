#include "settingsproxymodel.h"
#include "settingsmodel.h"

#include <QSortFilterProxyModel>
#include <QDebug>

SettingsProxyModel::SettingsProxyModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{
    setSortRole(Qt::UserRole);
    setDynamicSortFilter(true);
}

QObject *SettingsProxyModel::model()
{
    return sourceModel();
}

void SettingsProxyModel::setModel(QObject *model)
{
    if(sourceModel() != model)
    {
        setSourceModel(qobject_cast<QAbstractListModel*>(model));
        emit modelChanged();

        sort(0);
    }
}

bool SettingsProxyModel::lessThan(const QModelIndex &left, const QModelIndex &right) const
{
    QJsonObject leftData = qobject_cast<SettingsModel*>(sourceModel())->data(left);
    QJsonObject rightData = qobject_cast<SettingsModel*>(sourceModel())->data(right);

    QString leftCategory = leftData.value("category").toString();
    QString rightCategory = rightData.value("category").toString();

    if(leftCategory == rightCategory)
    {
        QString leftName = leftData.value("name").toString();
        QString rightName = rightData.value("name").toString();

        return leftName > rightName;
    }
    return SettingsModel::compareCategories(leftCategory,rightCategory) > 0;
}


