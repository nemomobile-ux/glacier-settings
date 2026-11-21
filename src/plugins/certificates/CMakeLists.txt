SET(SRC certificatessettingsplugin.cpp)
SET(HEADERS certificatessettingsplugin.h)

SET(PLUGINS_FILES
    certificates.qml
    certificates.svg)

set(CMAKE_AUTOMOC ON)

add_definitions(-DQT_PLUGIN)

add_library(certificates MODULE ${SRC} ${HEADERS})

target_link_libraries(certificates
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Glacier::Settings)

install(TARGETS certificates
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins/certificates/)

# Translations
file(GLOB TS_FILES translations/*.ts)
qt6_add_translation(QM_FILES ${TS_FILES})
add_custom_target(certificates_translations DEPENDS ${QM_FILES})
add_dependencies(certificates certificates_translations)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/translations)
