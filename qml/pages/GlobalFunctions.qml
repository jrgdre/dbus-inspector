import QtQuick 2.0
import Sailfish.Silica 1.0

Item {

    /* Determine the width of the biggest Label in a ListView

       It is assumed that the delegate has a
       - property int typeId: 1
       and the Label in the delegate has a
       - property int typeId: 2

       (s. InterfaceListPage.qml)
     */
    function listViewGetMaxItemWidth (listview) {
        var result = 0
        for (var idxBI in listview.contentItem.children) {
            if (listview.contentItem.children[idxBI].typeId === 1) {
                var backgroundItem = listview.contentItem.children[idxBI]
                for (var idxL in backgroundItem.children) {
                    if (backgroundItem.children[idxL].typeId === 2) {
                        var label = backgroundItem.children[idxL]
                        var labelWidth = label.width + (Theme.horizontalPageMargin * 2)
                        result = labelWidth > result ? labelWidth : result
                    }
                }
            }
        }
        return result
    }

}
