#ifndef DSESSIONBUSSERVICESMODEL_H
#define DSESSIONBUSSERVICESMODEL_H

#include <QAbstractListModel>

class DSessionBusServicesModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum DBusNames {
        NameRole = Qt::UserRole + 1,
    };

    explicit DSessionBusServicesModel(QObject *parent=0);

    virtual int rowCount(const QModelIndex&) const { return serviceNames.size(); }
    virtual QVariant data(const QModelIndex &index, int role) const;

    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QString getServiceName(const int i);

private:
    QVector<QString> serviceNames;
};

#endif // DSESSIONBUSSERVICESMODEL_H
