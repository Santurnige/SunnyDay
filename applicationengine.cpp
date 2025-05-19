#include "applicationengine.h"
#include <qeventloop.h>
#include <qnetworkinformation.h>

//конструктор
applicationEngine::applicationEngine() {
    manager=new QNetworkAccessManager(this);

    settings=new QSettings("settings.ini",QSettings::IniFormat,this);


    db=QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName("WeatherChache.db");

    QString tableFeatureCity=R"(
        CREATE TABLE IF NOT EXISTS "FeatureCity" (
            "id" INTEGER NOT NULL UNIQUE,
            "cityName" VARCHAR,
            PRIMARY KEY("id")
        );

    )";

    QString tableWeatherChache=R"(
        CREATE TABLE IF NOT EXISTS "WeatherChache" (
            "id" INTEGER NOT NULL UNIQUE,
            "updateTime" TIME,
            "urlImage" VARCHAR,
            "main_temperature" INTEGER,
            "main_humidity" INTEGER,
            "main_desc" TEXT,
            "main_sunset" TIME,
            "main_sunrise" TIME,
            "main_cloud" INTEGER,
            "main_vision" INTEGER,
            "main_wind" DOUBLE,
            "cityName" VARCHAR,
            PRIMARY KEY("id")
        );
    )";

    query=new QSqlQuery(db);
    if(db.open()){
        if(!query->exec(tableFeatureCity)){
            qDebug()<<query->lastError().text();
        }
        if(!query->exec(tableWeatherChache)){
            qDebug()<<query->lastError().text();
        }
    }
    else{
        qDebug()<<"Database not open";
    }
}

void applicationEngine::setCityName(QString cityName){
    settings->setValue("cityName",cityName);
}

QString applicationEngine::getCityName() const
{
    QString cityName=settings->value("cityName").toString();
    return !cityName.isEmpty()?cityName:"Москва";
}

//обновляем данные
void applicationEngine::updateTemperature()
{
    is_loading=true;



    QHostInfo::lookupHost("www.google.com", [this](const QHostInfo &host) {
        QString sql =
            "SELECT * FROM WeatherChache "
            "WHERE cityName = :cityName "
            "ORDER BY updateTime DESC "
            "LIMIT 1;";

        QSqlQuery queryTemp;
        queryTemp.prepare(sql);
        queryTemp.bindValue(":cityName", getCityName());

        if (host.error() != QHostInfo::NoError) {
            qDebug()<<"Нет подкючения к инетренту";
            if (queryTemp.exec()) {
                if (queryTemp.next()) {

                    this_temperature = queryTemp.value("main_temperature").toDouble();
                    this_desc = queryTemp.value("main_desc").toString();
                    this_urlImage = queryTemp.value("urlImage").toString();
                    this_cloud = queryTemp.value("main_cloud").toInt();
                    this_vision = queryTemp.value("main_vision").toInt();
                    this_humidity = queryTemp.value("main_humidity").toInt();

                    this_sunset = queryTemp.value("main_sunset").toTime().toString("HH:mm:ss");
                    this_sunrise = queryTemp.value("main_sunrise").toTime().toString("HH:mm:ss");

                    this_wind = queryTemp.value("wind").toDouble();
                }

                is_loading=false;
                emit weatherUpdated();
            }
            return;
        }
    });




    //получаем запрос
    QNetworkReply *request=manager->get(QNetworkRequest(QUrl(QString("https://api.openweathermap.org/data/2.5/weather?q=%1&units=metric&lang=ru&appid=c5bf50380df95694c03e304bdca5d312").arg(getCityName()))));


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

                QString queryStr = QString(
                                       "INSERT INTO WeatherChache ("
                                       "updateTime, urlImage, main_temperature, main_humidity, main_desc, "
                                       "main_sunset, main_sunrise, main_cloud, main_vision, main_wind, cityName"
                                       ") VALUES ("
                                       "datetime('now'), '%1', %2, %3, '%4', '%5', '%6', %7, %8, '%9', '%10')"
                                       )
                                       .arg(this_urlImage)
                                       .arg(QString::number(this_temperature))
                                       .arg(QString::number(this_humidity))
                                       .arg(this_desc.replace("'", "''"))
                                       .arg(this_sunset)
                                       .arg(this_sunrise)
                                       .arg(QString::number(this_cloud))
                                       .arg(QString::number(this_vision))
                                       .arg(QString::number(this_wind))
                                       .arg(getCityName().replace("'", "''"));

                if(!query->exec(queryStr)){
                    qDebug()<<query->lastError().text();
                }

                is_loading=false;
                getWeatherHours();
                emit weatherUpdated();
            } else {
                qDebug() << "Ошибка запроса:" << request->errorString();
            }
            request->deleteLater();
        });

}

//получаем погоду на 5 дней
void applicationEngine::getWeatherHours() {

    QNetworkReply *request = manager->get(QNetworkRequest(
    QUrl(QString("https://api.openweathermap.org/data/2.5/forecast?q=%1&units=metric&appid=c5bf50380df95694c03e304bdca5d312")
             .arg(getCityName()))));

    connect(request, &QNetworkReply::finished, [=]() {
        wInHour.clear();
        if (request->error() == QNetworkReply::NoError) {
            QByteArray data = request->readAll();
            QJsonDocument jsonDoc = QJsonDocument::fromJson(data);
            QJsonArray jsonArr = jsonDoc.object()["list"].toArray();

        for (int i = 0; i < jsonArr.size(); ++i) {
            QJsonObject obj = jsonArr[i].toObject();
            QString time = getTimeFromUnix(obj["dt"].toInt());
            double temp = obj["main"].toObject()["temp"].toDouble();
            QString weatherIcon = QString("https://openweathermap.org/img/wn/%1@2x.png").arg(obj["weather"].toArray()[0].toObject()["icon"].toString());
            int rainPr = obj["pop"].toDouble() * 100;

            QString added=time+"&"+QString::number(temp)+"&"+weatherIcon+"&"+QString::number(rainPr);
            wInHour.append(added);

        }
        emit weatherUpdated();
    }
        request->deleteLater();
    });
}
bool applicationEngine::deleteFavCity(QString cityName)
{
    qDebug()<<cityName;
    return query->exec(QString("DELETE FROM FeatureCity WHERE cityName='%1'").arg(cityName));
}

QString applicationEngine::getTimeFromUnix(int sec)
{
    QDateTime dateTime = QDateTime::fromSecsSinceEpoch(sec);
    return dateTime.time().toString("hh:mm");
}

QStringList applicationEngine::getFavCityList()
{
    QSqlTableModel *favModel =new QSqlTableModel(this,db);
    QStringList list;


    favModel->setTable("FeatureCity");
    favModel->select();


    for(int i=0;i<favModel->rowCount();++i){
       QString el=favModel->data(favModel->index(i,1)).toString();
       list.append(el);
    }


    delete favModel;

    return list;
}

bool applicationEngine::addFavCity(QString cityName)
{
     return query->exec(QString("INSERT INTO FeatureCity(cityName)VALUES('%1')").arg(cityName));
}

QStringList applicationEngine::splitString(QString str)
{
    QStringList res=str.split("&");
    return res;
}


