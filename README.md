D-Bus Inspector for SailfishOS
==============================
Sailfish OS GUI Application for the convenient introspection of D-System- and D-Session-Bus services, interfaces, signals, methods and properties.

Disclaimer :-)
This is my first serious application for SailfishOS and the first time I use QML or Qt. So comments are welcome.

It's main purpose is for me to find out how to do things on this (for me) new platform.

But it also serves a purpose:
What services are available on the D-Buses of a SailfishOS device and how can we make use of them.

QML / C++ integration
---------------------
The application uses the two Qt C++ classes in
- dSessionBusNamesModel
- dSystemBusNamesModel
to provide list models of the services registered on the D-Session- or D-System-Bus.

Could this have been done in QML (like all the others)? By all means, but I wanted to try the C++ / QML collaboration.

The models are made available to QML in main() in dBusListNames.cpp.

From here on everything is QML only.

QML stuff
---------
Some interesting stuff is in ServiceListPage.qml. We show how to use:
- The QML DBusInterface class to introspect subnodes of a service on the D-Bus
- The QML XmlListModel class to parse XML strings

The InterfaceListPage.qml shows how to access the information of a specific interface in an XML string.

Also e.g. in InterfaceListPage.qml we
adjust the height and width of a SilicaFlickable according to the height and the width of multiple ListViews
it contains and use a VerticalScollDecarator and a HorizontalScrollDecarator if the screen is to small
to show all list entries.

In IntrospectServicePage.qml we use a standard Qt TextEdit instead the Silica TextArea to provide vertical and
horizontal scrolling of an unwraped XML document.

References
----------
 # https://sailfishos.org/develop/docs/nemo-qml-plugin-dbus/qml-org-nemomobile-dbus-dbusinterface.html/
 # https://www.gnu.org/software/emacs/manual/html_node/dbus/Introspection.html
 # http://cheesehead-techblog.blogspot.sg/2012/08/dbus-tutorial-introspection-figuring.html
 # https://blog.mafr.de/2006/12/19/using-dbus-introspection/
 # https://dbus.freedesktop.org/doc/dbus-monitor.1.html

 # http://doc.qt.io/qt-5/qtqml-javascript-expressions.html
 # http://stackoverflow.com/questions/13923794/how-to-do-a-is-a-typeof-or-instanceof-in-qml
 # https://saildev.wordpress.com/2014/03/05/design-tip-custom-pageheader/
