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
    main.cpp)

set(QML_PLUGINS
    qml/plugins/sounds/sounds.json
    qml/plugins/usb/usb.json
    qml/plugins/storage/storage.json)

qt5_create_translation(QT_FILES ${SRC})

qtquick_compiler_add_resources(RESOURCES qml/glacier-settings.qrc)

add_executable(glacier-settings ${SRC} ${PUBLIC_HEADERS} ${RESOURCES})

include_directories("lib/")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -fvisibility=hidden -fvisibility-inlines-hidden")
set(CMAKE_EXE_LINKER_FLAGS "-pie -rdynamic")

target_link_libraries(glacier-settings PRIVATE
    Qt5::Qml
    Qt5::Quick
    Qt5::Positioning
    ${SYSSETTINGS_LIBRARIES}
    Glacier::App
    Glacier::Settings)

install(TARGETS glacier-settings RUNTIME
    DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES ${QML_PLUGINS}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins)

install(DIRECTORY qml/img/
    DESTINATION ${QT_INSTALL_QML}/Glacier/Controls/img)

install(DIRECTORY qml/components/
    DESTINATION ${QT_INSTALL_QML}/Glacier/Controls/Settings)

add_subdirectory(lib)
add_subdirectory(plugins)
