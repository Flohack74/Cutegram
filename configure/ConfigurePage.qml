import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItems
import Ubuntu.Components.Popups 1.3 as Popup
import Ubuntu.Content 1.3
import TelegramQml 2.0 as Telegram
//import "../awesome"
import "../toolkit" as ToolKit
import "../globals"
import "../js/time.js" as Time

ToolKit.StackedPage {
    id: settings_page

    header: PageHeader {
        title: i18n.tr("Settings")
        trailingActionBar.actions: [
            Action {
                iconName: "stock_image"
                // TRANSLATORS: Action text to change profile photo.
                text: i18n.tr("Change photo")
                onTriggered: changeUserPhoto()
                
            },
            Action {
                iconName: "edit"
                // TRANSLATORS: Edit your profile first and last name.
                text: i18n.tr("Edit name")
                onTriggered: changeFullName()
            }
        ]
    }

    Connections {
        target: engine
        onAuthLoggedOut: {
            stack.hideWaitOverlay();
            engine.phoneNumber = ""
        }
    }

    objectName: "settingsPage"

    function changeFullName() {
        var properties = { "engine": engine, "stack": stack , "firstName": engine.our.user.firstName, "lastName": engine.our.user.lastName };
        stack.addPageToNextColumn(settings_page, name_page_component, properties);
    }

    function changeUsername() {
        var properties = { "engine": engine, "stack": stack };
        stack.addPageToNextColumn(settings_page, username_page_component, properties);
    }

    function changeUserPhoto() {
        Qt.inputMethod.hide();
        photo_importer.requestMedia();
    }

    Component {
        id: name_page_component

        AccountNamePage {}
    }

    Component {
        id: username_page_component

        AccountUsernamePage {}
    }

    ToolKit.MediaImport {
        id: photo_importer
        contentType: ContentType.Pictures

        onMediaReceived: {
            if (urls.length > 0) {
                var path = String(urls[0]).replace('file://', '')
                if (path.length == 0) return
                edit_photo_timer.upload(path)
            } else {
                console.log("[ConfigurePage] no photo selected")
            }
        }
    }
 
    Timer {
        id: edit_photo_timer

        property string photo: ""

        interval: 500

        function upload(photoPath) {
            stop();
            photo = photoPath;
            restart();
        }

        onTriggered: {
            // @TODO: implement this
            /*if (telegram.connected) {
                telegram.setProfilePhoto(photo);
            }*/
        }
    }

    VisualItemModel {
        id: model

        ListItems.Header {
            // TRANSLATORS: Settings section header, visible above phone and username fields.
            text: i18n.tr("Info")
        }

        ListItem {
            divider.visible: false
            height: units.gu(6)
            ListItemLayout {
                id: phoneNumberLayout
                title.text: engine.our.user.phone
                // TRANSLATORS: Visible right under phone number in settings page.
                subtitle.text: i18n.tr("Phone")
                padding.bottom: units.gu(1)
                padding.top: units.gu(1)
            }
        }

        ListItem {
            divider.visible: false
            height: units.gu(6)
            ListItemLayout {
                id: usernameLayout
                title.text: engine.our.user.username
                // TRANSLATORS: Visible right under username in settings page.
                subtitle.text: i18n.tr("Username")
                padding.bottom: units.gu(1)
                padding.top: units.gu(1)
            }
            onClicked: changeUsername()
        }

        ListItems.Header {
            // TRANSLATORS: Settings section header.
            text: i18n.tr("Messages")
        }

        // @TODO: implement this
        /*ListItem {
            divider.visible: false
            height: visible ? units.gu(6) : 0
            visible: (Cutegram.pushNumber === engine.our.user.phone)

            ListItemLayout {
                id: notificationLayout
                // TRANSLATORS: Text of notifications switch in settings.
                title.text: i18n.tr("Notifications")

                Switch {
                    checked: Cutegram.pushNotifications
                    SlotsLayout.position: SlotsLayout.Last

                    onCheckedChanged: {
                        Cutegram.pushNotifications = checked;

                        if (pushClient.token == "") {
                            if (checked) {
                                Cutegram.pushNotifications = false;
                                mainView.openPushDialog();
                            }
                        } else {
                            if (checked) {
                                pushClient.registerForPush();
                            } else {
                                pushClient.unregisterFromPush();
                            }
                        }
                    }
                }
            }
        }*/

        ListItem {
            divider.visible: false
            height: units.gu(6)
            ListItemLayout {
                title.text: i18n.tr("Send by Enter")

                Switch {
                    checked: CutegramSettings.sendWithEnter
                    SlotsLayout.position: SlotsLayout.Last
                    onCheckedChanged: CutegramSettings.sendWithEnter = checked
                }
            }
        }

        // @TODO: terminate all sessions

        ListItems.Header {
            // TRANSLATORS: Settings section header.
            text: i18n.tr("Support")
        }

        ListItem {
            height: units.gu(6)
            divider.visible: false
            ListItemLayout {
                // TRANSLATORS: Text of settings item visible in the Support section.
                title.text: i18n.tr("Ask a Question")
            }
            onClicked: Qt.openUrlExternally("http://askubuntu.com/search?q=telegram")
        }

        ListItem {
            height: units.gu(6)
            divider.visible: false
            ListItemLayout {
                // TRANSLATORS: Text of settings item visible in the Support section
                title.text: i18n.tr("Telegram FAQ")
            }
            onClicked: Qt.openUrlExternally("https://telegram.org/faq")
        }

        ListItem {
            height: units.gu(4)
            ListItemLayout {
                // TRANSLATORS: Settings section header.
                title.text: i18n.tr("Account")
                title.font.weight: Font.DemiBold
                padding.bottom: units.gu(1)
                padding.top: units.gu(1)
            }
        }

        ListItem {
            objectName: "listItem_logout"
            height: units.gu(6)
            ListItemLayout {
                title.text: i18n.tr("Log out") + " | " + engine.our.user.phone
            }
            onClicked: PopupUtils.open(logout_dialog_component)
        }

        ListItem {
            divider.visible: false
            Label {
                width: parent.width
                height: units.gu(6)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                // TRANSLATORS: Visible at bottom of settings screen. The argument is application version.
                text: i18n.tr("Telegram for Ubuntu %1").arg(getVersionString())

                function getVersionString() {
                    var v = CutegramGlobals.applicationVersion.split(".");
                    var major = v[0];
                    var minor = v[1];
                    var patch = v[2];
                    var revision = v.slice(3, v.length).join(".");
                    return "v" + major + "." + minor + "." + patch + " (" + revision + ")";
                }
            }
        }
    }

    ToolKit.ProfileImage {
        id: profile_image
        anchors {
            top: settings_page.header.bottom
            topMargin: units.gu(2)
            left: parent.left
            leftMargin: units.gu(2)
        }
        width: units.gu(9)
        height: width
        source: engine.our? engine.our.user : null
        engine: settings_page.engine


        MouseArea {
            anchors.fill: parent
            onClicked: {
                if(profile_image.downloaded)
                    profile_image.open()
                else
                if(!profile_image.downloading) {
                    profile_image.download()
                    profile_image.downloadedChanged.connect(profile_image.open)
                }
            }
        }

        function open() {
            //engine.openFile(destination)
            /*stack.addPageToNextColumn(settings_page, preview_page_component, {
                "title": details_item.title,
                "photoPreviewSource": destination
            });*/
            profile_image.downloadedChanged.disconnect(profile_image.open)
        }
    }

    ListItem {
        id: details_item
        anchors {
            left: profile_image.right
            right: parent.right
            verticalCenter: profile_image.verticalCenter
        }

        height: itemLayout.height
        divider.visible: false

        ListItemLayout {
            id: itemLayout

            title.font.bold: true
            title.wrapMode: Text.Wrap
            title.textSize: Label.Large
            title.maximumLineCount: 2

            title.text: engine.our.user.firstName + " " + engine.our.user.lastName
            subtitle.text: {
                var result = "";
                switch(engine.our.user.status.classType)
                {
                case Telegram.UserStatus.TypeUserStatusEmpty:
                    return "";
                case Telegram.UserStatus.TypeUserStatusOnline:
                    // TRANSLATORS: Indicates when the contact was last seen.
                    return i18n.tr("online");
                case Telegram.UserStatus.TypeUserStatusOffline:
                    // TRANSLATORS: %1 is the time when the person was last seen.
                    return i18n.tr("last seen %1").arg(Time.formatLastSeen(i18n, engine.our.user.status.wasOnline * 1000));
                case Telegram.UserStatus.TypeUserStatusRecently:
                    // TRANSLATORS: Indicates when the contact was last seen.
                    return i18n.tr("last seen recently");
                case Telegram.UserStatus.TypeUserStatusLastWeek:
                    // TRANSLATORS: Indicates when the contact was last seen.
                    return i18n.tr("last seen within a week");
                case Telegram.UserStatus.TypeUserStatusLastMonth:
                    // TRANSLATORS: Indicates when the contact was last seen.
                    return i18n.tr("last seen within a month");
                default:
                    // TRANSLATORS: Indicates when the contact was last seen.
                    return i18n.tr("last seen a long time ago");
                }
            }
        }
    }

    ListView {
        objectName: "settingsList"
        anchors {
            topMargin: units.gu(2)
            top: profile_image.bottom
            left: parent.left
            bottom: parent.bottom
            right: parent.right
        }
        clip: true
        model: model
    }

    Component {
        id: logout_dialog_component
        Popup.Dialog {
            id: logout_dialog
            objectName: "logoutDialog"
            title: i18n.tr("Telegram")
            text: i18n.tr("Are you sure you want to log out?\nAny secret chats will be lost.")
            Button {
                objectName: "logoutConfirm"
                text: i18n.tr("OK")
                color: UbuntuColors.orange
                onClicked: {
                    console.log("Logging out.");
                    engine.logout();
                    PopupUtils.close(logout_dialog);
                    stack.showWaitOverlay(i18n.tr("Logging out..."));
                }
            }
            Button {
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(logout_dialog)
            }
        }
    }
}
