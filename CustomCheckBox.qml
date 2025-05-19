import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Item {
    id: customCheckBox
    width: 20
    height: 20

    property bool checked: false

    signal setChecked(bool state)

    Image {
        id: image
        anchors.fill: parent
        source: customCheckBox.checked ? "src/icon/favoriteTrue.png" : "src/icon/favoriteFalse.png"
    }

    MouseArea {
        id:mouseArea
        anchors.fill: parent
        onClicked: {
            customCheckBox.checked = !customCheckBox.checked
            setChecked(customCheckBox.checked)
        }
    }
}
