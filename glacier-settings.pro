TARGET = glacier-settings

SOURCES += \
    src/main.cpp \
    src/settingsmodel/settingsmodel.cpp

HEADERS += \
    src/settingsmodel/settingsmodel.h

QT += qml quick

OTHER_FILES +=rpm/glacier-settings.spec \
    translations/*.ts \
    glacier-settings.desktop

TRANSLATIONS += translations/*.ts

target.path = /usr/bin

desktop.files = glacier-settings.desktop
desktop.path = /usr/share/applications

qml.files = qml/glacier-settings.qml
qml.path = /usr/share/glacier-settings/qml

exampleplugin.files = qml/plugins/example/example.qml
exampleplugin.path = /usr/share/glacier-settings/qml/plugins/example

pluginconfigs.files = qml/plugins/example/example.json
pluginconfigs.path = /usr/share/glacier-settings/plugins

INSTALLS += target \
            desktop \
            qml \
            pluginconfigs \
            exampleplugin

DISTFILES += \
    qml/plugins/example/example.qml \
    qml/plugins/example/example.json
