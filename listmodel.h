#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QObject>
#include<QAbstractListModel>
#include<QStringList>

class listModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit listModel(QStringList list=QStringList());
    

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
private:
    QStringList mainList;
};

#endif // LISTMODEL_H
