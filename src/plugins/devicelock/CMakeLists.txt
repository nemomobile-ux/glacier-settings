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

target_link_libraries(${PLUGIN}
    Qt5::Core
    Glacier::Settings)

install(TARGETS ${PLUGIN}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION /usr/share/glacier-settings/plugins/${PLUGIN}/)
