import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.0
import TelegramQml 2.0 as Telegram
import "../globals"

Page {
    id: auth_phone_page
    objectName: "authPhonePage"

    property string countryCode: ""
    property string fullPhoneNumber: {
        return (countryCode != "" ? "+" : "") + countryCode + phoneNumber;
    }
    property bool accountAlreadyExists: true

    property alias phoneNumber: phone_number.text
    property alias error: error_label.text

    signal phoneEntered(string number)

    focus: true
    flickable: null

    header: PageHeader {
        title: i18n.tr("Phone Number")
    }

    Component.onCompleted: phone_number.forceActiveFocus()

    Label {
        id: country_code
        objectName: "countryCode"
        anchors {
            top: auth_phone_page.header.bottom
            topMargin: units.gu(4)
            left: parent.left
            leftMargin: units.gu(4)
            right: parent.right
            rightMargin: units.gu(4)
        }
        fontSize: "large"
        text: (countryCode != "" ? "+" : "") + countryCode
    }

    Column {
        id: column
        anchors {
            top: country_code.bottom
            left: parent.left
            right: parent.right
            margins: units.gu(4)
        }
        spacing: units.gu(2)

        TextField {
            id: phone_number
            objectName: "phoneNumberEntry"
            width: column.width
            inputMethodHints: Qt.ImhDialableCharactersOnly
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            placeholderText: i18n.tr("Phone Number")
            validator: RegExpValidator { regExp: /(?!0)\d*/ }
            onAccepted: {
                checkForDupe();
            }
        }

        Button {
            id:doneButton
            objectName: "doneButton"
            width: phone_number.width
            height: phone_number.height
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Done")
            color: TelegramColors.activeColor
            font: Qt.font({family: "Ubuntu", pixelSize: FontUtils.sizeToPixels("medium"), color: TelegramColors.activeText})

            enabled: phoneNumber.length > 0
            focus: true
            onClicked: phone_number.accepted()
        }

        Label {
            id: error_label
            width: phone_number.width
            visible: text != ""
            color: "red"
        }
    }

    onPhoneNumberChanged:{
        if (phoneNumber.length > 0) {
            //PhoneNumber contains 1 or more letter
            error_label.text = "";
            doneButton.enabled = true;
        } else {
            //PhoneNumber doesn't contain any letters
            doneButton.enabled = false;
        }
    }

    /*function showConfirmationMessage() {
        Qt.inputMethod.hide();
        PopupUtils.open(Qt.resolvedUrl("qrc:/qml/ui/dialogs/ConfirmationDialog.qml"),
            auth_phone_page, {
                // TRANSLATORS: Dialog prompt to ensure provided number is correct.
                title: i18n.tr("Number correct?"),
                text: i18n.tr(auth_number_page.fullPhoneNumber),
                onAccept: function() {
                    auth_phone_page.phoneEntered("+" + countryCode + phoneNumber)
                }
            }
        );
    }*/

    function checkForDupe () {
        accountAlreadyExists = false;
        var profiles = []; // @TODO: remove and fix this

        //Check available profiles
        if (!profiles.count < 1) {
            for (var i = 0; i < profiles.count; i++) {
                var key = profiles.keys[i];
                checkForDupeTimer.restart();

                //Stop checking profiles if a dupe is found
                if (accountAlreadyExists != true) {
                    if (auth_number_page.fullPhoneNumber != key) {
                        //Dupe Not found
                        accountAlreadyExists = false;
                    } else {
                        //Dupe found
                        accountAlreadyExists = true;
                    }
                }
            }
        } else {
            doneButton.enabled = true;
            //showConfirmationMessage(); // @TODO: fix this
            auth_phone_page.phoneEntered(fullPhoneNumber)
        }
    }

    Timer {
        id:checkForDupeTimer
        interval: 50
        repeat: false
        onTriggered:{
            if (accountAlreadyExists == true) {
                //Dupe found
                doneButton.enabled = false;
                accountAlreadyExists = true;
                error_label.text = i18n.tr("Phone number already exists.");
            } else {
                //Dupe not found
                doneButton.enabled = true;
                //showConfirmationMessage(); // @TODO: fix this
                auth_phone_page.phoneEntered(fullPhoneNumber)
            }
        }
    }
}
