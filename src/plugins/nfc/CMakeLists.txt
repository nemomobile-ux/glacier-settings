SET(SRC nfcsettingsplugin.cpp)
SET(HEADERS nfcsettingsplugin.h)

SET(PLUGINS_FILES
    nfc.qml
    nfc.svg)

set(CMAKE_AUTOMOC ON)

add_definitions(-DQT_PLUGIN)

add_library(nfc MODULE ${SRC} ${HEADERS})

target_link_libraries(nfc
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Qt5::DBus
    Glacier::Settings)

install(TARGETS nfc
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION /usr/share/glacier-settings/plugins/nfc/)
