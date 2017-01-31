TARGET = glacier-settings

SOURCES += \
    src/main.cpp \
    src/settingsmodel/settingsmodel.cpp

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

INSTALLS += target desktop qml

HEADERS += \
    src/settingsmodel/settingsmodel.h
