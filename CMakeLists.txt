cmake_minimum_required(VERSION 3.5)

project(glacier-settings
    VERSION 0.6
    DESCRIPTION "The Glacier settings application")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INSTALL_PREFIX /usr)

include(FeatureSummary)
include(GNUInstallDirs)

set(QT_MIN_VERSION "6.0.0")
find_package(PkgConfig REQUIRED)
find_package(Qt6 COMPONENTS Gui Qml Quick Positioning LinguistTools DBus REQUIRED)

option(BUILD_EXAMPLES "Install example plugin" OFF)
pkg_search_module(SYSSETTINGS REQUIRED systemsettings-qt6)
pkg_search_module(GLACIERAPP6 REQUIRED glacierapp6)

add_subdirectory(src)

# Translations
file(GLOB TS_FILES translations/*.ts)
#set_source_files_properties(${TS_FILES} PROPERTIES OUTPUT_LOCATION ${CMAKE_INSTALL_LOCALEDIR})
qt6_add_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES})
add_dependencies(glacier-settings translations)

install(FILES ${QM_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/translations)

install(FILES glacier-settings.desktop
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications)
install(FILES data/org.nemomobile.qmlsettings.service
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/dbus-1/services)
install(FILES glacier-settings.png
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings)
install(FILES data/glacier-settings-prestart.service
    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/systemd/user/)
file(GLOB LANGLIST_FILES ./configs/supported-languages/*.conf)
install(FILES ${LANGLIST_FILES}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/supported-languages)


feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
