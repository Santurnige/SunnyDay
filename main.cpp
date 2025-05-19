#include <QApplication>
#include <QQmlApplicationEngine>
#include<QFont>
#include"applicationengine.h"
#include <QQmlApplicationEngine>
#include<QQmlContext>
#include<QtQml>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);


    qmlRegisterType<applicationEngine>("Engine",1,0,"Engine");

    engine.loadFromModule("SunnyDay", "Main");




    return app.exec();
}
