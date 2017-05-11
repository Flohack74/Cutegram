import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Layouts 1.0
import "../globals"

Rectangle {
    id: page
    objectName: "introPage"
    anchors.fill: parent

    property alias startMessagingButton: startMessagingButton
    property alias currentIndex: slider.currentIndex

    signal startRequest()

    IntroPageListModel {
        id: introModel
    }

    Layouts {
        id: layouts
        anchors.fill: parent

        Rectangle {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                topMargin: units.gu(4)
                bottom: item_button.top
                bottomMargin: units.gu(2)
            }
            color: TelegramColors.white

            Layouts.item: "item_body"

            CrossFadeImage {
                id: icon

                anchors {
                    bottom: parent.verticalCenter
                    bottomMargin: units.gu(2)
                    horizontalCenter: parent.horizontalCenter
                }
                width: units.gu(16)
                height: width
                z: 2

                fadeDuration: 250
                fillMode: Image.PreserveAspectFit
            }

            ListView {
                id: slider

                anchors.fill: parent
                z: 1

                orientation: ListView.Horizontal
                snapMode: ListView.SnapOneItem
                boundsBehavior: Flickable.StopAtBounds
                cacheBuffer: width
                clip: true
                highlightFollowsCurrentItem: true
                highlightRangeMode: ListView.StrictlyEnforceRange

                model: introModel
                delegate: Rectangle {
                    id: delegateRect
                    width: slider.width
                    height: slider.height

                    Rectangle {
                        width: parent.width
                        height: units.gu(10)
                        anchors.horizontalCenter: delegateRect.horizontalCenter
                        y: icon.y + icon.height + units.gu(3)

                        Text {
                            id: titleText
                            anchors.top: parent.top
                            width: parent.width

                            horizontalAlignment: TextInput.AlignHCenter
                            font.pixelSize: FontUtils.sizeToPixels("large")
                            color: TelegramColors.black
                            text: title
                        }
                        Text {
                            id: bodyText
                            anchors {
                                top: titleText.bottom
                                topMargin: units.gu(1.5)
                                // Why don't these work?
                                leftMargin: units.gu(15)
                                rightMargin: units.gu(3)
                            }
                            width: parent.width

                            horizontalAlignment: TextInput.AlignHCenter
                            font.pixelSize: FontUtils.sizeToPixels("medium")
                            wrapMode: Text.WordWrap
                            color: TelegramColors.darkGrey
                            text: body
                        }
                    }
                }

                onCurrentIndexChanged: {
                    icon.source = "files/intro" + (currentIndex + 1) + ".png";
                }
            }

            Row {
                id: indicator
                height: units.gu(4)
                spacing: units.dp(8)
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 0
                    horizontalCenter: parent.horizontalCenter
                }
                z: 2

                Repeater {
                    model: introModel.count
                    delegate: Rectangle {
                        height: width
                        width: units.dp(6)
                        antialiasing: true
                        color: slider.currentIndex == index ? TelegramColors.blue : TelegramColors.grey
                        Behavior on color {
                            ColorAnimation {
                                duration: UbuntuAnimation.FastDuration
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: item_button
            Layouts.item: "item_button"
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                bottomMargin: units.gu(4)
            }
            width: page.width
            height: startMessagingButton.height

            Button {
                id: startMessagingButton
                objectName: "startMessagingButton"
                z: 2
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                color: TelegramColors.activeColor
                font: Qt.font({family: "Ubuntu", pixelSize: FontUtils.sizeToPixels("medium"), color: TelegramColors.activeText})
                // TRANSLATORS: Text of the button visible on the intro pages.
                text: i18n.tr("Start Messaging")                

                onClicked: page.startRequest()
            }
        }

    }

    function forceActiveFocus() {
        startMessagingButton.forceActiveFocus()
    }
}
