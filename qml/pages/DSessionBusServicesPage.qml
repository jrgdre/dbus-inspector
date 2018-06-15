import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.DBus 2.0
import harbour.dbus.inspector.DSessionBusServicesModel 1.0

/* Show the list of D-Session-Bus services

   Uses the C++ DSessionBusServicesModel
 */
Page {
    id: page

    allowedOrientations: Orientation.All

    GlobalFunctions {
        id: globalFunctions
    }

    Column {
        id     : pageHeader
        x      : Theme.paddingMedium
        width  : ( parent.width - ( 2.0 * Theme.paddingMedium ))
        spacing: Theme.paddingSmall

        Label {
            id   : labelBusName
            text : 'D-Session-Bus'
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
        contentHeight    : listView.height
        anchors.left     : parent.left
        anchors.right    : parent.right
        contentWidth     : listView.implicitWidth

        VerticalScrollDecorator   {
            flickable: parent
        }
        HorizontalScrollDecorator {
            flickable: parent
            anchors.bottom: parent.bottom
        }

        SilicaListView {
            id               : listView
            anchors.left     : parent.left
            height           : contentItem.childrenRect.height
            implicitWidth    : globalFunctions.listViewGetMaxItemWidth(listView)
            width            : parent.width
            // here we access the C++ model
            model: DSessionBusServicesModel {
                id: namesServices
            }
            // for each entry in the model
            delegate: BackgroundItem {
                id: delegate
                property int typeId: 1
                // create a view
                Label {
                    property int typeId: 2
                    text : name
                    x    : Theme.horizontalPageMargin
                    color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                onClicked:  {
                    var page = pageStack.push(Qt.resolvedUrl("IntrospectServicePage.qml"))
                    page.busId       = DBus.SessionBus
                    page.serviceName = namesServices.getServiceName(index);
                }
            }
            // show this placeholder if the model has no entries
            ViewPlaceholder {
                enabled: namesServices.count === 0
                text: "no entries"
            }
        }
    }

}
