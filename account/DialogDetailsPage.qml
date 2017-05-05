import QtQuick 2.4
import Ubuntu.Components 1.3 as Components
import TelegramQml 2.0
import "../toolkit" as ToolKit

ToolKit.StackedPage {
    id: dialogDetailsPage

    property InputPeer currentPeer

    header: ToolKit.DialogHeader {
        engine: dialogDetailsPage.engine
        currentPeer: dialogDetailsPage.currentPeer
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height

        ToolKit.DialogDetails {
            id: details
            height: parent.height
            width: parent.width
            engine: dialogDetailsPage.engine
            currentPeer: visible ? dialogDetailsPage.currentPeer : null
        }
    }
}

