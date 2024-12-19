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
    Image {
        id: motorAnimasi
        source: "/qmlimages/Airframe/VTOLPlane" // Path ke gambar pic1.svg
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: motor_1
        source: "/qmlimages/PropCCW.svg" // Path ke gambar pic2.svg
        width: parent.width / 3
        height: parent.height / 3
        anchors.top: motorAnimasi.top
        anchors.right: motorAnimasi.right
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
        width: parent.width / 3
        height: parent.height / 3
        anchors.bottom: motorAnimasi.bottom
        anchors.right: motorAnimasi.right
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
        width: parent.width / 3
        height: parent.height / 3
        anchors.bottom: motorAnimasi.bottom
        anchors.left: motorAnimasi.left
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
        width: parent.width / 3
        height: parent.height / 3
        anchors.top: motorAnimasi.top
        anchors.left: motorAnimasi.left
        fillMode: Image.PreserveAspectFit
        transform: Rotation {
            id: motorRotate_4
            origin.x: motor_4.width / 2
            origin.y: motor_4.height / 2
            angle: 90
        }
    }
}
