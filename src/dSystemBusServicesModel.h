#ifndef DSYSTEMBUSSERVICESMODEL_H
#define DSYSTEMBUSSERVICESMODEL_H

#include <QAbstractListModel>

class DSystemBusServicesModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum DBusNames {
        NameRole = Qt::UserRole + 1,
    };

    explicit DSystemBusServicesModel(QObject *parent=0);

    virtual int rowCount(const QModelIndex&) const { return serviceNames.size(); }
    virtual QVariant data(const QModelIndex &index, int role) const;

    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QString getServiceName(const int i);

private:
    QStringList serviceNames;
};

#endif // DSYSTEMBUSSERVICESMODEL_H
