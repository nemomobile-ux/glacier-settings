set(SRC
	main.cpp
	models/imagesmodel.cpp
	models/imagesmodel.h
	models/satellitemodel.cpp
	models/satellitemodel.h
	models/settingsmodel.cpp
	models/settingsmodel.h)
set(QML_PLUGINS
	qml/plugins/example/example.json
	qml/plugins/bluez/bluez.json
	qml/plugins/developermode/developermode.json
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

target_link_libraries(glacier-settings
	Qt5::Qml
	Qt5::Quick
	Qt5::Positioning
	Glacier::App)
install(TARGETS glacier-settings RUNTIME
	DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES ${QML_PLUGINS}
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins)
install(DIRECTORY qml
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings
	PATTERN "*.json" EXCLUDE)
