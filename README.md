### telegram-app 3.0.0 (WIP)

Forked from Cutegram by Aseman team.

### How to Compile

#### 1. Install libqtelegram-aseman-edition and TelegramQML

- Remove old installations of libqtelegram-aseman-edition and TelegramQML
- https://github.com/Aseman-Land/Cutegram/blob/master/README.md

#### 2. Build aseman-qt-tools

https://github.com/Aseman-Land/aseman-qt-tools/blob/master/documents/gettingstarted.md

### Start telegram-app

Cutegram 3.x completely written using QML. So there is no need to build and compile it anymore. Just run in using below command.

    qmlscene Telegram.qml

### To-Do

#### telegram-app
- [x] Use AdaptivePageLayout
- [x] Minor main pages refactoring
- [ ] Create a component in globals directory to store font sizes, colors, etc.
- [ ] Merge AccountPage from v2 (partially done)
- [ ] Merge IntroPage from v2
- [ ] Merge SettingsPage from v2
- [ ] Merge DialogDetailsPage from v2
- [ ] Merge ContactsPage and AddressBook from v2
- [ ] Add ContentHub
- [ ] Merge DialogPage from v2
- [ ] Merge missing pages from v2
- [ ] Add missing pages
- [ ] Merge voice messages from v2 and messaging-app
- [ ] Do not use Aseman.Keychain, write data in files as temporary workaround
- [ ] Remove AsemanTools dependency
- [ ] Add ubuntu-push notifications
- [ ] Code cleanup

#### libqtelegram/TelegramQML
- [ ] Fix file transfers
- [ ] Fix secret chats
