TARGET = glacier-settings

CONFIG += c++11 link_pkgconfig
PKGCONFIG += glacierapp
LIBS += -lglacierapp

SOURCES += \
    src/main.cpp \
    src/models/settingsmodel.cpp \
    src/models/satellitemodel.cpp \
    src/models/imagesmodel.cpp \


HEADERS += \
    src/models/settingsmodel.h \
    src/models/satellitemodel.h \
    src/models/imagesmodel.h


QT += qml quick positioning

OTHER_FILES +=rpm/glacier-settings.spec \
    translations/*.ts \
    glacier-settings.desktop \
    privileges

TRANSLATIONS += translations/glacier-settings_en.ts\
                translations/glacier-settings_ru.ts

i18n_files.files = translations
i18n_files.path = /usr/share/$$TARGET
INSTALLS += i18n_files

target.path = /usr/bin

icon.files = glacier-settings.png
icon.path = /usr/share/glacier-settings/

desktop.files = glacier-settings.desktop
desktop.path = /usr/share/applications

privileges.files = glacier-settings.privileges
privileges.path = /usr/share/mapplauncherd/privileges.d/

qml.files = qml/glacier-settings.qml \
            qml/components/ \
            qml/img

qml.path = /usr/share/glacier-settings/qml

exampleplugin.files = qml/plugins/example/example.qml\
                      qml/plugins/example/example.svg
exampleplugin.path = /usr/share/glacier-settings/qml/plugins/example

bluezplugin.files = qml/plugins/bluez/bluez.qml\
                     qml/plugins/bluez/BtDevisesList.qml \
                        qml/plugins/bluez/bluez.svg
bluezplugin.path = /usr/share/glacier-settings/qml/plugins/bluez

developermodeplugin.files = qml/plugins/developermode/developermode.qml\
                            qml/plugins/developermode/developermode.svg
developermodeplugin.path = /usr/share/glacier-settings/qml/plugins/developermode

displayplugin.files = qml/plugins/display/display.qml\
                      qml/plugins/display/display.svg
displayplugin.path = /usr/share/glacier-settings/qml/plugins/display

datetimeplugin.files = qml/plugins/datetime/*.qml \
                       qml/plugins/datetime/*.svg
datetimeplugin.path = /usr/share/glacier-settings/qml/plugins/datetime

wifiplugin.files = qml/plugins/wifi/wifi.qml\
                   qml/plugins/wifi/WifiSettings.qml\
                   qml/plugins/wifi/WifiStatus.qml\
                   qml/plugins/wifi/wifi.svg\
                   qml/plugins/wifi/SavedServices.qml\
                   qml/plugins/wifi/SavedStatus.qml\
                   qml/plugins/wifi/NetworkDelegate.qml

wifiplugin.path = /usr/share/glacier-settings/qml/plugins/wifi

gpsplugin.files =  qml/plugins/gps/gps.qml \
                   qml/plugins/gps/gps.svg

gpsplugin.path = /usr/share/glacier-settings/qml/plugins/gps

languageplugin.files =  qml/plugins/language/language.qml \
                   qml/plugins/language/language.svg

languageplugin.path = /usr/share/glacier-settings/qml/plugins/language

aboutplugin.files =  qml/plugins/about/*.qml \
                    qml/plugins/about/*.svg \
                    qml/plugins/about/icon-glacier-icon.png
aboutplugin.path = /usr/share/glacier-settings/qml/plugins/about

keyboardplugin.files =  qml/plugins/keyboard/keyboard.qml \
                   qml/plugins/keyboard/keyboard.svg

keyboardplugin.path = /usr/share/glacier-settings/qml/plugins/keyboard

nfcplugin.files =  qml/plugins/nfc/nfc.qml \
                   qml/plugins/nfc/nfc.svg

nfcplugin.path = /usr/share/glacier-settings/qml/plugins/nfc

usbplugin.files = qml/plugins/usb/usb.qml \
                  qml/plugins/usb/usb.svg

usbplugin.path = /usr/share/glacier-settings/qml/plugins/usb

devicelockplugin.files = qml/plugins/devicelock/devicelock.qml \
                         qml/plugins/devicelock/DeviceLockPad.qml\
                         qml/plugins/devicelock/devicelock.svg

devicelockplugin.path = /usr/share/glacier-settings/qml/plugins/devicelock


mobileplugin.files = qml/plugins/mobile/mobile.qml \
                     qml/plugins/mobile/mobile.svg

mobileplugin.path = /usr/share/glacier-settings/qml/plugins/mobile

languageconfigs.files = configs/supported-languages/*
languageconfigs.path = /usr/share/jolla-supported-languages/

pluginconfigs.files = qml/plugins/example/example.json \
                      qml/plugins/bluez/bluez.json \
                      qml/plugins/developermode/developermode.json \
                      qml/plugins/display/display.json \
                      qml/plugins/datetime/datetime.json \
                      qml/plugins/wifi/wifi.json \
                      qml/plugins/gps/gps.json \
                      qml/plugins/nfc/nfc.json \
                      qml/plugins/language/language.json \
                      qml/plugins/about/about.json \
                      qml/plugins/keyboard/keyboard.json \
                      qml/plugins/usb/usb.json \
                      qml/plugins/devicelock/devicelock.json \
                      qml/plugins/mobile/mobile.json

pluginconfigs.path = /usr/share/glacier-settings/plugins

service.path = $${INSTALL_ROOT}/usr/share/dbus-1/services
service.files = data/org.nemomobile.qmlsettings.service

INSTALLS += target \
            desktop \
            qml \
            privileges \
            pluginconfigs \
            exampleplugin \
            bluezplugin \
            developermodeplugin \
            displayplugin \
            datetimeplugin \
            wifiplugin \
            gpsplugin\
            languageplugin \
            aboutplugin \
            languageconfigs\
            icon \
            keyboardplugin \
            usbplugin \
            devicelockplugin \
            service \
            mobileplugin \
            nfcplugin

DISTFILES += \
    qml/plugins/bluez/bluez.json \
    qml/plugins/bluez/bluez.qml \
    qml/plugins/example/example.qml \
    qml/plugins/example/example.json \
    qml/plugins/developermode/developermode.qml \
    qml/plugins/developermode/developermode.json \
    qml/plugins/display/display.qml \
    qml/plugins/display/display.json \
    qml/plugins/nfc.qml \
    qml/plugins/wifi/wifi.qml \
    qml/plugins/wifi/wifi.json \
    qml/plugins/wifi/WifiSettings.qml \
    qml/plugins/wifi/WifiStatus.qml \
    qml/plugins/gps/gps.json \
    qml/plugins/gps/gps.svg \
    qml/plugins/gps/gps.qml \
    qml/components/SettingsColumn.qml \
    qml/plugins/language/language.qml \
    qml/plugins/language/language.json \
    qml/plugins/language/language.svg \
    translations/glacier-settings_en.ts \
    translations/glacier-settings_ru.ts \
    qml/plugins/about/about.qml \
    qml/plugins/about/about.json \
    qml/plugins/about/about.svg \
    qml/plugins/about/icon-glacier-icon.png \
    qml/plugins/about/magic.qml \
    qml/plugins/keyboard/keyboard.qml \
    qml/plugins/wifi/SavedServices.qml \
    qml/plugins/wifi/SavedStatus.qml \
    qml/plugins/wifi/NetworkDelegate.qml \
    qml/components/SettingsService.qml \
    data/org.nemomobile.qmlsettings.service \
    qml/plugins/datetime/datetime.qml \
    qml/plugins/datetime/datetime.json \
    qml/plugins/datetime/datetime.svg \
    qml/plugins/usb/usb.json \
    qml/plugins/usb/usb.qml \
    qml/plugins/usb/usb.svg \
    qml/plugins/mobile/mobile.qml \
    qml/plugins/mobile/mobile.json \
    qml/plugins/mobile/mobile.svg \
    qml/plugins/nfc/nfc.qml \
    qml/plugins/nfc/nfc.json \
    qml/plugins/nfc/nfc.svg
