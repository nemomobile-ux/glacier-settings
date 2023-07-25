SET(SRC examplesettingsplugin.cpp)
SET(HEADERS examplesettingsplugin.h)

SET(PLUGINS_FILES
    example.qml
    example.svg
)

set(CMAKE_AUTOMOC ON)

add_definitions(-DQT_PLUGIN)

add_library(example MODULE ${SRC} ${HEADERS})

target_link_libraries(example
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Glacier::Settings)

install(TARGETS example
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins/example/)

# Translations
file(GLOB TS_FILES translations/*.ts)
#set_source_files_properties(${TS_FILES} PROPERTIES OUTPUT_LOCATION ${CMAKE_INSTALL_LOCALEDIR})
qt6_add_translation(QM_FILES ${TS_FILES})
add_custom_target(example_translations DEPENDS ${QM_FILES})
add_dependencies(example example_translations)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/translations)

