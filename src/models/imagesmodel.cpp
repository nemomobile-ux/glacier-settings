#include "imagesmodel.h"

#include <QAbstractListModel>
#include <QDir>

ImagesModel::ImagesModel(QObject *parent) :
    QAbstractListModel(parent)
{
    hash.insert(Qt::UserRole ,QByteArray("path"));
    m_reqursive = false;
}


void ImagesModel::setPath(QString path)
{
    if(m_imagesDir != path)
    {
        m_imagesDir = path;
        init();
        emit pathChanged();
    }
}

void ImagesModel::setReqursive(bool reqursive)
{
    m_reqursive = reqursive;
    emit reqursiveChanged();
}

void ImagesModel::init()
{
    QDir imagesPathDir = QDir(m_imagesDir);
    imagesPathDir.setNameFilters(QStringList("*.png, *.jpg, *.jpeg"));

    const QFileInfoList &list = imagesPathDir.entryInfoList();
    QListIterator<QFileInfo> it (list);

    while (it.hasNext ()) {
        const QFileInfo &fileInfo = it.next ();
        imageList.append(fileInfo.absoluteFilePath());
    }
}

int ImagesModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return imageList.count();
}

QVariant ImagesModel::data(const QModelIndex &index, int role) const
{
    Q_UNUSED(role);
    if (!index.isValid())
        return QVariant();

    if (index.row() >= imageList.size())
        return QVariant();

    QString item = imageList.at(index.row());

    if(role == Qt::UserRole)
    {
        return item;
    }

    return QVariant();
}
