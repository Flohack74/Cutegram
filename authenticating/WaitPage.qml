import QtQuick 2.4
import Ubuntu.Components 1.3
import AsemanTools 1.0

Page {
    signal request()

    property alias text: txt.text

    Keys.onEscapePressed: BackHandler.back()

    Column {
        anchors.centerIn: parent
        spacing: 4*Devices.density

        Indicator {
            id: indicator
            running: true
            anchors.horizontalCenter: parent.horizontalCenter
            modern: true
            light: false
            indicatorSize: 20*Devices.density
        }

        Text {
            id: txt
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 10*Devices.fontDensity
            color: "#333333"
        }
    }
}

