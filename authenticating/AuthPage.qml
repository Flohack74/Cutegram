import QtQuick 2.4
import TelegramQml 2.0 as Telegram
import "../toolkit" as ToolKit

ToolKit.StackedPage {
    id: authenticating

    // hide the old page header
    header: Item {}

    //property bool started: false
    property bool phoneRegistered: true
    property string countryCode: ""
    property string error: ""
    readonly property variant components: [auth_countries_component, auth_phone_component, code_component, password_component]

    /*onStartedChanged: {
        if (started) {
            auth.checkAuthState();
            pageStack.forceSinglePage = false;
        } else {
            stack.clear()
            startPage.forceActiveFocus()
        }
    }*/

    Telegram.Authenticate {
        id: auth
        onStateChanged: {
            checkAuthState()
        }

        engine: authenticating.engine
        property int lastPage: -1

        function checkAuthState() {
            //if (!started)
            //    return;
            console.debug("Auth state changed: %1".arg(engine.state))

            var page = auth.lastPage;

            phoneRegistered = true;
            if (state != Telegram.Authenticate.AuthUnknown)
                authenticating.error = "";

            switch(state) {
                case Telegram.Authenticate.AuthUnknown:
                    //page = ((engine.phoneNumber.length != 0 || authenticating.error != "") ? 1 : 0);
                    break;
                case Telegram.Authenticate.AuthCheckingPhoneError:
                case Telegram.Authenticate.AuthCodeRequestingError:
                    page = 1;
                    authenticating.error = "Error %1: %2".arg(auth.errorCode).arg(auth.errorText);
                    engine.phoneNumber = "";
                    break;
                case Telegram.Authenticate.AuthCheckingPhone:
                    stack.showWaitOverlay(qsTr("Checking your phone number..."));
                    break;
                case Telegram.Authenticate.AuthSignUpNeeded:
                    page = 2;
                    phoneRegistered = false;
                    break;
                case Telegram.Authenticate.AuthCodeRequesting:
                    stack.showWaitOverlay(qsTr("Requesting sign-in code..."));
                    break;
                case Telegram.Authenticate.AuthLoggingInError:
                    authenticating.error = "Error %1: %2".arg(auth.errorCode).arg(auth.errorText);
                case Telegram.Authenticate.AuthCodeRequested:
                    page = 2;
                    break;
                case Telegram.Authenticate.AuthPasswordRequested:
                    page = 3;
                    break;
                case Telegram.Authenticate.AuthLoggingIn:
                    stack.showWaitOverlay(qsTr("Signing in..."));
                    break;
                case Telegram.Authenticate.AuthLoggedIn:
                    page = -1;
                    stack.checkAuth();
                    break;
                default:
                    page = -1;
                    break;
            }

            if (page < 0)
            {
                stack.hideWaitOverlay();
                stack.clear();
            }
            else if (authenticating.error != "")
            {
                stack.hideWaitOverlay();
                stack.clear();
                stack.addPageToCurrentColumn(authenticating, components[page]);
                pageStack.forceSinglePage = true;
            }
            else if (page != auth.lastPage)
            {
                stack.hideWaitOverlay();
                stack.clear();
                if (page == 0)
                {
                    stack.addPageToCurrentColumn(authenticating, auth_countries_component);
                    pageStack.forceSinglePage = false;
                }
                else
                {
                    stack.addPageToCurrentColumn(authenticating, components[page]);
                    pageStack.forceSinglePage = true;
                }

                auth.lastPage = page
            }
        }
    }

    IntroPage {
        id: startPage
        anchors.fill: parent
        //opacity: started ? 0 : 1
        //visible: opacity != 0
        onStartRequest: {//auth.checkAuthState()//started = true
            phoneRegistered = true;
            authenticating.error = "";
            stack.clear();
            stack.addPageToCurrentColumn(authenticating, auth_countries_component);
            pageStack.forceSinglePage = false;
            auth.lastPage = 0;
            engine.phoneNumber = "";
        }

        Behavior on opacity {
            NumberAnimation {easing.type: Easing.OutCubic; duration: 300}
        }

        Component.onCompleted: forceActiveFocus()
    }

    Component {
        id: auth_countries_component
        AuthCountriesPage {
            id: authCountriesPage
            property bool phoneComponentLoaded: false
            onCountryEntered: {
                authenticating.countryCode = code
                //stack.removePages(authCountriesPage);
                if (!phoneComponentLoaded)
                {
                    stack.addPageToNextColumn(authCountriesPage, auth_phone_component);
                    auth.lastPage = 1
                    phoneComponentLoaded = true;
                }
            }
        }
    }

    Component {
        id: auth_phone_component
        AuthNumberPage {
            id: authPhonePage
            countryCode: authenticating.countryCode
            error: authenticating.error
            onPhoneEntered: {
                //engine.phoneNumber = ""
                engine.phoneNumber = number
            }
        }

    }

    Component {
        id: code_component
        AuthCodePage {
            property int authState: auth.state
            phoneRegistered: authenticating.phoneRegistered
            errorText: authenticating.error
            onSignInRequest: auth.signIn(code)
            onSignUpRequest: auth.signUp(firstName, lastName)
        }
    }

    Component {
        id: password_component
        AuthPassword {
            errorText: authenticating.error
            onPasswordAccepted: auth.checkPassword(password)
        }
    }
}

