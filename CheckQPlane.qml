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
import QGroundControl.Controllers   1.0

ColumnLayout {
    id: _root
    spacing: 10
    Layout.fillWidth: true
    // Q_FRAME_CLASS untuk VTOL_PLANE dan FRAME_CLASS untuk MULTICOPTER
    property Fact _CH3_Switch       : controller.getParameterFact(-1, "SERVO3_FUNCTION")//untuk setparam SERVO3 out ke RCIN3
    property Fact _Q_enableCheck    : controllerss.getParameterFact(-1,"Q_ENABLE")// 0=disable 1=enable 2=enableVTOL
    property Fact _frameClass       : getFrameClass()
    property var _activeVehicle     : QGroundControl.multiVehicleManager.activeVehicle
    property int motorPercent       : 30
    property int timeOut            : 2
    property var motorConfig        : null
    property var rotationDirections : getMotorDirections(_frameClass.rawValue)
    property var channelValues      : [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

    FactPanelController { id: controller}
    APMAirframeComponentController { id: controllerss }
    Component.onCompleted: {
        var request = new XMLHttpRequest();
        request.open("GET", "/json/motorCheckConfig.json");
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status === 200) {
                    motorConfig = JSON.parse(request.responseText);
                }
            }
        }
        request.send();
    }

    function getFrameClass() {
        if (_Q_enableCheck.rawValue === 0){
            buttonRow.visible = false;
            return controllerss.getParameterFact(-1,"Q_ENABLE");
        }
        else {
            return controllerss.getParameterFact(-1, "Q_FRAME_CLASS");
        }
    }

    function getMotorDirections(type) {
       if (motorConfig === null) {
           return [];
       }
       if (!motorConfig || !motorConfig[type]) {
           return [];
       }
       return motorConfig[type];
    }

    function cwRotate(target) {//CW putar ke 90deg
        stopTimer.interval = timeOut * 1000
        stopTimer.running = true
        rotationAnimation.from = 0 + 90
        rotationAnimation.to = 360 + 90
        rotationAnimation.target = target
        rotationAnimation.running = true
    }
    function ccwRotate(target) {
        stopTimer.interval = timeOut * 1000
        stopTimer.running = true
        rotationAnimation.from = 360
        rotationAnimation.to = 0
        rotationAnimation.target = target
        rotationAnimation.running = true
    }

    function getQPlaneMotor(index) {
        switch (index) {// Ada Di FirmwarePlugin untik nilai index Q_FRAME_CLASS
            case 1: return "/checklists/QuadPlane.qml";         // QUADPLANE
            default:
                return "/checklists/UnknownFrame.qml";   // Default case for unknown index
        }
    }

    Timer {
       id: stopTimer
       interval: timeOut * 1000
       running: false
       repeat: false
       onTriggered: {
           rotationAnimation.running = false;
           rcoverrideTimer.stop();
           modelContainer.item.indexServoCheck = 7
       }
   }
    Timer {
        id: rcoverrideTimer
        interval:   25  // 25Hz, same as real joystick rate
        running:    _activeVehicle
        repeat:     true
        onTriggered: {
            if (_activeVehicle) {
                _activeVehicle.rcOverrideQml(channelValues);
            }
        }
    }
    NumberAnimation {
        id: rotationAnimation
        property: "angle"
        duration: 1000
        loops: Animation.Infinite
        running: false
    }

    RowLayout {
        id: buttonRow
        spacing: 10
        width:  60 * ScreenTools.defaultFontPixelWidth
        visible: true

        Repeater {
            model:      controller.vehicle.motorCount == -1 ? 8 : controller.vehicle.motorCount
            Layout.fillWidth: true
            QGCButton {
                enabled: _activeVehicle.readyToFly && !_activeVehicle.armed && !stopTimer.running
                text: index + 1
                Layout.fillWidth: true
                height: 1.2 * ScreenTools.defaultFontPixelHeight

                onClicked: {
                    controller.vehicle.motorTest(index + 1, motorPercent, timeOut, true)
                    const rotationDirection = rotationDirections[index];
                    const motorRotate = modelContainer.item["motorRotate_" + (index + 1)];
                    modelContainer.item.isPlaneCheck = false
                    if (rotationDirection === "cw") {
                        cwRotate(motorRotate);
                    } else if (rotationDirection === "ccw") {
                        ccwRotate(motorRotate);
                    }
                }
            }
        }
        QGCButton {
            text: qsTr("Throttle")
            Layout.fillWidth: true
            enabled: _activeVehicle.readyToFly && !_activeVehicle.armed && !stopTimer.running
            height: 1.2 * ScreenTools.defaultFontPixelHeight
            visible: _activeVehicle.fixedWing
            onClicked: {
                modelContainer.item.isPlaneCheck = true;
                cwRotate(modelContainer.item.throttleRotate);
                channelValues[1]= 1500
                channelValues[2]= 1500
                channelValues[3]= 1300
                channelValues[4]= 1500
                rcoverrideTimer.start()
            }
        }
        Switch {
            id: safetySwitch
            onClicked: {
                if (checked) {
                    _activeVehicle.toggleSafetySwitchNoMessage(false); // Mengirim false jika kendaraan di-arm
                    _CH3_Switch.value = 53/// lihat di mavlink
                }
                else {
                    _activeVehicle.toggleSafetySwitchNoMessage(true); // Mengirim false jika kendaraan di-arm
                    _CH3_Switch.value = 70/// lihat di mavlink
                }
            }
        }
    }
    RowLayout {
        id: servotest
        spacing: 10
        width:  60 * ScreenTools.defaultFontPixelWidth
        visible: _activeVehicle.fixedWing
        enabled: _activeVehicle.readyToFly && !_activeVehicle.armed && !stopTimer.running
        QGCButton {
            text: qsTr("Roll Left")
            Layout.fillWidth: true
            height: 1.2 * ScreenTools.defaultFontPixelHeight
            onClicked: {
                stopTimer.start();
                modelContainer.item.isPlaneCheck = true;
                modelContainer.item.indexServoCheck = 1;
                channelValues[1]= 1000
                channelValues[2]= 1500
                channelValues[3]= 1000
                channelValues[4]= 1500
                rcoverrideTimer.start()
            }
        }
        QGCButton {
            text: qsTr("Roll Right")
            Layout.fillWidth: true
            height: 1.2 * ScreenTools.defaultFontPixelHeight
            onClicked: {
                stopTimer.start();
                modelContainer.item.isPlaneCheck = true;
                modelContainer.item.indexServoCheck = 2;
                channelValues[1]= 2000
                channelValues[2]= 1500
                channelValues[3]= 1000
                channelValues[4]= 1500
                rcoverrideTimer.start()
            }
        }
        QGCButton {
            text: qsTr("Nose Down")
            Layout.fillWidth: true
            height: 1.2 * ScreenTools.defaultFontPixelHeight
            onClicked: {
                stopTimer.start();
                modelContainer.item.isPlaneCheck = true;
                modelContainer.item.indexServoCheck = 3;
                channelValues[1]= 1500
                channelValues[2]= 1000
                channelValues[3]= 1000
                channelValues[4]= 1500
                rcoverrideTimer.start()
            }
        }
        QGCButton {
            text: qsTr("Nose Up")
            Layout.fillWidth: true
            height: 1.2 * ScreenTools.defaultFontPixelHeight
            onClicked: {
                stopTimer.start();
                modelContainer.item.isPlaneCheck = true;
                modelContainer.item.indexServoCheck = 4;
                channelValues[1]= 1500
                channelValues[2]= 2000
                channelValues[3]= 1000
                channelValues[4]= 1500
                rcoverrideTimer.start()
            }
        }
        QGCButton {
            text: qsTr("Yaw Left")
            Layout.fillWidth: true
            height: 1.2 * ScreenTools.defaultFontPixelHeight
            onClicked: {
                stopTimer.start();
                modelContainer.item.isPlaneCheck = true;
                modelContainer.item.indexServoCheck = 5;
                channelValues[1]= 1500
                channelValues[2]= 1500
                channelValues[3]= 1000
                channelValues[4]= 1000
                rcoverrideTimer.start()
            }
        }
        QGCButton {
            text: qsTr("Yaw Right")
            Layout.fillWidth: true
            height: 1.2 * ScreenTools.defaultFontPixelHeight
            onClicked: {
                stopTimer.start();
                modelContainer.item.isPlaneCheck = true;
                modelContainer.item.indexServoCheck = 6;
                channelValues[1]= 1500
                channelValues[2]= 1500
                channelValues[3]= 1000
                channelValues[4]= 2000
                rcoverrideTimer.start()
            }
        }
    }
    // RowLayout {
    //     id: flightMode
    //     spacing: 10
    //     width:  60 * ScreenTools.defaultFontPixelWidth
    //     visible: _activeVehicle.fixedWing
    //     QGCButton {
    //         text: qsTr("MANUAL MODE")
    //         Layout.fillWidth: true
    //         height: 1.2 * ScreenTools.defaultFontPixelHeight
    //         onClicked: {
    //             modelContainer.item.isPlaneCheck = true;
    //             _activeVehicle.flightMode = "MANUAL";
    //         }
    //     }
    //     QGCButton {
    //         text: qsTr("FBWA MODE")
    //         Layout.fillWidth: true
    //         height: 1.2 * ScreenTools.defaultFontPixelHeight
    //         onClicked: {
    //             modelContainer.item.isPlaneCheck = true;
    //             _activeVehicle.flightMode = "FBW A";
    //         }
    //     }
    // }

    Loader{
        id: modelContainer
        source: getQPlaneMotor(_frameClass.rawValue)
        Layout.alignment: Qt.AlignHCenter
    }
    // QGCLabel {
    //     text:               _activeVehicle.vehicleTypeName()
    //     color:              "white"
    //     font.family:        ScreenTools.demiboldFontFamily
    //     font.pointSize:     ScreenTools.mediumFontPointSize
    //     horizontalAlignment:Text.AlignHCenter
    //     Layout.alignment:   Qt.AlignHCenter
    //     Layout.columnSpan:  2
    // }
}
