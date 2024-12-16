/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQml.Models                 2.1
import QtQuick.Layouts              1.12

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.FactSystem    1.0

ColumnLayout {
    spacing: 10
    Layout.fillWidth: true
    property var _activeVehicle     : QGroundControl.multiVehicleManager.activeVehicle
    property int motorPercent       : 30
    property int timeOut            : 3

    FactPanelController {
        id:             controller
    }
    Timer {
           id: stopTimer
           interval: 2000
           running: false
           repeat: false
           onTriggered: {
               rotationAnimation.running = false
           }
       }
    NumberAnimation {
        id: rotationAnimation
        property: "angle"
        from: 0
        to: 360
        duration: 1000
        loops: Animation.Infinite
        running: false
    }

    RowLayout {
        id: buttonRow
        spacing: 10
        width:  60 * ScreenTools.defaultFontPixelWidth
        Repeater {
            model:      controller.vehicle.motorCount == -1 ? 8 : controller.vehicle.motorCount
            Layout.fillWidth: true
            QGCButton {
                enabled: _activeVehicle.readyToFly
                text: index + 1
                width: 1.2 * ScreenTools.defaultFontPixelWidth
                height: 1.2 * ScreenTools.defaultFontPixelHeight
                onClicked: {
                    controller.vehicle.motorTest(index + 1, motorPercent, timeOut, true)
                    if (index+1 == 1){
                        cwRotate(motorRotate_1)
                    }
                    else if (index+1 == 2){
                        ccwRotate(motorRotate_2)
                    }
                    else if (index+1 == 3){
                        ccwRotate(motorRotate_3)
                    }
                    else if (index+1 == 4){
                        cwRotate(motorRotate_4)
                    }
                    else if (index+1 == 5){
                        cwRotate(motorRotate_5)
                    }
                    else if (index+1 == 6){
                        ccwRotate(motorRotate_6)
                    }
                    else if (index+1 == 7){
                        ccwRotate(motorRotate_7)
                    }
                    else if (index+1 == 8){
                        cwRotate(motorRotate_8)
                    }

                }
            }
        }
        Switch {
            id: safetySwitch
            onClicked: {
                if (checked) {
                    _activeVehicle.toggleSafetySwitchNoMessage(false); // Mengirim false jika kendaraan di-arm
                }
                else {
                    _activeVehicle.toggleSafetySwitchNoMessage(true); // Mengirim false jika kendaraan di-arm
                }
            }
        }
    }
    function cwRotate(target) {
        stopTimer.interval = 2000
        stopTimer.running = true
        rotationAnimation.from = 0
        rotationAnimation.to = 360
        rotationAnimation.target = target
        rotationAnimation.running = true
    }
    function ccwRotate(target) {
        stopTimer.interval = 2000
        stopTimer.running = true
        rotationAnimation.from = 360
        rotationAnimation.to = 0
        rotationAnimation.target = target
        rotationAnimation.running = true
    }
    Rectangle {
        id: motorAnimasi
        width:  60 * ScreenTools.defaultFontPixelWidth
        height:  60 * ScreenTools.defaultFontPixelWidth
        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        color: "green"

        Rectangle {
            id: motor_1
            width: parent.width / 4
            height: parent.height / 4
            color: "blue"
            anchors.top: motorAnimasi.top
            anchors.left: motorAnimasi.left
            transform: Rotation {
                id: motorRotate_1
                origin.x: motor_1.width / 2
                origin.y: motor_1.height / 2
                angle: 0
            }
        }

        Rectangle {
            id: motor_2
            width: parent.width / 4
            height: parent.height / 4
            color: "blue"
            anchors.top: motorAnimasi.top
            anchors.right: motorAnimasi.right
            transform: Rotation {
                id: motorRotate_2
                origin.x: motor_2.width / 2
                origin.y: motor_2.height / 2
                angle: 0
            }
        }

        Rectangle {
            id: motor_3
            width: parent.width / 4
            height: parent.height / 4
            color: "blue"
            anchors.bottom: motorAnimasi.bottom
            anchors.left: motorAnimasi.left
            transform: Rotation {
                id: motorRotate_3
                origin.x: motor_3.width / 2
                origin.y: motor_3.height / 2
                angle: 0
            }
        }

        Rectangle {
            id: motor_4
            width: parent.width / 4
            height: parent.height / 4
            color: "blue"
            anchors.bottom: motorAnimasi.bottom
            anchors.right: motorAnimasi.right
            transform: Rotation {
                id: motorRotate_4
                origin.x: motor_4.width / 2
                origin.y: motor_4.height / 2
                angle: 0
            }
        }
        Rectangle {
            id: motor_5
            width: parent.width / 4
            height: parent.height / 4
            color: "red"
            anchors.top: motorAnimasi.top
            anchors.left: motorAnimasi.left
            transform: Rotation {
                id: motorRotate_5
                origin.x: motor_5.width / 2
                origin.y: motor_5.height / 2
                angle: 0
            }
        }

        Rectangle {
            id: motor_6
            width: parent.width / 4
            height: parent.height / 4
            color: "red"
            anchors.top: motorAnimasi.top
            anchors.right: motorAnimasi.right
            transform: Rotation {
                id: motorRotate_6
                origin.x: motor_6.width / 2
                origin.y: motor_6.height / 2
                angle: 0
            }
        }

        Rectangle {
            id: motor_7
            width: parent.width / 4
            height: parent.height / 4
            color: "red"
            anchors.bottom: motorAnimasi.bottom
            anchors.left: motorAnimasi.left
            transform: Rotation {
                id: motorRotate_7
                origin.x: motor_7.width / 2
                origin.y: motor_7.height / 2
                angle: 0
            }
        }

        Rectangle {
            id: motor_8
            width: parent.width / 4
            height: parent.height / 4
            color: "red"
            anchors.bottom: motorAnimasi.bottom
            anchors.right: motorAnimasi.right
            transform: Rotation {
                id: motorRotate_8
                origin.x: motor_8.width / 2
                origin.y: motor_8.height / 2
                angle: 0
            }
        }
    }
}
