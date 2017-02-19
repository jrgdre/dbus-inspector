# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-dbus-inspector

DEFINES += APP_VERSION=\"\\\"$${VERSION}\\\"\"

message($${DEFINES})

QT += dbus

CONFIG += sailfishapp

SOURCES += src/harbour-dbus-inspector.cpp \
    src/dSessionBusServicesModel.cpp \
    src/dSystemBusServicesModel.cpp

OTHER_FILES += qml/harbour-dbus-inspector.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-dbus-inspector.changes.in \
    rpm/harbour-dbus-inspector.spec \
    rpm/harbour-dbus-inspector.yaml \
    translations/*.ts \
    harbour-dbus-inspector.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-dbus-inspector-de.ts

DISTFILES += \
    qml/cover/CoverPage.qml \
    qml/cover/svg/tuxBus.svg \
    qml/pages/DSessionBusServicesPage.qml \
    qml/pages/DSystemBusServicesPage.qml \
    qml/pages/Error.qml \
    qml/pages/FirstPage.qml \
    qml/pages/GlobalFunctions.qml \
    qml/pages/InterfaceListPage.qml \
    qml/pages/IntrospectServicePage.qml \
    qml/pages/ServiceListPage.qml

HEADERS += \
    src/dSessionBusServicesModel.h \
    src/dSystemBusServicesModel.h
