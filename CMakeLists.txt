cmake_minimum_required(VERSION 3.16)

project(SunnyDay VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

find_package(Qt6 REQUIRED COMPONENTS Network)

find_package(Qt6 REQUIRED COMPONENTS Charts)

find_package(Qt6 REQUIRED COMPONENTS Sql)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appSunnyDay
    main.cpp
)



qt_add_qml_module(appSunnyDay
    URI SunnyDay
    VERSION 1.0
    QML_FILES
    Main.qml
    RESOURCES src/images/background.png
    SOURCES applicationengine.h applicationengine.cpp
    RESOURCES src/icon/cloud.png src/icon/humidity.png src/icon/storm.png src/icon/sunrise.png src/icon/sunset.png src/icon/vision.png
    QML_FILES MoreInfo.qml
    RESOURCES src/icon/restart.png
    RESOURCES src/icon/close.png
    RESOURCES android/AndroidManifest.xml android/build.gradle android/res/values/libs.xml android/res/xml/qtprovider_paths.xml
    RESOURCES android/AndroidManifest.xml android/build.gradle android/res/values/libs.xml android/res/xml/qtprovider_paths.xml
    QML_FILES ChooseCity.qml
    RESOURCES src/icon/back.png
    RESOURCES src/icon/favoriteFalse.png src/icon/favoriteTrue.png
    QML_FILES CustomCheckBox.qml
    QML_FILES MyChooseCity.qml
    SOURCES listmodel.h
    SOURCES listmodel.cpp
    RESOURCES src/icon/delete.png
    SOURCES
    QML_FILES HourElement.qml
)

if(ANDROID)
    # Укажите путь к вашему AndroidManifest.xml
    set(ANDROID_MANIFEST "${CMAKE_CURRENT_SOURCE_DIR}/android/AndroidManifest.xml")

    # Убедитесь, что файл существует
    if(NOT EXISTS "${ANDROID_MANIFEST}")
        message(FATAL_ERROR "AndroidManifest.xml not found at ${ANDROID_MANIFEST}")
    endif()

    # Установите свойство для Android манифеста
    set_target_properties(appSunnyDay PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
        ANDROID_MANIFEST "${ANDROID_MANIFEST}"
    )
endif()


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSunnyDay PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSunnyDay
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)



target_link_libraries(appSunnyDay
    PRIVATE Qt6::Quick
)
target_link_libraries(appSunnyDay PRIVATE Qt6::Network)

target_link_libraries(appSunnyDay PRIVATE Qt6::Charts)

target_link_libraries(appSunnyDay PRIVATE Qt6::Sql)

include(GNUInstallDirs)
install(TARGETS appSunnyDay
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
