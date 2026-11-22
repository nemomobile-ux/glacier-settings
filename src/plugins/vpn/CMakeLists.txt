SET(SRC vpnsettingsplugin.cpp vpnfilehelper.cpp)
SET(HEADERS vpnsettingsplugin.h vpnfilehelper.h)

SET(PLUGINS_FILES
    vpn.qml
    AddVpnPage.qml
    VpnEditor.qml
    vpn.svg)

set(CMAKE_AUTOMOC ON)

add_definitions(-DQT_PLUGIN)

add_library(vpn MODULE ${SRC} ${HEADERS})

target_link_libraries(vpn
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::DBus
    Glacier::Settings)

install(TARGETS vpn
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/glacier-settings/)

INSTALL(FILES ${PLUGINS_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins/vpn/)

# Translations
file(GLOB TS_FILES translations/*.ts)
qt6_add_translation(QM_FILES ${TS_FILES})
add_custom_target(vpn_translations DEPENDS ${QM_FILES})
add_dependencies(vpn vpn_translations)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/translations)
