SET(SRC aboutsettingsplugin.cpp)
SET(HEADERS aboutsettingsplugin.h)

SET(PLUGINS_FILES
    about.qml
    about.svg
    bluecreature.svg
    icon-glacier-icon.png
    magic.qml)

set(CMAKE_AUTOMOC ON)

add_definitions(-DQT_PLUGIN)

add_library(about MODULE ${SRC} ${HEADERS})

target_link_libraries(about
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Glacier::Settings)

install(TARGETS about
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION /usr/share/glacier-settings/plugins/about/)
