import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQml.Models                 2.1
import QtQuick.Layouts              1.12

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Palette       1.0

Item {
    // ABCDEFGH = 16473825|
    //CW putar ke 90deg
    width:  60 * ScreenTools.defaultFontPixelWidth
    height:  60 * ScreenTools.defaultFontPixelWidth
    property alias motorRotate_1: motorRotate_1
    property alias motorRotate_2: motorRotate_2
    property alias motorRotate_3: motorRotate_3
    property alias motorRotate_4: motorRotate_4

    // Column {
    //     z: 3
    //     anchors {
    //         bottom: parent.bottom
    //         horizontalCenter: parent.horizontalCenter
    //         margins: 20
    //     }
    //     spacing: 10

    //     Text {
    //         text: "Width Divider: " + widthDivider.value.toFixed(2)
    //         color: "red"
    //         z: 2
    //     }
    //     Slider {
    //         id: widthDivider
    //         from: 1.0
    //         to: 3.0
    //         value: 1.0
    //     }

    //     Text {
    //         text: "Height Divider: " + heightDivider.value.toFixed(2)
    //         color: "red"
    //         z: 2
    //     }
    //     Slider {
    //         id: heightDivider
    //         from: 1.0
    //         to: 3.0
    //         value: 1.0
    //     }
    // }
    Image {
        id: motorAnimasi
        source: "/qmlimages/Frame_DF.svg" // Path ke gambar pic1.svg
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
    }
    Rectangle{
        id: rect_1
        color: "transparent"
        // border.color: "green"
        anchors.centerIn: parent
        width: parent.width / 1.04
        height: parent.height / 1.10
    }
    Image {
        id: motor_1
        source: "/qmlimages/PropCCW.svg" // Path ke gambar pic2.svg
        width: parent.width / 2.83
        height: parent.height / 2.88
        anchors.top: rect_1.top
        anchors.right: rect_1.right
        fillMode: Image.PreserveAspectFit
        transform: Rotation {
            id: motorRotate_1
            origin.x: motor_1.width / 2
            origin.y: motor_1.height / 2
            angle: 0
        }
    }

    Image {
        id: motor_2
        source: "/qmlimages/PropCW.svg"
        width: parent.width / 2.83
        height: parent.height / 2.88
        anchors.bottom: rect_1.bottom
        anchors.right: rect_1.right
        fillMode: Image.PreserveAspectFit
        transform: Rotation {
            id: motorRotate_2
            origin.x: motor_2.width / 2
            origin.y: motor_2.height / 2
            angle: 90
        }
    }

    Image {
        id: motor_3
        source: "/qmlimages/PropCCW.svg" // Path ke gambar pic2.svg
        width: parent.width / 2.83
        height: parent.height / 2.88
        anchors.bottom: rect_1.bottom
        anchors.left: rect_1.left
        fillMode: Image.PreserveAspectFit
        transform: Rotation {
            id: motorRotate_3
            origin.x: motor_3.width / 2
            origin.y: motor_3.height / 2
            angle: 0
        }
    }

    Image {
        id: motor_4
        source: "/qmlimages/PropCW.svg"
        width: parent.width / 2.83
        height: parent.height / 2.88
        anchors.top: rect_1.top
        anchors.left: rect_1.left
        fillMode: Image.PreserveAspectFit
        transform: Rotation {
            id: motorRotate_4
            origin.x: motor_4.width / 2
            origin.y: motor_4.height / 2
            angle: 90
        }
    }
}
