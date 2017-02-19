#include <QtDBus/QtDBus>

#include "dSessionBusServicesModel.h"

DSessionBusServicesModel::DSessionBusServicesModel(QObject *parent) :
    QAbstractListModel(parent)
{
    QDBusReply<QStringList> reply = QDBusConnection::sessionBus().interface()->registeredServiceNames();
    if (!reply.isValid()) {
        qDebug() << "Error:" << reply.error().message();
        exit(1);
    }
    foreach (QString name, reply.value())
        serviceNames << name;
}

QHash<int, QByteArray> DSessionBusServicesModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    return roles;
}

QVariant DSessionBusServicesModel::data(const QModelIndex &index, int role) const {
    if(!index.isValid()) {
        return QVariant();
    }
    if(role == NameRole) {
        return QVariant(serviceNames[index.row()]);
    }
    return QVariant();
}

QString DSessionBusServicesModel::getServiceName(const int i) {
    if ((i < 0) || (i >= serviceNames.count())){
        return QString("");
    }
    return QString(serviceNames[i]);
}
