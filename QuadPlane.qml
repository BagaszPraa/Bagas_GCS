import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQml.Models                 2.1
import QtQuick.Layouts              1.12

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0

Item {
    width:  60 * ScreenTools.defaultFontPixelWidth
    height:  60 * ScreenTools.defaultFontPixelWidth
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
    Rectangle{
        id: rect_1
        color: "transparent"
        // border.color: "red"
        width: parent.width / 1.14
        height: parent.height / 1.20
    }
    Rectangle{
        id: rect_2
        color: "transparent"
        // border.color: "green"
        width: rect_1.width / 1.16
        height: rect_1.height / 1.10
        anchors.bottom: rect_1.bottom
        anchors.right: rect_1.right
    }

    Image {
        id: motorAnimasi
        source: isPlaneCheck? "/qmlimages/Airframe/VTOLPlaneOcto":"/qmlimages/Airframe/VTOLPlane" // Path ke gambar pic1.svg
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: motor_1
        source: "/qmlimages/PropCCW.svg" // Path ke gambar pic2.svg
        width: rect_2.width / 2.91
        height: rect_2.height / 2.80
        anchors.top: rect_2.top
        anchors.right: rect_2.right
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
        width: rect_2.width / 2.91
        height: rect_2.height / 2.80
        anchors.bottom: rect_2.bottom
        anchors.right: rect_2.right
        fillMode: Image.PreserveAspectFit
        visible: !isPlaneCheck
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
        width: rect_2.width / 2.91
        height: rect_2.height / 2.80
        anchors.bottom: rect_2.bottom
        anchors.left: rect_2.left
        fillMode: Image.PreserveAspectFit
        visible: !isPlaneCheck
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
        width: rect_2.width / 2.91
        height: rect_2.height / 2.80
        anchors.top: rect_2.top
        anchors.left: rect_2.left
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
        width: rect_2.width / 2
        height: rect_2.height / 2
        anchors.centerIn: rect_2
        fillMode: Image.PreserveAspectFit
        visible: isPlaneCheck
        transform: Rotation {
            id: throttleRotate
            origin.x: throttle.width / 2
            origin.y: throttle.height / 2
            angle: 90
        }
    }
}
