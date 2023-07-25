SET(SRC nfcsettingsplugin.cpp)
SET(HEADERS nfcsettingsplugin.h)

SET(PLUGINS_FILES
    nfc.qml
    nfc.svg)

set(CMAKE_AUTOMOC ON)

add_definitions(-DQT_PLUGIN)

add_library(nfc MODULE ${SRC} ${HEADERS})

target_link_libraries(nfc
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::DBus
    Glacier::Settings)

install(TARGETS nfc
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins/nfc/)

# Translations
file(GLOB TS_FILES translations/*.ts)
#set_source_files_properties(${TS_FILES} PROPERTIES OUTPUT_LOCATION ${CMAKE_INSTALL_LOCALEDIR})
qt6_add_translation(QM_FILES ${TS_FILES})
add_custom_target(nfc_translations DEPENDS ${QM_FILES})
add_dependencies(nfc nfc_translations)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/translations)
