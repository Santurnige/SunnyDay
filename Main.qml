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
    Material.accent: Material.LightBlue

    Engine{
        id:appEngine

    }

    property alias appEngine:appEngine
    property alias stackView: stackView

    function updateWeatherHour(){

        for(var i=0;i<hourRow.children.length;i++){
           hourRow.children[i].destroy()
        }

        var list = appEngine.wInHour;
        console.log("Количество элементов:", list.length);

        for (var i = 0; i < list.length; i++) {
            var split = appEngine.splitString(list[i]);
            console.log("Time - " + split[0]);

            var elementQml = `
                import QtQuick
                import QtQuick.Controls.Material
                import QtQuick.Controls

                HourElement {
                    height: parent.height
                    width: 80
                    color:"transparent"

                    time: "${split[0]}"
                    temp: "${split[1]}°"
                    imageUrl: "${split[2]}"
                    rainPr: "Дождь ${split[3]}%"
                }
            `;

            Qt.createQmlObject(elementQml, hourRow);
        }
    }

    Component.onCompleted: {
        appEngine.updateTemperature()
    }
    Timer {
        interval: 5000
        running: true
        repeat: false
        onTriggered: {
            updateWeatherHour()
        }
    }

    HourElement {
        id: hourEl
    }

    StackView{
        id:stackView

        initialItem: mainPage
        anchors.fill: parent
    }

    Rectangle{
        id:mainPage

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color:  Material.color(Material.Blue, Material.ShadeA400) }
                GradientStop { position: 0.5; color: Material.color(Material.Blue,Material.ShadeA200) }
                GradientStop { position: 1.0; color: Material.color(Material.Blue,Material.ShadeA100) }
            }

            BusyIndicator{
                id:busyIndicator
                anchors.centerIn: parent
                running: appEngine.is_loading
                anchors.top: parent.top
                anchors.topMargin: 20
                Material.accent: "black"
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
                    updateWeatherHour()
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


                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            stackView.push("ChooseCity.qml")
                        }
                    }
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
                    height: 195
                    width: parent.width-10
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 20

                    color: "#4dffffff"

                    Text{
                        text:"Прогноз на 5 дней/3ч"
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
                            id:hourRow
                            anchors.fill: parent

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
}
