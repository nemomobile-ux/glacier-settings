SET(SRC ethernetsettingsplugin.cpp)
SET(HEADERS ethernetsettingsplugin.h)

SET(PLUGINS_FILES
    ethernet.qml
    EthernetSettings.qml
    ethernet.svg)

set(CMAKE_AUTOMOC ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(QT6_CONNMAN REQUIRED IMPORTED_TARGET connman-qt6)

add_definitions(-DQT_PLUGIN)

add_library(ethernet MODULE ${SRC} ${HEADERS})

target_link_libraries(ethernet PUBLIC
    Qt6::Gui
    Qt6::Qml
    Qt6::DBus
    Glacier::Settings
    PkgConfig::QT6_CONNMAN)

target_include_directories(ethernet PUBLIC ${QT6CONNMAN_INCLUDE_DIR})

install(TARGETS ethernet
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins/ethernet/)

# Translations
file(GLOB TS_FILES translations/*.ts)
qt6_add_translation(QM_FILES ${TS_FILES})
add_custom_target(ethernet_translations DEPENDS ${QM_FILES})
add_dependencies(ethernet ethernet_translations)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/translations)
