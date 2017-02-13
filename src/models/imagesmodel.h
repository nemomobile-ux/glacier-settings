#ifndef IMAGESMODEL_H
#define IMAGESMODEL_H

#include <QObject>
#include <QAbstractListModel>

class ImagesModel:public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)
    Q_PROPERTY(bool reqursive READ reqursive WRITE setReqursive NOTIFY reqursiveChanged)

public:
    explicit ImagesModel(QObject *parent);
    void init();

    int rowCount(const QModelIndex &parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const {return hash;}

    QList<QString> imageList;

    QString path(){return m_imagesDir;}
    void setPath(QString path);

    bool reqursive(){return m_reqursive;}
    void setReqursive(bool reqursive);

signals:
    void pathChanged();
    void reqursiveChanged();

private:
    QHash<int,QByteArray> hash;
    QString m_imagesDir;
    bool m_reqursive;
};

#endif // IMAGESMODEL_H
