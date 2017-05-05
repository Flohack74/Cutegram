import QtQuick 2.4
import Ubuntu.Components 1.3 as Components
import TelegramQml 2.0

//import "qrc:/qml/js/avatar.js" as Avatar
//import "qrc:/qml/js/colors.js" as Colors

Components.PageHeader {
    id: header

    property Engine engine
    property InputPeer currentPeer

    title: details.displayName
    property string subtitle: details.statusText

    signal clicked()

    PeerDetails {
        id: details
        engine: header.engine
        peer: header.currentPeer
    }

    contents: Item {
        anchors.fill: parent

        ProfileImage {
            id: img
            width: height
            height: units.gu(4)
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            engine: header.engine
            source: header.currentPeer
        }

        /*Avatar {
            id: headerImage
            width: height
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            telegram: header.telegram
            dialog: header.dialog

            RotationAnimation {
                id: connectingAnimation
                target: headerImage
                direction: RotationAnimation.Clockwise
                from: 0
                to: 359
                loops: Animation.Infinite
                duration: 5000
                alwaysRunToEnd: false
                running: isConnecting && headerImage.isLogo
                properties: "rotation"

                onRunningChanged: {
                    if (!running) {
                        connectingAnimation.stop();
                        headerImage.rotation = 0;
                    }
                }
            }
        }

        //'Lock' image that is overlayed ontop of the Avatar conponent
        Image {
            id: secretChatImage
            anchors {
                left: headerImage.right
                leftMargin: -width-5
                top: headerImage.top
                topMargin: units.dp(2)
            }
            width: units.gu(1)
            height: units.gu(1.5)
            source: "qrc:/qml/files/lock.png"
            sourceSize: Qt.size(width, height)
            visible: header.isSecretChat
        }*/

        Components.Label {
            id: titleText
            anchors {
                top: parent.top
                left: img.right
                leftMargin: units.gu(1)
            }
            verticalAlignment: Text.AlignVCenter
            width: parent.width

            fontSize: "large"
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            maximumLineCount: 1
            text: header.title.length === 0 ? i18n.tr("Telegram") : header.title

            state: header.subtitle.length > 0 ? "subtitle" : "default"
            states: [
                State {
                    name: "default"
                    AnchorChanges {
                        target: titleText
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    PropertyChanges {
                        target: titleText
                        height: parent.height
                        anchors.topMargin: units.gu(0.7)
                    }
                },
                State {
                    name: "subtitle"
                    PropertyChanges {
                        target: titleText
                        height: parent.height / 2
                        anchors.topMargin: units.gu(0.35)
                    }
                }
            ]

            transitions: [
                Transition {
                    AnchorAnimation {
                        duration: Components.UbuntuAnimation.FastDuration
                    }
                }
            ]
        }

        Components.Label {
            id: subtitleText
            anchors {
                left: img.right
                leftMargin: units.gu(1)
                bottom: parent.bottom
                bottomMargin: units.gu(0.15)
            }
            verticalAlignment: Text.AlignVCenter
            height: parent.height / 2
            width: parent.width

            fontSize: "small"
            elide: Text.ElideRight
            wrapMode: Text.WordWrap
            maximumLineCount: 1
            text: header.subtitle
            color: "grey"

            Connections {
                target: header
                onSubtitleChanged: {
                    subtitleText.opacity = 0;
                    subtitleText.text = "";
                    subtitleTextTimer.start();
                }
            }

            Timer {
                id: subtitleTextTimer
                interval: Components.UbuntuAnimation.FastDuration
                onTriggered: {
                    subtitleText.text = header.subtitle;
                    subtitleText.opacity = 1;
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: Components.UbuntuAnimation.FastDuration
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                mouse.accepted = true;
                header.clicked();
            }
        }
    }
}
