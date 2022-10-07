SET(PLUGIN language)

SET(SRC ${PLUGIN}settingsplugin.cpp)
SET(HEADERS ${PLUGIN}settingsplugin.h)

SET(PLUGINS_FILES
    ${PLUGIN}.qml
    ${PLUGIN}.svg)

set(CMAKE_AUTOMOC ON)

add_definitions(-DQT_PLUGIN)

add_library(${PLUGIN} MODULE ${SRC} ${HEADERS})

target_link_libraries(${PLUGIN}
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick
    Qt5::DBus
    Glacier::Settings)

install(TARGETS ${PLUGIN}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins/${PLUGIN}/)

file(GLOB LANGLIST_FILES supported-languages/*.conf)
install(FILES ${LANGLIST_FILES}
        DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/supported-languages)

# Translations
file(GLOB TS_FILES translations/*.ts)
#set_source_files_properties(${TS_FILES} PROPERTIES OUTPUT_LOCATION ${CMAKE_INSTALL_LOCALEDIR})
qt5_add_translation(QM_FILES ${TS_FILES})
add_custom_target(language_translations DEPENDS ${QM_FILES})
add_dependencies(language language_translations)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/translations)
