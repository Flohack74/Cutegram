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
import "../../awesome"

ListItem {
    id: item

    property bool showDivider: true

    property string icon
    property alias text: label.text
    property alias showIcon: image.visible
    property alias showProgression: progression.visible

    height: units.gu(6)
    divider.visible: showDivider

    Text {
        id: image
        anchors {
            left: parent.left
            leftMargin: units.gu(1.5)
            verticalCenter: parent.verticalCenter
        }
        width: visible ? units.gu(3): 0
        font.pixelSize: visible ? units.gu(2.5): 0
        font.family: Awesome.family
        text: item.icon
        horizontalAlignment: Text.AlignHCenter
        color: "grey"
    }

    Label {
        id: label
        anchors {
            left: image.right
            leftMargin: units.gu(1.5)
            verticalCenter: parent.verticalCenter
        }
    }

    Icon {
        id: progression
        anchors {
            right: parent.right
            rightMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }
        height: units.dp(20)
        name: "go-next"
        visible: false
    }
}
