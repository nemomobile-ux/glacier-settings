### Sets QT_INSTALL_QML to the directory where QML Plugins should be installed
function(FindQtInstallQml)
    find_program(QMAKE NAMES qmake-qt5 qmake)
    if(NOT QMAKE)
        message(FATAL_ERROR "qmake not found")
    endif()
    execute_process(
        COMMAND ${QMAKE} -query QT_INSTALL_QML
        OUTPUT_VARIABLE PROC_RESULT
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
set(QT_INSTALL_QML ${PROC_RESULT} PARENT_SCOPE)
endfunction()

FindQtInstallQml()

set(SRC
    main.cpp
    models/imagesmodel.cpp
    models/imagesmodel.h
    models/timezonesmodel.cpp
    models/timezonesmodel.h
    models/themesmodel.cpp
    models/themesmodel.h
    models/satellitemodel.cpp
    models/satellitemodel.h
    models/settingsmodel.cpp
    models/settingsmodel.h)

set(QML_PLUGINS
    qml/plugins/sounds/sounds.json
    qml/plugins/bluez/bluez.json
    qml/plugins/display/display.json
    qml/plugins/datetime/datetime.json
    qml/plugins/wifi/wifi.json
    qml/plugins/gps/gps.json
    qml/plugins/language/language.json
    qml/plugins/keyboard/keyboard.json
    qml/plugins/usb/usb.json
    qml/plugins/devicelock/devicelock.json
    qml/plugins/mobile/mobile.json
    qml/plugins/powersave/powersave.json
    qml/plugins/storage/storage.json)

qt5_create_translation(QT_FILES ${SRC})

add_executable(glacier-settings ${SRC} ${PUBLIC_HEADERS} ${QT_FILES})

include_directories("plugins/")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -fvisibility=hidden -fvisibility-inlines-hidden")
set(CMAKE_EXE_LINKER_FLAGS "-pie -rdynamic")

target_link_libraries(glacier-settings PRIVATE
    Qt5::Qml
    Qt5::Quick
    Qt5::Positioning
    ${SYSSETTINGS_LIBRARIES}
    Glacier::App
    Glacier::Settings)

target_include_directories(glacier-settings PUBLIC
    ${SYSSETTINGS_INCLUDE_DIRS})

install(TARGETS glacier-settings RUNTIME
    DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES ${QML_PLUGINS}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins)

install(FILES qml/glacier-settings.qml
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/qml)

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

install(DIRECTORY qml/img/
    DESTINATION ${QT_INSTALL_QML}/Glacier/Controls/img)

install(DIRECTORY qml/components/
    DESTINATION ${QT_INSTALL_QML}/Glacier/Controls/Settings)

add_subdirectory(plugins)
