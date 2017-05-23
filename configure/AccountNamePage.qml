import QtQuick 2.4
import Ubuntu.Components 1.3

import TelegramQml 2.0 as Telegram
import "../toolkit" as ToolKit

ToolKit.StackedPage {
    id: page

    //property Telegram telegram

    property alias firstName: first_name_text_field.text
    property alias lastName: last_name_text_field.text
    property alias error: error_text_field.text

    header: PageHeader {
        title: i18n.tr("Edit name");
        trailingActionBar.actions: [
            Action {
                iconName: "ok"
                text: i18n.tr("Save")
                onTriggered: updateProfile();
            }
        ]
    }
    function updateProfile() {
        Qt.inputMethod.commit();
        error = "";
        if (firstName.length > 0) {
            // @TODO: implement this
            /* telegram.accountUpdateProfile(firstName, lastName); */
            pageStack.removePages(page);
        } else {
            // TRANSLATORS: Error message when first name was not provided.
            error = i18n.tr("First name is required.");
        }
    }

    TextField {
        id: first_name_text_field
        anchors {
            top: page.header.bottom
            topMargin: units.gu(4)
            left: parent.left
            leftMargin: units.gu(2)
            right: parent.right
            rightMargin: units.gu(2)
        }
        validator: RegExpValidator {
            regExp: /[\w\s]+/
        }
        // TRANSLATORS: This is a placeholder in the 'first name' text field.
        placeholderText: i18n.tr("First name (required)")
        inputMethodHints: Qt.ImhNoPredictiveText
        Keys.onReturnPressed: last_name_text_field.forceActiveFocus()
    }

    TextField {
        id: last_name_text_field
        anchors {
            top: first_name_text_field.bottom
            topMargin: units.gu(2)
            left: parent.left
            leftMargin: units.gu(2)
            right: parent.right
            rightMargin: units.gu(2)
        }
        validator: RegExpValidator {
            regExp: /[\w\s]+/
        }
        // TRANSLATORS: This is a placeholder in the 'last name' text field.
        placeholderText: i18n.tr("Last name (optional)")
        inputMethodHints: Qt.ImhNoPredictiveText
        Keys.onReturnPressed: addContact()
    }

    Text {
        id: error_text_field
        anchors {
            top: last_name_text_field.bottom
            topMargin: units.gu(2)
            left: parent.left
            right: parent.right
        }
        horizontalAlignment: Text.AlignHCenter
        color: "red"
    }
}
