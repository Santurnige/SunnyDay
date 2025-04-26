import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick.Layouts
import Engine
import QtCharts

ApplicationWindow {
    id:mainWindow
    width: 350
    height: 700
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    flags: Qt.Window | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowCloseButtonHint
    visible: true
    title: qsTr("SunnyDay")

    Material.theme: Material.Light
    Material.primary: Material.Teal
    Material.accent: Material.LightGreen


    Engine{
        id:appEngine
    }

    Component.onCompleted: {
        appEngine.setCityName("Ессентуки")
        appEngine.updateTemperature()
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color:  Material.color(Material.Blue, Material.ShadeA400) }
            GradientStop { position: 0.5; color: Material.color(Material.Blue,Material.ShadeA200) }
            GradientStop { position: 1.0; color: Material.color(Material.Blue,Material.ShadeA100) }
        }


        Button{
            id:closeButton
            icon.source: "src/icon/close.png"
            width: 50
            height:50

            icon.color: "red"

            anchors.right: parent.right
            anchors.top:parent.top
            anchors.topMargin: 15
            anchors.rightMargin: 15

            onClicked:{
                mainWindow.close()
            }
        }

        Button{
            icon.source: "src/icon/restart.png"
            width: 50
            height:50

            anchors.right: closeButton.left
            anchors.top: closeButton.top
            anchors.rightMargin: 5

            onClicked: {
                appEngine.updateTemperature()
            }
        }

        Image {
            id: backgroundImage
            source: "src/images/background.png"
            width: parent.width
            height: 300
            anchors.top: parent.top

            x: parent.width

            Behavior on x {
                NumberAnimation {
                    duration: 1500
                    easing.type: Easing.OutCirc
                }
            }
        }
        Component.onCompleted: {
            backgroundImage.x = 0
        }
    }


    Rectangle {
        id:mainInfo

        anchors.top: parent.top
        height: mainWindow.height / 3
        width: mainWindow.width

        color: "transparent"

        Column {
            spacing: -20
            anchors.bottom: parent.bottom
            anchors.leftMargin: 5
            anchors.left: parent.left
            Image{
                source: appEngine.urlImage
                width: 75
                height:75
            }
            Text {
                id: cityName
                text: appEngine.cityName
                font.pixelSize: 30
                leftPadding: 10
                color: "#fff"
            }



            Text {
                id: currentTemperature
                text: Number(appEngine.temperature).toFixed(1) + "°"
                font.pixelSize: 100
                leftPadding: -5
                color: "#fff"
            }



            Text {
                id: currentWeatherStatus
                text: appEngine.desc
                font.pixelSize: 15
                font.italic: true
                topPadding: 15
                leftPadding: 10
                color: "#fff"
            }

            Component.onCompleted: {
                appEngine.updateTemperature(); // Запускаем загрузку данных
            }
        }
    }

    ScrollView{
        anchors.top: mainInfo.bottom
        width: mainWindow.width
        height: mainWindow.height-mainInfo.height-30
        anchors.topMargin: 15

        Column{
            spacing: 15
            Rectangle{
                id:transparent

                height: 150

                width: mainWindow.width

                color:"transparent"
            }

            Rectangle{
                height: 300
                width: parent.width-10
                radius: 20
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#4dffffff"

                Text{
                    text:"Прогноз на 5 дней"
                    font.bold: true
                    leftPadding: 10
                    anchors.top: parent.top
                    font.pixelSize:14
                    color: "#fff"
                }

                ChartView {
                    id: chartView
                    anchors.bottom: parent.bottom
                    height: parent.height
                    width: parent.width
                    antialiasing: true
                    backgroundColor: "transparent"
                    plotAreaColor: "transparent"


                    LineSeries {
                        id: weatherSeries
                        name: "Температура (°C)"
                        width:3
                        capStyle:Qt.RoundCap
                        color:Material.color(Material.Blue)

                        axisX: ValueAxis { id: axisX }
                        axisY: ValueAxis { id: axisY }
                    }

                    Component.onCompleted: {
                        var series = appEngine.getWeatherHours();

                        for (var i = 0; i < series.length; i++) {
                            weatherSeries.append(i, series[i]);
                        }

                        axisX.min = 0;
                        axisX.max = series.length - 1;
                        axisX.tickCount = series.length;
                        axisX.titleText = "Время";

                        axisY.min = Math.min(...series);
                        axisY.max = Math.max(...series);
                        axisY.titleText = "°C";
                    }
                }
            }

            Rectangle{
                height: 195
                width: parent.width-10
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 20

                color: "#4dffffff"

                Text{
                    text:"Прогноз на 24ч"
                    font.bold: true
                    leftPadding: 10
                    anchors.top: parent.top
                    font.pixelSize:14
                    color: "#fff"
                }

                ScrollView{
                    anchors.centerIn: parent
                    height: parent.height-20
                    topPadding: 5
                    width: parent.width-10
                    clip: true


                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOn

                    Row{
                        Button{
                            text:"click me"
                        }
                        Button{
                            text:"click me"
                        }
                        Button{
                            text:"click me"
                        }
                        Button{
                            text:"click me"
                        }
                        Button{
                            text:"click me"
                        }
                        Button{
                            text:"click me"
                        }
                    }
                }
            }


            Rectangle{
                height: 700
                width:parent.width-10
                anchors.horizontalCenter: parent.horizontalCenter
                radius: 20
                color:"transparent"

                Grid{
                    anchors.fill: parent
                    rows: 4
                    spacing: 10
                    columns: 2
                    MoreInfo {
                        imageSource: "src/icon/cloud.png"
                        titleText: "Облачность, %"
                        mainText: Number(appEngine.cloud)+"%"
                    }
                    MoreInfo {
                        imageSource: "src/icon/humidity.png"
                        titleText: "Влажность, %"
                        mainText:Number(appEngine.humidity)+"%"
                    }
                    MoreInfo {
                        imageSource: "src/icon/storm.png"
                        titleText: "Скорость ветра, м/с"
                        mainText:Number(appEngine.wind)
                    }
                    MoreInfo {
                        imageSource: "src/icon/vision.png"
                        titleText: "Видимость, метр"
                        mainText:Number(appEngine.vision)
                    }
                    MoreInfo {
                        imageSource: "src/icon/sunrise.png"
                        titleText: "Время расхода"
                        mainText:appEngine.sunrise
                    }
                    MoreInfo {
                        imageSource: "src/icon/sunset.png"
                        titleText: "Время заката"
                        mainText:appEngine.sunset
                    }

                }
            }
        }
    }
}
