import QtQuick 2.4
import Ubuntu.Components 1.3
import TelegramQml 2.0 as Telegram
import QtGraphicalEffects 1.0
import "../awesome"
import "../globals"

Item {
    property alias source: avatar_img.source
    property alias engine: avatar_img.engine
    property alias color: back.color
    property alias error: avatar_img.errorText
    property alias downloaded: avatar_img.downloaded
    property alias downloading: avatar_img.downloading
    property alias destination: avatar_img.destination

    property string title: source.title ? source.title : source.firstName + " " + source.lastName

    Rectangle {
        id: avatar_mask
        anchors.fill: parent
        radius: width/2
        visible: false
    }

    Telegram.Image {
        id: avatar_img
        width: parent.width*2
        height: parent.height*2
        source: null
        engine: null
        smooth: true
        visible: false
    }

    OpacityMask {
        anchors.fill: parent
        source: avatar_img
        maskSource: avatar_mask
    }

    Rectangle {
        id: back
        anchors.fill: parent
        radius: width/2
        color: getColor(source.id)
        visible: !avatar_img.thumbnailDownloaded && !avatar_img.downloaded

        Label {
            id: initialsLabel
            anchors.centerIn: parent
            fontSize: "large"
            color: "white"
            text:  getInitialsFromTitle(title)
        }
    }

    function download() {
        avatar_img.download()
    }

    function getColor(userId) {
        userId = userId || 0;

        var AVATARS = [
            "#8179d7",
            "#f2749a",
            "#7ec455",
            "#f3c34a",
            "#5b9dd8",
            "#62b8cd",
            "#ed8b4a",
            "#d95848"
        ];

        return AVATARS[userId % 8];
    }

    function getInitialsFromTitle(title) {
        var text = "";
        if (title.length > 0) {
            text = title[0];
        }
        if (title.indexOf(" ") > -1) {
            var lastchar = "";
            for (var a = title.length-1; a > 0; a--) {
                if (lastchar !== "" && title[a] === " ") {
                    break;
                }
                lastchar = title[a];
            }
            text += lastchar;
        }
        return text.toUpperCase();
    }
}