import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Sailfish.Silica 1.0
import org.nemomobile.dbus 2.0
import "."

/* Show all signals, methods and properties of an interface of a service

   The description of the interface is expected to be a XML - String.

 */
Page {
    id: page

    // page header strings
    property int    busId          // ID of the bus we are on [DBus.SessionBus | DBus.SystemBus]
    property string serviceName
    property string pathName
    property string interfaceName

    // these define what is going to be listed
    property string xmlString      // xml string of (sub-)node (service)
    property string interfaceIndex // index of the interface selected

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
        Label {
            id   : labelInterfaceName
            text : qsTr('[interface] ') + interfaceName
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
            return headerSignals.height
                 + listViewSignals.height
                 + headerMethods.height
                 + listViewMethods.height
                 + headerProperties.height
                 + listViewProperties.height
        }
        anchors.left     : parent.left
        anchors.right    : parent.right
        contentWidth     : {
            var widthSignals    = listViewSignals.implicitWidth
            var widthMethods    = listViewMethods.implicitWidth
            var widthProperties = listViewProperties.implicitWidth
            var result          = 0
            result = (widthSignals    > result) ? widthSignals    : result
            result = (widthMethods    > result) ? widthMethods    : result
            result = (widthProperties > result) ? widthProperties : result
            return result
        }

        VerticalScrollDecorator   {
            flickable: parent
        }
        HorizontalScrollDecorator {
            flickable: parent
            anchors.bottom: parent.bottom
        }

        // list all signals of the current interface
        SectionHeader {
            id     : headerSignals
            text   : qsTr("Signals")
            width  : page.width
            height : xmlModelSignals.count > 0 ? Theme.fontSizeMedium : 0
            visible: xmlModelSignals.count > 0
            font.pixelSize: Theme.fontSizeMedium
            horizontalAlignment: Text.AlignLeft
        }
        SilicaListView {
            id           : listViewSignals
            anchors.top  : headerSignals.bottom
            anchors.left : parent.left
            height       : contentItem.childrenRect.height
            implicitWidth: globalFunctions.listViewGetMaxItemWidth(listViewSignals) + (2.0 * Theme.paddingLarge)
            width        : parent.width
            // all signals of the selected interface
            model: XmlListModel {
                id : xmlModelSignals
                xml: xmlString
                query: "/node/interface[" + interfaceIndex + "]/signal"
                XmlRole {name: "name"; query: "@name/string()"}
            }
            // for each signal found for the interface
            delegate: BackgroundItem {
                id: delegateSignals
                property int typeId: 1
                // create a model of all arguments of the current signal
                XmlListModel {
                    id : xmlModelSignalArgs
                    xml: xmlString
                    query: "/node/interface[" + interfaceIndex + "]/signal[" + (index+1) + "]/arg"
                    XmlRole {name: "name"; query: "@name/string()"}
                    XmlRole {name: "type"; query: "@type/string()"}
                }
                // create a model of all annotations of the current signal
                XmlListModel {
                    id : xmlModelSignalAnno
                    xml: xmlString
                    query: "/node/interface[" + interfaceIndex + "]/signal[" + (index+1) + "]/annotation"
                    XmlRole {name: "name" ; query: "@name/string()" }
                    XmlRole {name: "value"; query: "@value/string()"}
                }
                Label {
                    property int typeId: 2
                    text : {
                        // add parameters
                        var result = name + '('
                        for (var idx = 0; idx < xmlModelSignalArgs.count; idx++) {
                            var arg   = xmlModelSignalArgs.get(idx)
                            var param = arg.type + ' ' + arg.name
                            result = (idx == 0) ? result + param : result + '; ' + param
                        }
                        result = result + ')'
                        // add annotations
                        for (idx = 0; idx < xmlModelSignalAnno.count; idx++) {
                            var anno    = xmlModelSignalAnno.get(idx)
                            var annoStr = anno.name + '=' + anno.value
                            result = (idx == 0) ? result + ' // ' + annoStr : result + '; ' + annoStr
                        }
                        return result
                    }
                    x    : Theme.horizontalPageMargin * 2
                    color: delegateSignals.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.family: "courier"
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors.verticalCenter: parent.verticalCenter
                }
    //            onClicked:  {
    //                var page = pageStack.push(Qt.resolvedUrl("IntrospectServicePage.qml"))
    //                page.serviceName = namesModel.getServiceName(index);
    //            }
            }
        }

        // list all methods of the interface
        SectionHeader {
            id     : headerMethods
            text   : qsTr("Methods")
            width  : page.width
            height : xmlModelMethods.count > 0 ? Theme.fontSizeMedium : 0
            visible: xmlModelMethods.count > 0
            anchors.top: listViewSignals.bottom
            font.pixelSize: Theme.fontSizeMedium
            horizontalAlignment: Text.AlignLeft
        }
        SilicaListView {
            id           : listViewMethods
            anchors.top  : headerMethods.bottom
            anchors.left : parent.left
            height       : contentItem.childrenRect.height
            implicitWidth: globalFunctions.listViewGetMaxItemWidth(listViewMethods) + (2.0 * Theme.paddingLarge)
            width        : parent.width
            // all methods of the selected interface
            model: XmlListModel {
                id : xmlModelMethods
                xml: xmlString
                query: "/node/interface[" + interfaceIndex + "]/method"
                XmlRole {name: "name"; query: "@name/string()"}
            }
            // for each method found for the interface
            delegate: BackgroundItem {
                id: delegateMethods
                property int typeId: 1
                // create a model of all arguments of the current method
                XmlListModel {
                    id : xmlModelMethodArgs
                    xml: xmlString
                    query: "/node/interface[" + interfaceIndex + "]/method[" + (index+1) + "]/arg"
                    XmlRole {name: "name"     ; query: "@name/string()"     }
                    XmlRole {name: "type"     ; query: "@type/string()"     }
                    XmlRole {name: "direction"; query: "@direction/string()"}
                }
                // create a model of all annotations of the current method
                XmlListModel {
                    id : xmlModelMethodAnno
                    xml: xmlString
                    query: "/node/interface[" + interfaceIndex + "]/method[" + (index+1) + "]/annotation"
                    XmlRole {name: "name" ; query: "@name/string()" }
                    XmlRole {name: "value"; query: "@value/string()"}
                }
                Label {
                    property int typeId: 2
                    text : {
                        // add parameters
                        var result = name + '('
                        for (var idx = 0; idx < xmlModelMethodArgs.count; idx++) {
                            var arg   = xmlModelMethodArgs.get(idx)
                            var param = arg.direction + ' ' + arg.type + ' ' + arg.name
                            result = (idx == 0) ? result + param : result + '; ' + param
                        }
                        result = result + ')'
                        // add annotations
                        for (idx = 0; idx < xmlModelMethodAnno.count; idx++) {
                            var anno    = xmlModelMethodAnno.get(idx)
                            var annoStr = anno.name + '=' + anno.value
                            result = (idx == 0) ? result + ' // ' + annoStr : result + '; ' + annoStr
                        }
                        return result
                    }
                    x    : Theme.horizontalPageMargin * 2
                    color: delegateMethods.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.family: "courier"
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors.verticalCenter: parent.verticalCenter
                }
    //            onClicked:  {
    //                var page = pageStack.push(Qt.resolvedUrl("IntrospectServicePage.qml"))
    //                page.serviceName = namesModel.getServiceName(index);
    //            }
            }
        }

        // list all properties of the selected interface
        SectionHeader {
            id     : headerProperties
            text   : qsTr("Properties")
            width  : page.width
            height : xmlModelProperties.count > 0 ? Theme.fontSizeMedium : 0
            visible: xmlModelProperties.count > 0
            anchors.top: listViewMethods.bottom
            font.pixelSize: Theme.fontSizeMedium
            horizontalAlignment: Text.AlignLeft
        }
        SilicaListView {
            id           : listViewProperties
            anchors.top  : headerProperties.bottom
            anchors.left : parent.left
            height       : contentItem.childrenRect.height
            implicitWidth: globalFunctions.listViewGetMaxItemWidth(listViewProperties) + (2.0 * Theme.paddingLarge)
            width        : parent.width
            // all properties of the selected interface
            model: XmlListModel {
                id : xmlModelProperties
                xml: xmlString
                query: "/node/interface[" + interfaceIndex + "]/property"
                XmlRole {name: "name"  ; query: "@name/string()"  }
                XmlRole {name: "type"  ; query: "@type/string()"  }
                XmlRole {name: "access"; query: "@access/string()"}
            }
            // for each property found for the interface
            delegate: BackgroundItem {
                id: delegateProperties
                property int typeId: 1
                // create a model of all annotations of the current property
                XmlListModel {
                    id : xmlModelPropertyAnno
                    xml: xmlString
                    query: "/node/interface[" + interfaceIndex + "]/property[" + (index+1) + "]/annotation"
                    XmlRole {name: "name" ; query: "@name/string()" }
                    XmlRole {name: "value"; query: "@value/string()"}
                }
                Label {
                    property int typeId: 2
                    text : {
                        // add parameter
                        var result = name + '('
                        var arg   = xmlModelProperties.get(index)
                        var param = arg.type + ' ' + arg.name + ' ' + arg.access
                        result = result + param + ')'
                        // add annotations
                        for (var idx = 0; idx < xmlModelPropertyAnno.count; idx++) {
                            var anno    = xmlModelPropertyAnno.get(idx)
                            var annoStr = anno.name + '=' + anno.value
                            result = (idx == 0) ? result + ' // ' + annoStr : result + '; ' + annoStr
                        }
                        return result
                    }
                    x    : Theme.horizontalPageMargin * 2
                    color: delegateProperties.highlighted ? Theme.highlightColor : Theme.primaryColor
                    font.family: "courier"
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors.verticalCenter: parent.verticalCenter
    //            onClicked:  {
    //                var page = pageStack.push(Qt.resolvedUrl("IntrospectServicePage.qml"))
    //                page.serviceName = namesModel.getServiceName(index);
    //            }
                }
            }
            // show this placeholder if none of the models on this page has any entries
            ViewPlaceholder {
                enabled: (xmlModelSignals.count == 0) && (xmlModelMethods.count == 0) && (xmlModelProperties.count == 0)
                text   : "no entries"
            }
        }

    }
}
