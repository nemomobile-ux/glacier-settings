TARGET = glacier-settings

SOURCES += \
    src/main.cpp \
    src/models/settingsmodel.cpp \
    src/models/imagesmodel.cpp

HEADERS += \
    src/models/settingsmodel.h \
    src/models/imagesmodel.h

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

developermodeplugin.files = qml/plugins/developermode/developermode.qml
developermodeplugin.path = /usr/share/glacier-settings/qml/plugins/developermode

pluginconfigs.files = qml/plugins/example/example.json\
                      qml/plugins/developermode/developermode.json

pluginconfigs.path = /usr/share/glacier-settings/plugins

INSTALLS += target \
            desktop \
            qml \
            pluginconfigs \
            exampleplugin \
            developermodeplugin

DISTFILES += \
    qml/plugins/example/example.qml \
    qml/plugins/example/example.json \
    qml/plugins/developermode/developermode.qml \
    qml/plugins/developermode/developermode.json
