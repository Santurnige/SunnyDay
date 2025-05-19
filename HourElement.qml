import QtQuick
import QtQuick.Controls.Material
import QtQuick.Controls
import QtQuick.Layouts
import Engine
import QtCharts

Rectangle{
    id:hourEl
    property string temp:""
    property string imageUrl: ""
    property string rainPr: ""
    property string time: "0:00"

    Column{
        anchors.fill:parent
        Text{
            id:temperature
            text:temp
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 16

        }
        Image{
            id:imageSource
            source: imageUrl
            horizontalAlignment: Text.AlignHCenter
        }
        Text{
            id:rain
            text:rainPr
            font.italic: true
            horizontalAlignment: Text.AlignHCenter
        }
        Text{
            id:tim
            text:time
            font.bold: true
            font.pointSize: 13
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
