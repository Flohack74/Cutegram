import QtQuick 2.4
import Ubuntu.Components 1.3
import TelegramQml 2.0
import "../authenticating" as Authenticating
import "../toolkit" as ToolKit
//import "../add" as Add
import "../configure" as Configure
import "../contacts" as Contacts
import "../globals"

Rectangle {
    id: accountMain
    property Engine engine

    AdaptivePageLayout {
        objectName: "APL"
        id: pageStack

        property Item authentication
        property Item dialogList

        property alias engine: accountMain.engine
        property InputPeer currentPeer: dialogList ? dialogList.currentPeer : null

        property bool forceSinglePage: false

        asynchronous: false
        anchors.fill: parent
        layouts: [
            PageColumnsLayout {
                // gu(80) is standard value. Would prefer not to type it in,
                // but can't have !forceSinglePage as the only value here.
                when: pageStack.width > units.gu(80) && !pageStack.forceSinglePage
                PageColumn {
                    minimumWidth: units.gu(35)
                    maximumWidth: units.gu(35)
                    preferredWidth: units.gu(35)
                }
                PageColumn {
                    fillWidth: true
                }
            },
            PageColumnsLayout {
                when: true
                PageColumn {
                    fillWidth: true
                    minimumWidth: units.gu(30)
                }
            }
        ]

        signal signedIn()

        Connections {
            target: engine
            onStateChanged: {
                console.debug("Engine state changed: %1".arg(engine.state))
                pageStack.checkAuth(false)
            }
        }

        function checkAuth(firstInitialize) {
            if (engine.phoneNumber.length == 0 || engine.state == Engine.AuthNeeded) {
                if (!authentication)
                    authentication = auth_component.createObject(pageStack)
                if (!firstInitialize)
                    pageStack.clear()
                pageStack.primaryPage = authentication;
                pageStack.forceSinglePage = true;
                if (dialogList)
                    dialogList.destroy()
            }
            else if (engine.state == Engine.AuthLoggedIn || firstInitialize)
            {
                if (!dialogList)
                    dialogList = dialog_list_component.createObject(pageStack)
                if (!firstInitialize)
                {
                    signedIn()
                    pageStack.clear()
                }
                pageStack.forceSinglePage = false;
                pageStack.primaryPage = dialogList;
                if (authentication)
                    authentication.destroy()
            }
        }

        function clear() {
            pageStack.removePages(pageStack.primaryPage);
        }

        Component {
            id: auth_component
            AuthenticationPage {
                id: authPage
                engine: pageStack.engine
                stack: pageStack
            }
        }

        Component {
            id: dialog_list_component
            DialogListPage {
                id: dialogListPage
                engine: pageStack.engine
                onCurrentPeerChanged: {
                    pageStack.addPageToNextColumn(dialogListPage, dialog_component, {
                        "currentPeer": currentPeer
                    });
                }
                /*onAddNewClicked: {
                    pageStack.addPageToCurrentColumn(dialogListPage, add_new_component);
                }*/
                onContactsClicked: {
                    pageStack.addPageToCurrentColumn(dialogListPage, contacts_component);
                }
                onSettingsClicked: {
                    pageStack.addPageToNextColumn(dialogListPage, configure_component);
                }
                /*onAddAccountClicked: {
                }
                onAccountClicked: {
                }*/
                onPeerInfoRequest: {
                    pageStack.addPageToNextColumn(dialogListPage, dialog_details_component, {
                        "currentPeer": inputPeer
                    });
                }
            }
        }

        Component {
            id: dialog_component
            DialogPage {
                id: dialogPage
                engine: pageStack.engine
                stack: pageStack
                onPeerInfoRequest: {
                    pageStack.addPageToNextColumn(dialogPage, dialog_details_component, {
                        "currentPeer": inputPeer,
                    });
                }
            }
        }

        Component {
            id: dialog_details_component
            DialogDetailsPage {
                id: dialogDetailsPage
                engine: pageStack.engine
                stack: pageStack
            }
        }

        /*Component {
            id: add_new_component
            Add.AddNewPage {
                id: addPage
                engine: pageStack.engine
                stack: pageStack
            }
        }*/

        Component {
            id: contacts_component
            Contacts.ContactsPage {
                id: contactsPage
                engine: pageStack.engine
                stack: pageStack
                onContactActivated: {
                    pageStack.clear()
                    pageStack.dialogList.currentPeer = peer
                }
            }

        }

        Component {
            id: configure_component
            Configure.ConfigurePage {
                id: configurePage
                engine: pageStack.engine
                stack: pageStack
            }
        }

        Component.onCompleted: checkAuth(true)
    }
}