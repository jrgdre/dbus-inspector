#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

#include <QtQml>
#include <QScopedPointer>
#include <QQuickView>
#include <QQmlEngine>
#include <QGuiApplication>
#include <QQmlContext>
#include <QCoreApplication>

#include "dSessionBusServicesModel.h"
#include "dSystemBusServicesModel.h"


int main(int argc, char *argv[])
{
    qmlRegisterType<DSessionBusServicesModel>(
        "harbour.dbus.inspector.DSessionBusServicesModel", 1, 0,
        "DSessionBusServicesModel"
    );
    qmlRegisterType<DSystemBusServicesModel>(
        "harbour.dbus.inspector.DSystemBusServicesModel", 1, 0,
        "DSystemBusServicesModel"
    );

    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));

    qDebug() << APP_VERSION;
    app->setApplicationVersion(APP_VERSION);

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->setSource(SailfishApp::pathTo("qml/harbour-dbus-inspector.qml"));
    view->show();

    return app->exec();
}
