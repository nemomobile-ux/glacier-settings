cmake_minimum_required(VERSION 3.1.0)

project(glacier-settings
	VERSION 0.0.12
	DESCRIPTION "The Glacier settings application")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

include(FeatureSummary)
include(GNUInstallDirs)

set(QT_MIN_VERSION "5.6.0")
find_package(Qt5 COMPONENTS Qml Quick Positioning LinguistTools REQUIRED)
find_package(Glacier COMPONENTS App REQUIRED)

add_subdirectory(src)

# Translations
file(GLOB TS_FILES translations/*.ts)
#set_source_files_properties(${TS_FILES} PROPERTIES OUTPUT_LOCATION ${CMAKE_INSTALL_LOCALEDIR})
qt5_add_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES})
add_dependencies(glacier-settings translations)

install(FILES ${QM_FILES}
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/translations)

install(FILES glacier-settings.desktop
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications)
install(FILES data/org.nemomobile.qmlsettings.service
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/dbus-1/services)
install(FILES glacier-settings.privileges
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/mapplauncherd/privileges.d)
install(FILES glacier-settings.png
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings)

file(GLOB LANGLIST_FILES ./configs/supported-languages/*.conf)
install(FILES ${LANGLIST_FILES}
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/jolla-supported-languages)


feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
