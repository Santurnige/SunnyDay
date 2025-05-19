#ifndef APPLICATIONENGINE_H
#define APPLICATIONENGINE_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include<QJsonArray>
#include<QNetworkAccessManager>
#include<QNetworkReply>
#include<QNetworkRequest>
#include<QEventLoop>
#include<QLineSeries>
#include<QTime>
#include<QSqlDatabase>
#include<QSqlQuery>
#include<QSqlError>
#include<QSqlTableModel>
#include<QList>
#include<QFile>
#include<QSortFilterProxyModel>
#include<QAbstractListModel>
#include<QSettings>
#include"listmodel.h"
#include<QHostInfo>



class applicationEngine : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString cityName READ getCityName NOTIFY weatherUpdated)
    Q_PROPERTY(double temperature READ getTemperature NOTIFY weatherUpdated)
    Q_PROPERTY(QString desc READ getDesc NOTIFY weatherUpdated)
    Q_PROPERTY(QString urlImage READ getUrlImage NOTIFY weatherUpdated)
    Q_PROPERTY(int cloud READ getCloud NOTIFY weatherUpdated)
    Q_PROPERTY(int vision READ getVision NOTIFY weatherUpdated)
    Q_PROPERTY(int humidity READ getHumidity NOTIFY weatherUpdated)
    Q_PROPERTY(QString sunset READ getSunset NOTIFY weatherUpdated)
    Q_PROPERTY(QString sunrise READ getSunrise NOTIFY weatherUpdated)
    Q_PROPERTY(double wind READ getWind NOTIFY weatherUpdated)
    Q_PROPERTY(bool is_loading READ getIsLoading WRITE setIsLoading NOTIFY weatherUpdated)
    Q_PROPERTY(QStringList wInHour READ getWInHour NOTIFY weatherUpdated)

public:
    //гетеры и сетеры
    Q_INVOKABLE void setCityName(QString cityName);
    Q_INVOKABLE QString getCityName() const;
    double getTemperature() const { return this_temperature; }
    QString getDesc() const { return this_desc; }
    QString getUrlImage(){return this_urlImage;}
    int getCloud(){return this_cloud;}
    int getVision(){return this_vision;}
    int getHumidity(){return this_humidity;}
    QString getSunset(){return this_sunset;}
    QString getSunrise(){return this_sunrise;}
    double getWind(){return this_wind;}
    bool getIsLoading(){return is_loading;}
    void setIsLoading(bool isL){this->is_loading=isL;}

    QStringList getWInHour(){return wInHour;}

    explicit applicationEngine();


    //прочее
    Q_INVOKABLE void updateTemperature();

    Q_INVOKABLE void getWeatherHours();

    Q_INVOKABLE bool deleteFavCity(QString cityName);
    QString getTimeFromUnix(int sec);

    Q_INVOKABLE QStringList getFavCityList();
    Q_INVOKABLE bool addFavCity(QString cityName);

    Q_INVOKABLE QStringList splitString(QString str);

signals:
    void weatherUpdated();
private:

    QSettings *settings;

    QSqlDatabase db;
    QSqlQuery *query;

    QNetworkAccessManager *manager;

    bool is_loading=true;

    QStringList wInHour;

    //информации про текущую погоду
    QString this_cityName="";
    double this_temperature=0;
    QString this_desc="";
    QString this_urlImage="";
    int this_cloud=0;
    int this_vision=0;
    int this_humidity=0;
    QString this_sunset="";
    QString this_sunrise="";
    double this_wind=0;
};

#endif // APPLICATIONENGINE_H
