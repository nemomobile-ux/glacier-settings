#ifndef SETTINGSMODEL_H
#define SETTINGSMODEL_H

#include <QObject>
#include <QAbstractListModel>

class SettingsModel : public QAbstractListModel
{
    Q_OBJECT
    struct settingsItem{
        QString title;
        QString category;
        QString path;
    };

public:
    explicit SettingsModel(QString pluginsDir, QObject *parent = 0);
    void init();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const {return hash;}

    bool insertRows(int position, int rows, settingsItem &item, const QModelIndex &index = QModelIndex());
    bool removeRows(int position, int rows, const QModelIndex &index = QModelIndex());

    QList<settingsItem> settingsList;

signals:
    void settingsModelUpdate();

public slots:
    void addItem(settingsItem item);
    settingsItem get(int idx){return settingsList[idx];}
    void remove(int idx);

private:
    QHash<int,QByteArray> hash;
    QString m_pluginsDir;
    bool loadConfig(QString configFileName);
};

#endif // SETTINGSMODEL_H
