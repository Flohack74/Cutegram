import QtQuick 2.3
import Ubuntu.Components 1.3
import TelegramQml 2.0 as Telegram
import "globals"
import "account" as Account

MainView {
    id: mainView
    objectName: "appMainView"
    width: units.gu(38)
    height: units.gu(50)
    focus: true

    applicationName: "com.ubuntu.telegram"
    anchorToKeyboard: true
    automaticOrientation: true

    property string appId: "com.ubuntu.telegram_telegram" // no-i18n

    property string applicationVersion: "2.9.0"

    /*Notification {
        id: notification
    }*/

    Telegram.ProfileManagerModel {
        id: profilesModel
        source: CutegramGlobals.profilePath + "/profiles.sqlite"
        engineDelegate: Account.CutegramAccountEngine {
            //notificationManager: notification
        }

        readonly property int unreadCount: {
            var res = 0
            for(var i=0; i<count; i++)
            	if (get(i, Telegram.ProfileManagerModel.DataEngine))
                	res += get(i, Telegram.ProfileManagerModel.DataEngine).unreadCount
            return res
        }

        Component.onCompleted: if(count == 0) addNew()
    }

    ListView {
        id: listView
        anchors.fill: parent
        width: parent.width
        clip: true
        interactive: false
        orientation: ListView.Horizontal
        highlightRangeMode: ListView.StrictlyEnforceRange
        model: profilesModel
        delegate: Account.AccountMain {
            width: listView.width
            height: listView.height
            engine: model.engine
        }
    }

    FontLoader {
        source: "awesome/fontawesome-webfont.ttf"
    }
}
