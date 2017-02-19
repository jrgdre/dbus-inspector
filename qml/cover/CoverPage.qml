import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
        id: tuxBus
        source: "svg/tuxBus.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.width
    }
    Label {
        id: labelDBus
        text: qsTr("D-Bus")
        anchors.top: tuxBus.bottom
        anchors.topMargin: Math.round(
            1/2 * (  parent.height
                   - tuxBus.height
                   - labelDBus.height
                   - labelInspector.height)
        )
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
    }
    Label {
        id   : labelInspector
        text : qsTr("Inspector")
        width: parent.width
        anchors.top: labelDBus.bottom
        horizontalAlignment: Text.AlignHCenter
    }
}

