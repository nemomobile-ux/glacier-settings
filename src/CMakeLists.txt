### Sets QT_INSTALL_QML to the directory where QML Plugins should be installed
function(FindQtInstallQml)
    find_program(QMAKE NAMES qmake6 qmake)
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

qt6_create_translation(QT_FILES ${SRC})

qt6_add_resources(RESOURCES qml/glacier-settings.qrc)

add_executable(glacier-settings ${SRC} ${PUBLIC_HEADERS} ${RESOURCES})

include_directories("lib/")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -fvisibility=hidden -fvisibility-inlines-hidden")
set(CMAKE_EXE_LINKER_FLAGS "-pie -rdynamic")

find_package(PkgConfig REQUIRED)
pkg_check_modules(GLACIERAPP6 REQUIRED IMPORTED_TARGET glacierapp6)

target_link_libraries(glacier-settings PRIVATE
    Qt6::Qml
    Qt6::Quick
    Qt6::Positioning
    ${SYSSETTINGS_LIBRARIES}
    PkgConfig::GLACIERAPP6
    Glacier::Settings)

install(TARGETS glacier-settings RUNTIME
    DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES ${QML_PLUGINS}
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-settings/plugins)

install(DIRECTORY qml/components/
    DESTINATION ${QT_INSTALL_QML}/Glacier/Controls/Settings)

add_subdirectory(lib)
add_subdirectory(plugins)
