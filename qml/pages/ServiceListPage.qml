import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Sailfish.Silica 1.0
import Nemo.DBus 2.0
import "."

/* Show all interfaces and subnodes of a (sub-)node of a sevice

   The description of the (sub-)node is expected to be in XML.

 */
Page {
    id: page

    // this contains what we list
    property string xmlString      // a node's XML description

    // needed for subnodes only
    property int    busId          // ID of the D-Bus we are on [DBus.SessionBus | DBus.SystemBus]
    property string serviceName    // selected D-Bus Service
    property string pathName: "/"  // Service path

    allowedOrientations: Orientation.All

    GlobalFunctions {
        id: globalFunctions
    }

    Column {
        id     : pageHeader
        x      : Theme.paddingLarge
        width  : ( parent.width - ( 2.0 * Theme.paddingLarge ))
        spacing: Theme.paddingSmall

        Label {
            id   : labelBusName
            text : { return busId == DBus.SystemBus ? 'D-System-Bus' : 'D-Session-Bus' }
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
        Label {
            id   : labelPathName
            text : qsTr('[path] ') + pathName
            width: parent.width
            elide: Text.ElideLeft
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignRight
        }
    }

    SilicaFlickable {
        anchors.top      : pageHeader.bottom
        anchors.topMargin: Theme.paddingLarge
        anchors.bottom   : parent.bottom
        contentHeight    : {
            return listViewInterfaces.height
                 + listViewNodes.height
        }
        anchors.left     : parent.left
        anchors.right    : parent.right
        contentWidth     : {
            var widthInterfaces = listViewInterfaces.implicitWidth
            var widthNodes      = listViewNodes.implicitWidth
            var result          = 0
            result = (widthInterfaces > result) ? widthInterfaces : result
            result = (widthNodes      > result) ? widthNodes      : result
            return result
        }

        VerticalScrollDecorator   {
            flickable: parent
        }
        HorizontalScrollDecorator {
            flickable: parent
            anchors.bottom: parent.bottom
        }

        // list all interfaces of the current node
        SilicaListView {
            id           : listViewInterfaces
            anchors.left : parent.left
            height       : contentItem.childrenRect.height
            implicitWidth: globalFunctions.listViewGetMaxItemWidth(listViewInterfaces)
            width        : parent.width
            // all interfaces of the selected service (node)
            model: XmlListModel {
                id   : xmlModelInterfaces
                xml  : xmlString
                query: "/node/interface"
                XmlRole {name: "name"; query: "@name/string()"}
            }
            // for each interface found for the selected service (node)
            delegate: BackgroundItem {
                id: delegate
                property int typeId: 1
                // create a model of all annotations of the current interface
                XmlListModel {
                    id : xmlModelInterfaceAnno
                    xml: xmlString
                    query: "/node/interface[" + (index+1) + "]/annotation"
                    XmlRole {name: "name" ; query: "@name/string()" }
                    XmlRole {name: "value"; query: "@value/string()"}
                }
                // create a view
                Label {
                    property int typeId: 2
                    text : {
                        var result = name
                        // add annotations
                        for (var idx = 0; idx < xmlModelInterfaceAnno.count; idx++) {
                            var anno    = xmlModelInterfaceAnno.get(idx)
                            var annoStr = anno.name + '=' + anno.value
                            result = (idx == 0) ? result + ' // ' + annoStr : result + '; ' + annoStr
                        }
                        return result
                    }
                    x    : Theme.horizontalPageMargin
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked:  {
                    // list an interface's methods and signals
                    var page = pageStack.push(Qt.resolvedUrl("InterfaceListPage.qml"))
                    page.busId          = busId
                    page.serviceName    = serviceName
                    page.pathName       = pathName
                    page.interfaceName  = name
                    page.xmlString      = xmlModelInterfaces.xml
                    page.interfaceIndex = index + 1
                }
            }
        }

        // list all subnodes of the current node
        SilicaListView {
            id           : listViewNodes
            anchors.top  : listViewInterfaces.bottom
            anchors.left : parent.left
            height       : contentItem.childrenRect.height
            implicitWidth: globalFunctions.listViewGetMaxItemWidth(listViewNodes)
            width        : page.width
            model : xmlModelNodes
            // create a model
            // all sub-nodes of the selected service (node)
            XmlListModel {
                id   : xmlModelNodes
                xml  : xmlString
                query: "/node/node"
                XmlRole {name: "name"; query: "@name/string()"}
            }
            // for each subnode of the current node
            delegate: BackgroundItem {
                id: delegateNodes
                property int typeId: 1
                // create a view
                Label {
                    property int typeId: 2
                    text : name + '/'
                    x    : Theme.horizontalPageMargin
                    color: delegateNodes.highlighted ? Theme.highlightColor : Theme.primaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked:  {
                    // dive into subnode
                    dBusInterfaceNodes.bus     = busId
                    dBusInterfaceNodes.service = serviceName
                    dBusInterfaceNodes.path    = pathName + name
                    dBusInterfaceNodes.introspect()
                }
            }
            // show this placeholder if none of the models on this page has any entries
            ViewPlaceholder {
                enabled: (xmlModelInterfaces.count == 0) && (xmlModelNodes.count == 0)
                text: "no entries"
            }
        }

    }

    // get the XML description for a subnode
    DBusInterface {
        id   : dBusInterfaceNodes
        iface: 'org.freedesktop.DBus.Introspectable'

        function introspect() {
            typedCall('Introspect', undefined,
                      function(result) {
                          // recursive call this page with result = xml fragment of selected node
                          var page = pageStack.push(Qt.resolvedUrl("ServiceListPage.qml"))
                          page.busId       = bus
                          page.pathName    = path + '/'
                          page.serviceName = serviceName
                          page.xmlString   = result
                      },
                      function() {
                          // show error page
                          var page = pageStack.push(Qt.resolvedUrl("Error.qml"))
                          page.caption = path
                          page.message = "Error: call failed"
                      }
            )
        }
    }

}
