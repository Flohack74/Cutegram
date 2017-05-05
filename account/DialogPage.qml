import QtQuick 2.4
import Ubuntu.Components 1.3 as Components
import TelegramQml 2.0
import "../messages" as Messages
import "../toolkit" as ToolKit

ToolKit.StackedPage {
    id: dialogPage

    signal peerInfoRequest(variant inputPeer)

    property InputPeer currentPeer
    header: ToolKit.DialogHeader {
        engine: dialogPage.engine
        currentPeer: dialogPage.currentPeer
        onClicked: {
            dialogPage.peerInfoRequest(currentPeer);
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height

        Messages.MessagesFrame {
            id: messagesFrame
            width: parent.width
            height: parent.height
            engine: dialogPage.engine
            currentPeer: dialogPage.currentPeer
            //type: CutegramEnums.homeTypeMessages
        }
    }

    Component {
        id: dialog_details_component
        DialogDetailsPage {
            id: dialogDetailsPage
            engine: dialogPage.engine
            stack: dialogPage.stack
        }
    }
}

