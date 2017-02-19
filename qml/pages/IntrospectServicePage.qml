import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.dbus 2.0

/* Show the XML result of the introspection of a service
 */
Page {
    id: page

    property int    busId          // ID of the D-Bus we are on [DBus.SessionBus | DBus.SystemBus]
    property string serviceName    // selected D-Bus Service

    allowedOrientations: Orientation.All

    Column {
        id     : pageHeader
        x      : Theme.paddingMedium
        width  : ( parent.width - ( 2.0 * Theme.paddingMedium ))
        spacing: Theme.paddingSmall

        Label {
            id   : labelBusName
            text : { return busId === DBus.SystemBus ? 'D-System-Bus' : 'D-Session-Bus' }
            width: parent.width
            elide: Text.ElideLeft
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignRight
        }
        Label {
            id   : labelServiceName
            text : qsTr('[service] ') + serviceName
            width: parent.width
            elide: Text.ElideLeft
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignRight
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill : parent
        contentHeight: introspectResult.height + introspectResult.anchors.topMargin
        contentWidth : introspectResult.width + (2.0 * Theme.paddingLarge)

        VerticalScrollDecorator   {
            flickable: parent
        }
        HorizontalScrollDecorator {
            flickable: introspectResult
            anchors.bottom: parent.bottom
        }

        PullDownMenu {
            MenuItem {
                id  : parse
                text: qsTr("Parse")
                onClicked: {
                    var page = pageStack.push(Qt.resolvedUrl("ServiceListPage.qml"))
                    page.busId       = busId
                    page.pathName    = '/'
                    page.serviceName = serviceName
                    page.xmlString   = introspectResult.text
                }
            }
        }
        TextEdit {
            id      : introspectResult
            readOnly: true
            color   : Theme.primaryColor
            anchors {
                margins  : Theme.paddingLarge
                top      : parent.top
                topMargin: labelBusName.height + labelServiceName.height + Theme.paddingLarge
                left     : parent.left
            }
            font {
                family   : "courier"
                pixelSize: Theme.fontSizeTiny
            }
        }
    }

    onServiceNameChanged: {
        labelServiceName.text = '[service] ' + serviceName;
        dBusInterface.service = serviceName;
        dBusInterface.introspect();
    }

    DBusInterface {
        id   : dBusInterface
        bus  : busId
        path : '/'
        iface: 'org.freedesktop.DBus.Introspectable'

        function introspect() {
            typedCall('Introspect', undefined,
                      function(result) {
                          introspectResult.text = result
                      },
                      function() {
                          introspectResult.text = qsTr('call failed')
                      }
            )
        }
    }

}
