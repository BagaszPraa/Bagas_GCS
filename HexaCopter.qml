import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQml.Models                 2.1
import QtQuick.Layouts              1.12

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0

Item {
    width:  60 * ScreenTools.defaultFontPixelWidth
    height:  60 * ScreenTools.defaultFontPixelWidth
    property alias motorRotate_1: motorRotate_1
    property alias motorRotate_2: motorRotate_2
    property alias motorRotate_3: motorRotate_3
    property alias motorRotate_4: motorRotate_4
    property alias motorRotate_5: motorRotate_5
    property alias motorRotate_6: motorRotate_6
    // Column {
    //     anchors {
    //         bottom: motorAnimasi.bottom
    //         horizontalCenter: motorAnimasi.horizontalCenter
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
    //         to: 5.0
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
    //         to: 5.0
    //         value: 1.0
    //     }
    // }
    // Rectangle{
    //     id: rect_1
    //     color: "transparent"
    //     // border.color: "red"
    //     width: parent.width
    //     height: parent.height
    // }
    Rectangle{
        id: rect_2
        color: "transparent"
        // border.color: "green"
        width: parent.width / 1.55
        height: parent.height / 1.10
        anchors.centerIn: parent
    }
    Rectangle{
        id: rect_3
        color: "transparent"
        // border.color: "green"
        width: parent.width / 1.0
        height: parent.height / 3.60
        anchors.centerIn: parent
    }
    Image {
        id: motorAnimasi
        source: "/qmlimages/Airframe/HexaRotorX" // Path ke gambar pic1.svg
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: motor_1
        source: "/qmlimages/PropCCW.svg" // Path ke gambar pic2.svg
        width: parent.width / 3.55
        height: parent.height / 3.65
        anchors.top: rect_2.top
        anchors.right: rect_2.right
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
        width: parent.width / 3.55
        height: parent.height / 3.65
        anchors.top: rect_3.top
        anchors.right: rect_3.right
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
        source: "/qmlimages/PropCCW.svg"
        width: parent.width / 3.55
        height: parent.height / 3.65
        anchors.bottom: rect_2.bottom
        anchors.right: rect_2.right
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
        width: parent.width / 3.55
        height: parent.height / 3.65
        anchors.bottom: rect_2.bottom
        anchors.left: rect_2.left
        fillMode: Image.PreserveAspectFit
        transform: Rotation {
            id: motorRotate_4
            origin.x: motor_4.width / 2
            origin.y: motor_4.height / 2
            angle: 90
        }
    }
    Image {
        id: motor_5
        source: "/qmlimages/PropCCW.svg"
        width: parent.width / 3.55
        height: parent.height / 3.65
        anchors.top: rect_3.top
        anchors.left: rect_3.left
        fillMode: Image.PreserveAspectFit
        transform: Rotation {
            id: motorRotate_5
            origin.x: motor_5.width / 2
            origin.y: motor_5.height / 2
            angle: 0
        }
    }

    Image {
        id: motor_6
        source: "/qmlimages/PropCW.svg"
        width: parent.width / 3.55
        height: parent.height / 3.65
        anchors.top: rect_2.top
        anchors.left: rect_2.left
        fillMode: Image.PreserveAspectFit
        transform: Rotation {
            id: motorRotate_6
            origin.x: motor_6.width / 2
            origin.y: motor_6.height / 2
            angle: 90
        }
    }
}
