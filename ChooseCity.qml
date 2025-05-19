import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Page {
    id: page

    Button {
        id: backButton
        width: 50
        height: 50
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
        icon.source: "src/icon/back.png"

        onClicked: stackView.pop()
    }

    SwipeView {
        id: swipeView
        currentIndex: tabBar.currentIndex
        anchors {
            top: backButton.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        Rectangle {
            id: page1
            ScrollView{
                anchors.fill: parent
                Column {
                    id:mainCol
                    width: parent.width-10
                    anchors.fill:parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                }
            }


            Component.onCompleted: {
                var cityList = appEngine.getFavCityList()

                for (var i = 0; i < cityList.length; i++) {
                    var cityName = cityList[i]
                    var qmlObject = `
                    import QtQuick
                    import QtQuick.Controls
                    import QtQuick.Controls.Material

                    Rectangle {
                        id: chooseCity
                        border.width: 2
                        width: parent.width
                        height: 60
                        radius: 20

                        Text {
                            id: cityName2
                            text: '<a>${cityName}</a>'
                            font.underline: true

                            anchors {
                                left: parent.left
                                verticalCenter: parent.verticalCenter
                                leftMargin: 15
                            }
                            font.pixelSize: 18

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    appEngine.setCityName('${cityName}')
                                    appEngine.updateTemperature()
                                    stackView.pop()
                                }
                            }
                        }

                        Button {
                            id: delCity
                            icon.source: "src/icon/delete.png"
                            width: 50
                            height: 50
                            anchors.right: parent.right

                            background: Rectangle {
                                color: "transparent"
                                border.width: 0
                            }
                            flat: true

                            onClicked: {
                                appEngine.deleteFavCity('${cityName}')
                                chooseCity.destroy()
                            }
                        }
                    }
                    `

                    var newElement = Qt.createQmlObject(qmlObject, mainCol)
                }
            }
        }

        Rectangle {
            id: page2

            TextField{
                id:textfield
                width: parent.width-10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 12
                placeholderText: "Название города"
                height: 50
                anchors.top: parent.top

                onTextEdited: {
                    cityCreate.cityName=textfield.text
                }
            }

            MyChooseCity{
                id:cityCreate
                anchors.centerIn: parent
                anchors.horizontalCenter: parent.horizontalCenter
                width:parent.width-10

                onSetFav: {
                    if(cityCreate.checked){
                        if(textfield.text.length>3){
                            appEngine.addFavCity(textfield.text)
                            cityCreate.checked=false
                            tabBar.setCurrentIndex(0)

                            var qmlObject = `
                            import QtQuick
                            import QtQuick.Controls
                            import QtQuick.Controls.Material

                            Rectangle {
                                id: chooseCity
                                border.width: 2
                                width: parent.width
                                height: 60
                                radius: 20

                                Text {
                                    id: cityName2
                                    text: '<a>${textfield.text}</a>'
                                    font.underline: true

                                    anchors {
                                        left: parent.left
                                        verticalCenter: parent.verticalCenter
                                        leftMargin: 15
                                    }
                                    font.pixelSize: 18

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            appEngine.setCityName('${textfield.text}')
                                            appEngine.updateTemperature()
                                            stackView.pop()
                                        }
                                    }
                                }

                                Button {
                                    id: delCity
                                    icon.source: "src/icon/delete.png"
                                    width: 50
                                    height: 50
                                    anchors.right: parent.right

                                    background: Rectangle {
                                        color: "transparent"
                                        border.width: 0
                                    }
                                    flat: true

                                    onClicked: {
                                        appEngine.deleteFavCity('${cityName}')
                                        chooseCity.destroy()
                                    }
                                }
                            }
                            `
                             Qt.createQmlObject(qmlObject,mainCol)
                        }
                        else{
                            dialogNotLenght.open()
                        }
                    }
                }
            }

        }
    }

    Dialog{
        id:dialogNotLenght

        width: parent.width-80
        height:200
        anchors.centerIn: parent

        Text{
            anchors.centerIn: parent
            text:"Введите имя города правильно!"
        }
    }

    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: "Избранные города"
        }
        TabButton {
            text: "Выбрать город"
        }
    }
}
