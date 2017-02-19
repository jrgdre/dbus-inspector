import QtQuick 2.0
import Sailfish.Silica 1.0

/* Show the user an error message
 */
Page {
    id: page
    allowedOrientations: Orientation.All

    property string caption
    property string message

    Column {
        id: column
        width: page.width

        PageHeader {
            title: caption
        }
        Label {
            text: message
            x: Theme.horizontalPageMargin
        }
    }
}
