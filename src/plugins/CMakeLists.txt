set(SRC settingspluginhost.cpp
    settingspluginmanager.cpp)
set(HEADERS settingspluginhost.h
    settingspluginmanager.h)
set(PUBLIC_HEADERS
    glaciersettingsplugin.h
    glaciersettings_global.h)

add_library(glaciersettings SHARED ${SRC} ${HEADERS} ${PUBLIC_HEADERS})
add_library(Glacier::Settings ALIAS glaciersettings)

add_definitions(-DGLACIERSETTINGS_LIBRARY)

target_link_libraries(glaciersettings
    Qt5::Gui
    Qt5::Qml
    Qt5::Quick)

install(TARGETS glaciersettings
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/)

install(FILES ${PUBLIC_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/glacier-settings)

add_subdirectory(about)
