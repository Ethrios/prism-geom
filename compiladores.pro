#-------------------------------------------------
#
# Project created by QtCreator 2013-11-30T18:00:11
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = compiladores
TEMPLATE = app


SOURCES += main.C\
        mainwindow.C \
    lex.yy.c

HEADERS  += mainwindow.h

FORMS    += mainwindow.ui

RESOURCES += \
    recursos.qrc

OTHER_FILES +=
