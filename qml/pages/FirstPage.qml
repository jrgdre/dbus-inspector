import QtQuick 2.0
import Sailfish.Silica 1.0

/* Let the user select the D-Bus to introspect

   Show the welcome message and a short usage hint
 */
Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    Column {
        id     : pageHeader
        x      : Theme.paddingMedium
        width  : ( parent.width - ( 2.0 * Theme.paddingMedium ))
        spacing: Theme.paddingSmall

        Label {
            id   : labelBusName
            text : qsTr('D-Bus Inspector') + ' ' + Qt.application.version
            width: parent.width
            elide: Text.ElideLeft
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignRight
        }
        Label {
            id   : labelVersion
            text : '(c) 2017-2018 jrgdre'
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
        contentHeight: column.height
        contentWidth : column.implicitWidth

        VerticalScrollDecorator   {
            flickable: parent
        }
        HorizontalScrollDecorator {
            flickable     : parent
            anchors.bottom: parent.bottom
        }

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text     : qsTr("D-Session-Bus Services")
                onClicked: pageStack.push(Qt.resolvedUrl("DSessionBusServicesPage.qml"))
            }
            MenuItem {
                text     : qsTr("D-System-Bus Services")
                onClicked: pageStack.push(Qt.resolvedUrl("DSystemBusServicesPage.qml"))
            }
        }
        Column {
            id     : column
            width  : page.width
            spacing: Theme.paddingLarge
            anchors {
                top: parent.verticalCenter
            }

            Label {
                id      : greating
                text    : qsTr("Ahoy Sailor!")
                color   : Theme.secondaryHighlightColor
                wrapMode: Text.WordWrap
                font {
                    pixelSize: Theme.fontSizeExtraLarge
                }
                anchors {
                    left   : parent.left
                    right  : parent.right
                    margins: Theme.paddingLarge
                }
            }
            Label {
                id      : hint
                text    : qsTr("Use Pulldown menu to select D-Bus to list services for.")
                wrapMode: Text.WordWrap
                anchors {
                    left   : parent.left
                    right  : parent.right
                    margins: Theme.paddingLarge
                }
            }
        }
    }
}

