import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQml.Models                 2.1
import QtQuick.Layouts              1.12

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0

Item {
    width:  80 * ScreenTools.defaultFontPixelWidth
    height:  80 * ScreenTools.defaultFontPixelWidth

    property bool isPlaneCheck : false
    property alias motorRotate_1: motorRotate_1
    property alias motorRotate_2: motorRotate_2
    property alias motorRotate_3: motorRotate_3
    property alias motorRotate_4: motorRotate_4
    property alias throttleRotate: throttleRotate
    // Column {
    //     z: 3
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
    //         to: 4.0
    //         value: 1.0
    //     }
    //     Text {
    //         text: "geser posisi Divider: " + geserx.value.toFixed(2)
    //         color: "red"
    //         z: 2
    //     }
    //     Slider {
    //         id: geserx
    //         from: 0
    //         to: parent.width * 2
    //         value: 0
    //     }
    //     Text {
    //         text: "geser posisi Divider: " + gesery.value.toFixed(2)
    //         color: "red"
    //         z: 2
    //     }
    //     Slider {
    //         id: gesery
    //         from: 0
    //         to: parent.height * 2
    //         value: 0
    //     }
    // }

    Image {
        id: motorAnimasi
        source: isPlaneCheck? "/qmlimages/AT250_BACK.png":"/qmlimages/AT250_TOP.png" // Path ke gambar pic1.svg
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        z: 1
    }
    Rectangle{
        id: base_rect_1
        color: "transparent"
        // border.color: "red"
        width: parent.width / 2.84
        height: parent.height / 3.33
        x: 207.50
        y: 191.10
        z: 3
    }
    Rectangle{
        id: rect_1
        color: "transparent"
        // border.color: "green"
        width: parent.width / 1.86
        height: parent.height / 2.13
        anchors.centerIn: base_rect_1
        z : 3
    }

    Image {
        id: motor_1
        source: "/qmlimages/PropCCW.svg" // Path ke gambar pic2.svg
        width: rect_1.width / 2.91
        height: rect_1.height / 2.80
        anchors.top: rect_1.top
        anchors.right: rect_1.right
        fillMode: Image.PreserveAspectFit
        visible: !isPlaneCheck
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
        width: rect_1.width / 2.91
        height: rect_1.height / 2.80
        anchors.bottom: rect_1.bottom
        anchors.right: rect_1.right
        fillMode: Image.PreserveAspectFit
        visible: !isPlaneCheck
        z:2
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
        width: rect_1.width / 2.91
        height: rect_1.height / 2.80
        anchors.bottom: rect_1.bottom
        anchors.left: rect_1.left
        fillMode: Image.PreserveAspectFit
        visible: !isPlaneCheck
        z:2
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
        width: rect_1.width / 2.91
        height: rect_1.height / 2.80
        anchors.top: rect_1.top
        anchors.left: rect_1.left
        fillMode: Image.PreserveAspectFit
        visible: !isPlaneCheck
        transform: Rotation {
            id: motorRotate_4
            origin.x: motor_4.width / 2
            origin.y: motor_4.height / 2
            angle: 90
        }
    }
    Image {
        id: throttle
        source: "/qmlimages/PropCW.svg"
        width: parent.width / 5
        height: parent.height / 5
        x: 257.50
        y: 235.20
        fillMode: Image.PreserveAspectFit
        visible: isPlaneCheck
        z:2
        transform: Rotation {
            id: throttleRotate
            origin.x: throttle.width / 2
            origin.y: throttle.height / 2
            angle: 90
        }
    }
}
