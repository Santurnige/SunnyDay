#include "applicationengine.h"
#include <qeventloop.h>

//конструктор
applicationEngine::applicationEngine() {
    manager=new QNetworkAccessManager(this);
}

void applicationEngine::setCityName(QString cityName){
    this->this_cityName=cityName;
}

//обновляем данные
void applicationEngine::updateTemperature()
{
    //получаем запрос
    QNetworkReply *request=manager->get(QNetworkRequest(QUrl(QString("https://api.openweathermap.org/data/2.5/weather?q=%1&units=metric&lang=ru&appid=c5bf50380df95694c03e304bdca5d312").arg(this_cityName))));

        connect(request, &QNetworkReply::finished, [=]() { //когда запрос закончил
            if(request->error() == QNetworkReply::NoError) {

                QByteArray data = request->readAll();
                QJsonDocument jsonDoc = QJsonDocument::fromJson(data); //получаем сам JSON оьъект
                QJsonObject jsonObj = jsonDoc.object();


                this_temperature = jsonObj["main"].toObject()["temp"].toDouble(); //текущая температура

                //подробнное описание
                this_desc = jsonObj["weather"].toArray()[0].toObject()["description"].toString()+"\n Ощущается как "+QString::number(jsonObj["main"].toObject()["feels_like"].toDouble())+"°";

                //получаем название иконки
                QString iconName = jsonObj["weather"].toArray()[0].toObject()["icon"].toString();
                this_urlImage=QString("https://openweathermap.org/img/wn/%1@2x.png").arg(iconName);

                //влажность
                this_humidity=jsonObj["main"].toObject()["humidity"].toInt();

                //скорость ветра
                this_wind=jsonObj["wind"].toObject()["speed"].toDouble();

                //видимость
                this_vision=jsonObj["visibility"].toInt();

                //облачность
                this_cloud=jsonObj["clouds"].toObject()["all"].toInt();

                //расход
                this_sunset=getTimeFromUnix(jsonObj["sys"].toObject()["sunset"].toInt());

                //восход
                this_sunrise=getTimeFromUnix(jsonObj["sys"].toObject()["sunrise"].toInt());

                emit weatherUpdated();
            } else {
                qDebug() << "Ошибка запроса:" << request->errorString();
            }
            request->deleteLater();
        });

}

//получаем погоду на 5 часов
QVector<double> applicationEngine::getWeatherHours()
{
    QVector<double> result;

    result.append(18.5);
    result.append(20.2);
    result.append(24);
    result.append(22.7);
    result.append(15.1);


    return result;
}

QString applicationEngine::getTimeFromUnix(int sec)
{
    QDateTime dateTime = QDateTime::fromSecsSinceEpoch(sec);
    return dateTime.time().toString("hh:mm:ss");
}
