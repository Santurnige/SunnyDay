import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick.Layouts
import Engine
import QtCharts

Rectangle{
    id:main
    color:"#66ffffff"
    
    property string imageSource: ""
    property string titleText: ""
    property string mainText: ""
    Image{
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottomMargin: 20
        source: main.imageSource
        width:75
        height:75
    }
    
    Text {
        id:name
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 20
        anchors.leftMargin: 20
        font.pixelSize: 15
        color:"gray"
        text: main.titleText
    }
    
    
    Text{
        anchors.top: name.bottom
        anchors.left: name.left
        font.bold: true
        text:main.mainText
        font.pixelSize:25
        color: "#585858"
    }
    
    height:parent.width/2-5
    width:parent.width/2-5
    radius: 20
}
