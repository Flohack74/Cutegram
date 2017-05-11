import QtQuick 2.4
import AsemanTools 1.0
import TelegramQml 2.0 as Telegram
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import "../awesome"
import "../toolkit" as ToolKit
import "../globals"
//import "../thirdparty"

ListItem {
    id: item
    height: units.gu(7)

    property alias engine: img.engine

    signal active()
    signal forwardRequest(variant inputPeer, int msgId)
    signal clearHistoryRequest(variant inputPeer)
    signal peerInfoRequest(variant inputPeer)

    leadingActions: ListItemActions {
        actions: [
            /*Action {
                iconName: "system-log-out"
                text: i18n.tr("Leave chat")
                visible: connected

                onTriggered: {
                    PopupUtils.open(Qt.resolvedUrl("qrc:/qml/ui/dialogs/ConfirmationDialog.qml"),
                        list_item, {
                            text: i18n.tr("Are you sure you want to leave this chat?"),
                            onAccept: function() {
                                pageStack.clear()
                                telegram.messagesDeleteHistory(dialogId, true)
                            }
                        }
                    );
                }
            },*/
            Action {
                iconName: "edit-clear"
                text: i18n.tr("Clear history")

                onTriggered: {
                    clearHistoryRequest(model.peer)
                    /*PopupUtils.open(Qt.resolvedUrl("qrc:/qml/ui/dialogs/ConfirmationDialog.qml"),
                        list_item, {
                            text: i18n.tr("Are you sure you want to clear history?"),
                            onAccept: function() {
                                clearHistoryRequest(model.peer)
                            }
                        }
                    );*/
                }
            },
            Action {
                iconName: "mail-mark-read"
                text: i18n.tr("Mark as read")

                onTriggered: {
                    model.unreadCount = 0
                    /*PopupUtils.open(Qt.resolvedUrl("qrc:/qml/ui/dialogs/ConfirmationDialog.qml"),
                        list_item, {
                            text: i18n.tr("Are you sure you want to clear history?"),
                            onAccept: function() {
                                model.unreadCount = 0
                            }
                        }
                    );*/
                }
            }
        ]
    }

    trailingActions: ListItemActions {
        actions: [
            Action {
                iconName: "info"
                text: i18n.tr("Info")
                onTriggered: {
                    item.peerInfoRequest(model.peer)
                }
            }
        ]
    }

    Row {
        id: row
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10*Devices.density
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6*Devices.density

        Rectangle {
            id: avatar
            height: item.height - 16*Devices.density
            width: height
            anchors.verticalCenter: parent.verticalCenter
            color: TelegramColors.transparent
            radius: width/2
            border.width: 1*Devices.density
            border.color: model.isOnline? TelegramColors.defaultOnline : TelegramColors.transparent

            ToolKit.ProfileImage {
                id: img
                anchors.fill: parent
                anchors.margins: 3*Devices.density
                source: model.user? model.user : model.chat
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item {
            width: row.width - avatar.width - row.spacing
            height: 24*Devices.density
            anchors.verticalCenter: parent.verticalCenter

            Item {
                id: details
                anchors.left: parent.left
                anchors.right: msg_state_txt.visible ? msg_state_txt.left : date_txt.left
                anchors.rightMargin: 5*Devices.density
                height: 24*Devices.density
                anchors.verticalCenter: parent.verticalCenter
                property int spacing: 5*Devices.fontDensity

                Text {
                    id: chat_icon
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.top
                    horizontalAlignment: Text.AlignLeft
                    font.family: Awesome.family
                    font.pixelSize: 9*Devices.fontDensity
                    color: "grey"
                    text: Awesome.fa_users
                    visible: !model.user
                }

                Text {
                    id: title
                    anchors.left: chat_icon.visible ? chat_icon.right : parent.left
                    anchors.leftMargin: chat_icon.visible ? details.spacing : 0
                    anchors.right: parent.right
                    anchors.rightMargin: mute_icon.visible ? (mute_icon.contentWidth + mute_icon.leftSpacing) : 0
                    anchors.verticalCenter: parent.top
                    horizontalAlignment: Text.AlignLeft
                    font.weight: Font.DemiBold
                    font.pixelSize: units.dp(17)//FontUtils.sizeToPixels("large")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                    maximumLineCount: 1
                    text: CutegramEmojis.parse(model.title)
                }

                Text {
                    id: mute_icon
                    anchors.left: chat_icon.visible ? chat_icon.right : parent.left
                    anchors.leftMargin: leftSpacing + Math.min(title.contentWidth, parent.width-contentWidth-details.spacing)
                    anchors.verticalCenter: parent.top
                    horizontalAlignment: Text.AlignLeft
                    font.family: Awesome.family
                    font.pixelSize: 9*Devices.fontDensity
                    color: "grey"
                    text: model.mute? Awesome.fa_bell_slash_o : Awesome.fa_bell_o
                    visible: model.mute
                    property int leftSpacing: chat_icon.visible ? 2*details.spacing : details.spacing
                }
            }

            Text {
                id: date_txt
                anchors.right: parent.right
                anchors.verticalCenter: parent.top
                font.pixelSize: units.dp(12)
                color: "grey"
                text: model.messageDate
            }

            Text {
                id: msg_state_txt
                anchors.right: date_txt.left
                anchors.rightMargin: 10*Devices.density
                anchors.verticalCenter: parent.top
                font.family: Awesome.family
                font.pixelSize: 9*Devices.fontDensity
                font.letterSpacing: -7*Devices.density
                color: "#75CB46"
                visible: model.messageOut
                text: {
                    if(!model.messageOut)
                        return ""
                    else
                        if(model.messageUnread)
                            return Awesome.fa_check
                        else
                            return Awesome.fa_check + Awesome.fa_check
                }
            }

            Text {
                anchors.left: parent.left
                anchors.right: unread_rect.left
                anchors.rightMargin: 6*Devices.density
                anchors.verticalCenter: parent.bottom
                font.pixelSize: units.dp(15)
                color: "grey"
                text: {
                    if(model.typing.length == 0) {
                        return CutegramEmojis.parse(model.message)
                    } else {
                        return qsTr("Typing...")
                    }
                }
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                elide: Text.ElideRight
                maximumLineCount: 1
            }

            Rectangle {
                id: unread_rect
                height: units.gu(2.5)
                radius: width*0.5
                width: unread_txt.width + units.gu(1.5)
                anchors.verticalCenter: parent.bottom
                anchors.right: parent.right
                color: model.mute? "grey" : "#5ec245"
                visible: model.unreadCount

                Text {
                    id: unread_txt
                    anchors.centerIn: parent
                    font.weight: Font.DemiBold
                    font.pixelSize: FontUtils.sizeToPixels("small")
                    color: "white"
                    text: model.unreadCount
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#cc000000"
        visible: dropArea.containsDrag

        Text {
            anchors.centerIn: parent
            font.family: Awesome.family
            font.pixelSize: 14*Devices.fontDensity
            color: "#ffffff"
            text: Awesome.fa_mail_forward
        }
    }

    Telegram.InputPeer {
        id: inputPeer
    }

    DropArea {
        id: dropArea
        anchors.fill: parent
        onDropped: {
            var formats = drop.formats
            var type = drop.getDataAsString("cutegram/dragType")
            switch(Math.floor(type)) {
            case CutegramEnums.dragDataTypeMessage:
                inputPeer.classType = drop.getDataAsString(CutegramEnums.dragDataMessageClassType)
                inputPeer.channelId = drop.getDataAsString(CutegramEnums.dragDataMessageChannelId)
                inputPeer.chatId = drop.getDataAsString(CutegramEnums.dragDataMessageChatId)
                inputPeer.userId = drop.getDataAsString(CutegramEnums.dragDataMessageUserId)
                inputPeer.accessHash = Math.floor(drop.getDataAsString(CutegramEnums.dragDataMessageAccessHash))
                forwardRequest(inputPeer, drop.getDataAsString(CutegramEnums.dragDataMessageMsgId))
                break;
            case CutegramEnums.dragDataTypeExternal:
                break;
            case CutegramEnums.dragDataTypeContact:
                break;
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if(mouse.button == Qt.RightButton) {
                var act = Desktop.showMenu([qsTr("Mark as read"), "",
                                            qsTr("Clear history")])
                switch(act) {
                case 0:
                    model.unreadCount = 0
                    break
                case 2:
                    //if(Desktop.yesOrNo(CutegramGlobals.mainWindow, qsTr("Clear History?"), qsTr("Are you sure about clear history?")))
                    clearHistoryRequest(model.peer)
                    break
                }
            } else {
                active()
            }
        }
        z: -1
    }
}

