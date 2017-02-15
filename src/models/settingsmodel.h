#ifndef SETTINGSMODEL_H
#define SETTINGSMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QJsonObject>

class SettingsModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)

public:
    explicit SettingsModel(QObject *parent = 0);
    void init();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    QJsonObject data(const QModelIndex &index) const;
    QHash<int, QByteArray> roleNames() const {return hash;}

    bool insertRows(int position, int rows, QJsonObject &item, const QModelIndex &index = QModelIndex());
    bool removeRows(int position, int rows, const QModelIndex &index = QModelIndex());

    QList<QJsonObject> settingsList;

    QString path(){return m_pluginsDir;}
    void setPath(QString path);

    static int compareCategories(QString leftCategory, QString rightCategory);

    const static QStringList defaultCategories;

signals:
    void pathChanged();

public slots:
    void addItem(QJsonObject item);
    QJsonObject get(int idx){return settingsList[idx];}
    void remove(int idx);

private:
    QHash<int,QByteArray> hash;
    QString m_pluginsDir;
    QStringList m_roleNames;
    bool loadConfig(QString configFileName);
};

#endif // SETTINGSMODEL_H
