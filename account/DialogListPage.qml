import QtQuick 2.4
import Ubuntu.Components 1.3
import TelegramQml 2.0
import Ubuntu.Components 1.3 as Components
import "../toolkit" as ToolKit
import "panel" as Panel

Components.Page {
    id: dialogListPage

    property Engine engine
    property alias currentPeer: dlist.currentPeer

    header: Components.PageHeader {
        title: i18n.tr("Telegram")
        leadingActionBar.actions: Action {
            objectName: "navigationMenu"
            iconName: "navigation-menu"
            onTriggered: {
                accountPanel.opened ? accountPanel.close() : accountPanel.open()
            }
        }
    }

    signal addNewClicked()
    signal contactsClicked()
    signal settingsClicked()

    signal addAccountClicked()
    signal accountClicked(string number)

    signal peerInfoRequest(variant inputPeer)

    Panel.AccountPanel {
        id: accountPanel
        objectName:"accountPanel"
        anchors {
            left: parent.left
            top: parent.top
            topMargin: dialogListPage.header.height
        }
        maxHeight: parent.height - units.gu(7)
        z: 10

        onAddNewClicked: dialogListPage.addNewClicked()
        onContactsClicked: dialogListPage.contactsClicked()
        onSettingsClicked: dialogListPage.settingsClicked()

        onAddAccountClicked: dialogListPage.addAccountClicked()
        onAccountClicked: {
            dialogListPage.accountClicked(number)
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height

        ToolKit.DialogList {
            id: dlist
            width: parent.width
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            engine: dialogListPage.engine
            onPeerInfoRequest: dialogListPage.peerInfoRequest(inputPeer)
        }
    }
}

