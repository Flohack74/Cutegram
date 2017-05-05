import QtQuick 2.4
import Ubuntu.Components 1.3
import TelegramQml 2.0
import Ubuntu.Components 1.3 as Components

Components.Page {
    id: stackedPage

    property Engine engine

    property AdaptivePageLayout stack
    //property alias primaryPage: stack.primaryPage

    property alias title: header.title

    header: Components.PageHeader {
    	id: header
    	title: ""
    }
}
