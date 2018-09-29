!win32: error("This project only supports Win32 platform!")
# minQtVersion is not recognized by newer Qt versions
# However, versionAtLeast is not recognized by older Qt versions
# !versionAtLeast(QT_VERSION, 5.6.3): error("Upgrade your Qt to at least 5.6.3!")
isEmpty(ROOT): ROOT = $$PWD/..
include($$ROOT/version.pri)
include($$ROOT/optimization.pri)
TARGET = dd
BIN_DIR = $$ROOT/bin
contains(QT_ARCH, x86_64) {
    BIN_DIR = $$join(BIN_DIR,,,64)
    TARGET = $$join(TARGET,,,64)
}
CONFIG(debug, debug|release): TARGET = $$join(TARGET,,,d)
QT += gui widgets avwidgets concurrent
TEMPLATE = app
DEFINES += QT_DEPRECATED_WARNINGS QT_DISABLE_DEPRECATED_BEFORE=0x050603
CONFIG *= c++11
CONFIG -= app_bundle
LIBS += -lUser32 -lDwmapi
HEADERS += \
    forms/preferencesdialog.h \
    settingsmanager.h \
    framelesswindow.h \
    forms/aboutdialog.h
SOURCES += \
    main.cpp \
    forms/preferencesdialog.cpp \
    settingsmanager.cpp \
    framelesswindow.cpp \
    forms/aboutdialog.cpp
FORMS += forms/preferencesdialog.ui \
    forms/aboutdialog.ui
TRANSLATIONS += \
    translations/dd_en.ts \
    translations/dd_zh_CN.ts
RESOURCES += images.qrc
isEmpty(lupdate): lupdate = $$[QT_INSTALL_BINS]/lupdate.exe
isEmpty(lrelease): lrelease = $$[QT_INSTALL_BINS]/lrelease.exe
system("$${lupdate} -no-obsolete $${_PRO_FILE_}")
system("$${lrelease} -nounfinished -removeidentical $${_PRO_FILE_}")
target.path = $$BIN_DIR
INSTALLS += target
CONFIG(static_build) {
    DEFINES += STATIC_BUILD
    RESOURCES += i18n.qrc
} else {
    isEmpty(windeployqt): windeployqt = $$[QT_INSTALL_BINS]/windeployqt.exe
    translations.path = $$BIN_DIR/translations
    translations.commands += $$quote(\"$${lupdate}\" -no-obsolete \"$${_PRO_FILE_}\")
    translations.commands += $$quote(\"$${lrelease}\" -nounfinished -removeidentical \"$${_PRO_FILE_}\")
    translations.commands = $$join(translations.commands, $$escape_expand(\\n\\t))
    translations.files = \
        $$PWD/translations/dd_en.qm \
        $$PWD/translations/dd_zh_CN.qm
    qtavlibs.path = $$BIN_DIR
    qtavlibs.commands = $$quote(\"$${windeployqt}\" --plugindir \"$${BIN_DIR}/plugins\" --force --no-translations --compiler-runtime --angle --no-opengl-sw \"$${BIN_DIR}/$${TARGET}.exe\")
    qtavlibs.commands = $$join(qtavlibs.commands, $$escape_expand(\\n\\t))
    qtavlibs.files = \
        $$[QT_INSTALL_BINS]/Qt*OpenGL.dll \
        $$[QT_INSTALL_BINS]/Qt*AV*.dll \
        $$[QT_INSTALL_BINS]/OpenAL32*.dll \
        $$[QT_INSTALL_BINS]/avcodec*.dll \
        $$[QT_INSTALL_BINS]/avdevice*.dll \
        $$[QT_INSTALL_BINS]/avfilter*.dll \
        $$[QT_INSTALL_BINS]/avformat*.dll \
        $$[QT_INSTALL_BINS]/avutil*.dll \
        $$[QT_INSTALL_BINS]/swresample*.dll \
        $$[QT_INSTALL_BINS]/swscale*.dll \
        $$[QT_INSTALL_BINS]/*ass.dll
    INSTALLS += translations qtavlibs
}