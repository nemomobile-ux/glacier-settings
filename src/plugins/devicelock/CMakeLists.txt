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
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins/${PLUGIN}/)

# Translations
file(GLOB TS_FILES translations/*.ts)
#set_source_files_properties(${TS_FILES} PROPERTIES OUTPUT_LOCATION ${CMAKE_INSTALL_LOCALEDIR})
qt5_add_translation(QM_FILES ${TS_FILES})
add_custom_target(devicelock_translations DEPENDS ${QM_FILES})
add_dependencies(devicelock devicelock_translations)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/translations)
