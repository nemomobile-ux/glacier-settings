set(SRC
    satellitemodel.cpp
    settingsmodel.cpp
    settingspluginhost.cpp
    settingspluginmanager.cpp
    themesmodel.cpp
    timezonesmodel.cpp)

set(HEADERS
    satellitemodel.h
    settingsmodel.h
    settingspluginhost.h
    settingspluginmanager.h
    themesmodel.h
    timezonesmodel.h)

set(PUBLIC_HEADERS
    glaciersettingsplugin.h
    glaciersettings_global.h)

add_library(glaciersettings SHARED ${SRC} ${HEADERS} ${PUBLIC_HEADERS}
    logging.h logging.cpp)
add_library(Glacier::Settings ALIAS glaciersettings)
add_definitions(-DINSTALLLIBDIR="${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}")

target_include_directories(glaciersettings PUBLIC
    ${SYSSETTINGS_INCLUDE_DIRS})

add_definitions(-DGLACIERSETTINGS_LIBRARY)

target_link_libraries(glaciersettings
    Qt6::Core
    Qt6::Gui
    Qt6::Positioning)

install(TARGETS glaciersettings
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/)

install(FILES ${PUBLIC_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/glacier-settings)
