#include "listmodel.h"

listModel::listModel(QStringList list):mainList(list){}

int listModel::rowCount(const QModelIndex &parent) const
{
    if(parent.isValid()){
        return 0;
    }
    return mainList.size();
}

QVariant listModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (role == Qt::DisplayRole)
        return mainList.at(index.row());

    return QVariant();
}

QHash<int, QByteArray> listModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "display";
    return roles;
}
