set(SRC
	main.cpp
	models/imagesmodel.cpp
	models/imagesmodel.h
        models/timezonesmodel.cpp
        models/timezonesmodel.h
	models/satellitemodel.cpp
	models/satellitemodel.h
	models/settingsmodel.cpp
	models/settingsmodel.h)
set(QML_PLUGINS
	qml/plugins/bluez/bluez.json
	qml/plugins/display/display.json
	qml/plugins/datetime/datetime.json
	qml/plugins/wifi/wifi.json
	qml/plugins/gps/gps.json
	qml/plugins/nfc/nfc.json
	qml/plugins/language/language.json
	qml/plugins/about/about.json
	qml/plugins/keyboard/keyboard.json
	qml/plugins/usb/usb.json
	qml/plugins/devicelock/devicelock.json
	qml/plugins/mobile/mobile.json
	qml/plugins/powersave/powersave.json)

qt5_create_translation(QT_FILES ${SRC})

add_executable(glacier-settings ${SRC} ${QT_FILES})

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -fvisibility=hidden -fvisibility-inlines-hidden")
set(CMAKE_EXE_LINKER_FLAGS "-pie -rdynamic")

target_link_libraries(glacier-settings
	Qt5::Qml
	Qt5::Quick
	Qt5::Positioning
        ${SYSSETTINGS_LIBRARIES}
	Glacier::App)

target_include_directories(glacier-settings PUBLIC
        ${SYSSETTINGS_INCLUDE_DIRS})

install(TARGETS glacier-settings RUNTIME
	DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES ${QML_PLUGINS}
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins)
install(DIRECTORY qml
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings
        PATTERN "*.json" EXCLUDE
        PATTERN "example" EXCLUDE
        PATTERN "developermode" EXCLUDE)

if(MER_DEVMODE)
    install(FILES qml/plugins/developermode/developermode.json
            DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins)
    install(DIRECTORY qml/plugins/developermode
            DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/qml/plugins
            PATTERN "*.json" EXCLUDE)
endif()

if(BUILD_EXAMPLES)
    install(FILES qml/plugins/example/example.json
            DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins)
    install(DIRECTORY qml/plugins/example
            DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/qml/plugins
            PATTERN "*.json" EXCLUDE)
endif()
