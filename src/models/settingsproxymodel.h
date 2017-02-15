#ifndef SETTINGSPROXYMODEL_H
#define SETTINGSPROXYMODEL_H

#include <QObject>
#include <QSortFilterProxyModel>

#include "settingsmodel.h"

class SettingsProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(QObject* model READ model WRITE setModel NOTIFY modelChanged)
public:
    explicit SettingsProxyModel(QObject *parent = 0);
    QObject* model();
    void setModel(QObject* model);

signals:
    void modelChanged();

private:

protected:
    bool lessThan(const QModelIndex &left, const QModelIndex &right) const;
};

#endif // SETTINGSPROXYMODEL_H
