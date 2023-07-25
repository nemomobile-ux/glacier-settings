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
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Glacier::Settings)

install(TARGETS about
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins/about/)

# Translations
file(GLOB TS_FILES translations/*.ts)
#set_source_files_properties(${TS_FILES} PROPERTIES OUTPUT_LOCATION ${CMAKE_INSTALL_LOCALEDIR})
qt6_add_translation(QM_FILES ${TS_FILES})
add_custom_target(about_translations DEPENDS ${QM_FILES})
add_dependencies(about about_translations)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/translations)

