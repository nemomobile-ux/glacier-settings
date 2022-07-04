SET(PLUGIN devicelock)

SET(SRC ${PLUGIN}settingsplugin.cpp)
SET(HEADERS ${PLUGIN}settingsplugin.h)

SET(PLUGINS_FILES
    ${PLUGIN}.qml
    ${PLUGIN}.svg
    DeviceLockPad.qml)

set(CMAKE_AUTOMOC ON)

add_definitions(-DQT_PLUGIN)

add_library(${PLUGIN} MODULE ${SRC} ${HEADERS})

find_package(PkgConfig REQUIRED)
pkg_check_modules(NEMODEVICELOCK REQUIRED IMPORTED_TARGET nemodevicelock)

target_link_libraries(${PLUGIN}
    Qt5::Core
    Glacier::Settings
    PkgConfig::NEMODEVICELOCK)

install(TARGETS ${PLUGIN}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION /usr/share/glacier-settings/plugins/${PLUGIN}/)
