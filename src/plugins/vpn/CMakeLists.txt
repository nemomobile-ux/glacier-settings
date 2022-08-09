SET(SRC vpnsettingsplugin.cpp)
SET(HEADERS vpnsettingsplugin.h)

SET(PLUGINS_FILES
    vpn.qml
    vpn.svg)

set(CMAKE_AUTOMOC ON)

add_definitions(-DQT_PLUGIN)

add_library(vpn MODULE ${SRC} ${HEADERS})

target_link_libraries(vpn
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Glacier::Settings)

install(TARGETS vpn
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION /usr/share/glacier-settings/plugins/vpn/)
