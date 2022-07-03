SET(PLUGIN mobile)

SET(SRC ${PLUGIN}settingsplugin.cpp)
SET(HEADERS ${PLUGIN}settingsplugin.h)

SET(PLUGINS_FILES
    ${PLUGIN}.qml
    ${PLUGIN}.svg)

set(CMAKE_AUTOMOC ON)

add_definitions(-DQT_PLUGIN)

add_library(${PLUGIN} MODULE ${SRC} ${HEADERS})
find_package(PkgConfig REQUIRED)
pkg_check_modules(QT5_OFONO REQUIRED IMPORTED_TARGET qofono-qt5)

target_link_libraries(${PLUGIN}
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Qt5::DBus
    Glacier::Settings
    PkgConfig::QT5_OFONO)

install(TARGETS ${PLUGIN}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION /usr/share/glacier-settings/plugins/${PLUGIN}/)
