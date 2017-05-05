/*
 * Copyright 2015 Canonical Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import QtGraphicalEffects 1.0
import "../../toolkit" as ToolKit
import "../../awesome"

Panel {
    id: panel

    // This property must be set to desired max height value.
    property int maxHeight: units.gu(16)

    signal addNewClicked()
    signal contactsClicked()
    signal settingsClicked()
    signal faqClicked()

    signal addAccountClicked()
    signal accountClicked(string number)

    height: column.height < maxHeight ? column.height : maxHeight
    width: parent.width / 10 * 8
    animate: true
    align: Qt.AlignLeading
    visible: opened || animating

    Rectangle {
        id: background
        anchors.fill: parent
        color: "white"
    }

    ToolKit.EdgeShadow {
        source: background
    }

    InverseMouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onPressed: accountPanel.close()
    }

    Flickable {
        anchors.fill: parent
        clip: true
        contentHeight: column.height
        interactive: column.height > parent.height

        Column {
            id: column

            anchors {
                top: parent.top
                right: parent.right
                left: parent.left
            }

            AccountPanelItem {
                objectName:"addNewItem"
                icon: Awesome.fa_plus
                text: i18n.tr("Add new...")
                showDivider: false
                onClicked: {
                    panel.close();
                    panel.addNewClicked();
                }
            }
            /*AccountPanelItem {
                objectName:"groupChatItem"
                icon: "../files/menu_newgroup.png"
                text: i18n.tr("New Group")
                showDivider: false
                onClicked: {
                    panel.close();
                    panel.newGroupClicked();
                }
            }
            AccountPanelItem {
                objectName:"secretChatItem"
                icon: "../files/menu_secret.png"
                text: i18n.tr("New Secret Chat")
                onClicked: {
                    panel.close();
                    panel.newSecretChatClicked();
                }
            }*/
            AccountPanelItem {
                objectName:"panelContacts"
                icon: Awesome.fa_users
                text: i18n.tr("Contacts")
                showDivider: false
                onClicked: {
                    panel.close();
                    panel.contactsClicked();
                }
            }
            AccountPanelItem {
                objectName:"panelSettings"
                icon: Awesome.fa_cog
                text: i18n.tr("Settings")
                showDivider: false
                onClicked: {
                    panel.close();
                    panel.settingsClicked();
                }
            }
            AccountPanelItem {
                icon: Awesome.fa_question_circle
                text: i18n.tr("Telegram FAQ")
                showDivider: false
                onClicked: {
                    panel.close();
                    panel.faqClicked();
                }
            }

            Rectangle {
                anchors {
                    left: parent.left
                    right: parent.right
                }
                height: section_label.height
                color: Qt.rgba(0.6, 0.6, 0.6, 0.2)

                Label {
                    id: section_label
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        right: parent.right
                        rightMargin: units.gu(2)
                    }
                    // TRANSLATORS: Main menu list separator, right above signed in accounts list.
                    text: i18n.tr("Accounts")
                    height: units.gu(4)
                    fontSize: "medium"
                    font.weight: Font.DemiBold
                    verticalAlignment: Text.AlignVCenter
                }
            }

            /*Repeater {
                id: aclist
                model: profiles
                delegate: AccountPanelItem {
                    icon: ""
                    text: number
                    showDivider: false
                    showProgression: profiles.count > 1
                    onClicked: {
                        panel.close();
                        if (profiles.count > 1) {
                            panel.accountClicked(number)
                        }
                    }
                }
            }*/

            AccountPanelItem {
                icon: Awesome.fa_user_plus
                text: i18n.tr("Add Account")
                showDivider: false
                onClicked: {
                    panel.close();
                    panel.addAccountClicked();
                }
            }
        }

    }


}
