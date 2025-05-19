import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Rectangle {
    id: chooseCity
    width: parent.width
    height: 60
    border.width: 2
    radius: 20
    
    property string cityName
    property bool checked:customCheckBox.checked
    signal setFav()
    
    Text {
        id: cityName2
        text: cityName
        anchors {
            left: parent.lefе
            verticalCenter: parent.verticalCenter
            leftMargin: 15
        }
        font.pixelSize: 18
    }
    
    CustomCheckBox {
        id: customCheckBox
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 15
        }
        onSetChecked: {
            setFav()
        }

    }
}
