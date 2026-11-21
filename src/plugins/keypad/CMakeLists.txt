SET(SRC keypadsettingsplugin.cpp)
SET(HEADERS keypadsettingsplugin.h)

SET(PLUGINS_FILES
    keypad.qml
    keypad.svg)

set(CMAKE_AUTOMOC ON)

add_definitions(-DQT_PLUGIN)

add_library(keypad MODULE ${SRC} ${HEADERS})

target_link_libraries(keypad
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::DBus
    Glacier::Settings)

install(TARGETS keypad
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins/keypad/)

# Translations
file(GLOB TS_FILES translations/*.ts)
qt6_add_translation(QM_FILES ${TS_FILES})
add_custom_target(keypad_translations DEPENDS ${QM_FILES})
add_dependencies(keypad keypad_translations)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/translations)
