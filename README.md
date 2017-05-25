### telegram-app ~3.0.0 (ABANDONED)

Forked from Cutegram by Aseman team.

### How to Compile

#### 1. Install libqtelegram-aseman-edition and TelegramQML

- Remove old installations of libqtelegram-aseman-edition and TelegramQML
- https://github.com/Aseman-Land/Cutegram/blob/master/README.md

Be sure to use following repositories for above libraries:

- https://github.com/yunit-io/libqtelegram-aseman-edition (branch: ubports-2fa-3.x)
- https://github.com/yunit-io/TelegramQML (branch: ubports-fixes-old3.x)

#### 2. Build aseman-qt-tools

https://github.com/Aseman-Land/aseman-qt-tools/blob/master/documents/gettingstarted.md

### Start telegram-app

Cutegram 3.x completely written using QML. So there is no need to build and compile it anymore. Just run in using below command.

    qmlscene Telegram.qml

### To-Do

#### telegram-app
- [x] Use AdaptivePageLayout
- [x] Minor main pages refactoring
- [x] Merge Auth from v2 (partially-done/enough/missing-features)
- [x] Fix logout
- [x] Merge AccountPage from v2 (partially-done/enough)
- [x] Merge IntroPage from v2 (partially-done/enough)
- [x] Merge SettingsPage from v2 (partially-done/enough/missing-features)
- [x] Merge Avatars from v2
- [ ] Merge DialogDetailsPage from v2
- [ ] Merge ContactsPage and AddressBook from v2
- [x] Merge ContentHub (MediaImport) from v2
- [ ] Merge DialogPage from v2
- [x] Do not use Aseman.Keychain, write data in files as temporary workaround
- [ ] Fix copyright headers/Add contributors page
- [ ] Track missing features in lib/TelegramQML
- [ ] Fix file transfers (it could be a regression)

#### telegram-app (after-alpha?)
- [ ] Merge voice messages from v2 and messaging-app
- [ ] Add missing pages (or merge them from v2)
- [ ] Add ubuntu-push notifications
- [ ] Create a component in globals directory to store font sizes, colors, etc.
  - [x] Create globals/TelegramColors.qml
- [ ] Remove AsemanTools dependency
- [ ] Massive code cleanup/stupid-ugly code removal
- [ ] Multiple accounts
- [ ] Create a real replacement for Aseman.Keychan, stored data must be encrypted

#### libqtelegram/TelegramQML
- [ ] Fix file transfers
- [ ] Fix secret chats
- [x] Fix 2FA (@Flohack)
- [x] Fix logout (@Flohack)

#### Missing/Non-working features in reworked pages/TelegramQML ####
- [ ] SettingsPage: change name
- [ ] SettingsPage: change username
- [ ] SettingsPage: change profile photo
- [ ] Auth: resend code
- [ ] Auth: request call
