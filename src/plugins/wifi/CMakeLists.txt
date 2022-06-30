SET(SRC wifisettingsplugin.cpp)
SET(HEADERS wifisettingsplugin.h)

SET(PLUGINS_FILES
    NetworkDelegate.qml
    SavedServices.qml
    SavedStatus.qml
    wifi.qml
    wifi.svg
    WifiSettings.qml
    WifiStatus.qml)

set(CMAKE_AUTOMOC ON)

find_package(PkgConfig REQUIRED)
pkg_check_modules(QT5_CONNMAN REQUIRED IMPORTED_TARGET connman-qt5)

add_definitions(-DQT_PLUGIN)

add_library(wifi MODULE ${SRC} ${HEADERS})

target_link_libraries(wifi PUBLIC
    Qt5::Gui
    Qt5::Qml
    Qt5::DBus
    Glacier::Settings
    PkgConfig::QT5_CONNMAN)

target_include_directories(wifi PUBLIC ${QT5CONNMAN_INCLUDE_DIR})

install(TARGETS wifi
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION /usr/share/glacier-settings/plugins/wifi/)
