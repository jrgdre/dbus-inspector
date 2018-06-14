#include <QtDBus/QtDBus>

#include "dSystemBusServicesModel.h"

DSystemBusServicesModel::DSystemBusServicesModel(QObject *parent) :
    QAbstractListModel(parent)
{
    QDBusReply<QStringList> reply = QDBusConnection::systemBus().interface()->registeredServiceNames();
    if (!reply.isValid()) {
        qDebug() << "Error:" << reply.error().message();
        exit(1);
    }
    foreach (QString name, reply.value())
        serviceNames << name;
    serviceNames.sort();
}

QHash<int, QByteArray> DSystemBusServicesModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    return roles;
}

QVariant DSystemBusServicesModel::data(const QModelIndex &index, int role) const {
    if(!index.isValid()) {
        return QVariant();
    }
    if(role == NameRole) {
        return QVariant(serviceNames[index.row()]);
    }
    return QVariant();
}

QString DSystemBusServicesModel::getServiceName(const int i) {
    if ((i < 0) || (i >= serviceNames.count())){
        return QString("");
    }
    return QString(serviceNames[i]);
}
