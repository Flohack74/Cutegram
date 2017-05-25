import QtQuick 2.4
import TelegramQml 2.0 as Telegram
import AsemanTools 1.0 as Aseman
import Qt.labs.settings 1.0
import "../globals"

Telegram.Engine {
    id: tgEngine
    logLevel: Telegram.Engine.LogLevelClean
    configDirectory: CutegramGlobals.profilePath
    tempPath: configDirectory + "/" + phoneNumber + "/temp"

    app.appId: 13682
    app.appHash: "de37bcf00f4688de900510f4f87384bb"

    host.hostDcId: 2
    host.hostAddress: "149.154.167.50"
    host.hostPort: 443

    cache.path: configDirectory + "/" + phoneNumber + "/cache"
    cache.encryptMethod: encr.encrypt
    cache.decryptMethod: encr.decrypt

    authStore.writeMethod: function(data) { return keychain.writeData(authKey, data) }
    authStore.readMethod: function() { return keychain.readData(authKey) }

    readonly property string authKey: "auth/" + phoneNumber

    Aseman.Encrypter {
        id: encr
    }

    Settings {
        id: keychain
        property string jsonData: ""

        category: "Cutegram"

        function readData(key) {
            var data = JSON.parse(jsonData);
            if (key in data)
                return data[key]
            else
                return ""
        }

        function writeData(key, value) {
            var data = JSON.parse(jsonData);
            data[key] = value;
            jsonData = JSON.stringify(data);
            return true
        }

        Component.onCompleted: {
            if (jsonData.length == 0)
                jsonData = JSON.stringify({});
            var key = readData("encryptKey")
            if(key.length == 0) {
                key = Aseman.Tools.createUuid()
                writeData("encryptKey", key)
            }
            encr.key = key
        }
    }
}

