import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls

ApplicationWindow {
    id:mainWindow
    width: 350
    height: 700
    visible: true
    title: qsTr("SunnyDay")

    Material.theme: Material.Light
    Material.primary: Material.Teal
    Material.accent: Material.LightGreen
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color:  Material.color(Material.Blue, Material.ShadeA400) }
            GradientStop { position: 0.5; color: Material.color(Material.Blue,Material.ShadeA200) }
            GradientStop { position: 1.0; color: Material.color(Material.Blue,Material.ShadeA100) }
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
            spacing: -40
            anchors.bottom: parent.bottom
            anchors.leftMargin: 5
            anchors.left: parent.left

            Text {
                id: cityName
                text: qsTr("Ессентуки")
                font.pixelSize: 30
                leftPadding: 10
                color: "#fff"
            }

            Text {
                id: curretnTemperature
                text: qsTr("23°")
                font.pixelSize: 130
                leftPadding: -5
                color: "#fff"
            }

            Text {
                id: currentWeatherStatus
                text: qsTr("Ясно 22°/4°")
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
        height: mainWindow.height
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
                radius: 20

                color: "#4dffffff"

                Text{
                    text:"Прогноз на 5 дней"
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
                height: 195
                width: parent.width-10
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
                id:transparent2

                height: mainWindow.height/2

                width: mainWindow.width

                color:"transparent"
            }
        }
    }
}
