import QtQuick 2.4
import Ubuntu.Components 1.3
import "../authenticating" as Authenticating
import "../toolkit" as ToolKit

ToolKit.StackedPage {
	id: authPage

    header: PageHeader {
        title: i18n.tr("Authentication")
        exposed: false
    }

    Authenticating.AuthPage {
    	id: authenticating
    	anchors.fill: parent
    	engine: authPage.engine
    }
}