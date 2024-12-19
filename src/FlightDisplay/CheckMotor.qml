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
    property Fact _Q_enableCheck    : _activeVehicle.fixedWing? controllerss.getParameterFact(-1,"Q_ENABLE") : null // 0=disable 1=enable 2=enableVTOL
    property Fact _frameClass       : getFrameClass()
    property var _activeVehicle     : QGroundControl.multiVehicleManager.activeVehicle
    property int motorPercent       : 30
    property int timeOut            : 3
    property var motorConfig        : null
    property var rotationDirections : getMotorDirections(_frameClass.rawValue)

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
        if (_activeVehicle.fixedWing){
            if (_Q_enableCheck.rawValue === 0){
                buttonRow.visible = false;
                return controllerss.getParameterFact(-1,"Q_ENABLE");
            }
            else {
                return controllerss.getParameterFact(-1, "Q_FRAME_CLASS");
            }
        }
        else if (_activeVehicle.multiRotor){
            return controllerss.getParameterFact(-1, "FRAME_CLASS");
        }
        else {
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


    Timer {
           id: stopTimer
           interval: timeOut * 1000
           running: false
           repeat: false
           onTriggered: {
               rotationAnimation.running = false
           }
       }
    NumberAnimation {
        id: rotationAnimation
        property: "angle"
        // from: 0
        // to: 360
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
            model:      controller.vehicle.motorCount == -1 ? 4 : controller.vehicle.motorCount
            Layout.fillWidth: true
            QGCButton {
                enabled: _activeVehicle.readyToFly && !_activeVehicle.armed && !stopTimer.running
                text: index + 1
                width: 1.2 * ScreenTools.defaultFontPixelWidth
                height: 1.2 * ScreenTools.defaultFontPixelHeight

                onClicked: {
                    controller.vehicle.motorTest(index + 1, motorPercent, timeOut, true)
                    const rotationDirection = rotationDirections[index];
                    const motorRotate = modelContainer.item["motorRotate_" + (index + 1)];

                    if (rotationDirection === "cw") {
                        cwRotate(motorRotate);
                    } else if (rotationDirection === "ccw") {
                        ccwRotate(motorRotate);
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

    function getCopterMotor(index) {// Ada Di FirmwarePlugin untik nilai index FRAME_CLASS
        switch (index) {
            case 1: return "/checklists/QuadCopter.qml";    // QUADCOPTER
            // case 2: return "/checklists/Motor_3.qml";    // HEXACOPTER
            // case 3: return "/checklists/Motor_4.qml";    // OCTACOPTER
            case 4: return "/checklists/OctoQuad.qml";      // OCTOQUAD
            default:
                return "/checklists/UnknownFrame.qml";   // Default case for unknown index
        }
    }

    function getQPlaneMotor(index) {
        switch (index) {// Ada Di FirmwarePlugin untik nilai index Q_FRAME_CLASS
            case 1: return "/checklists/QuadPlane.qml";         // QUADPLANE
            default:
                return "/checklists/UnknownFrame.qml";   // Default case for unknown index
        }
    }
    Loader{
        id: modelContainer
        source: _activeVehicle.fixedWing? getQPlaneMotor(_frameClass.rawValue) : getCopterMotor(_frameClass.rawValue)
    }
    // QGCLabel {
    //     text:               _Q_enableCheck.rawValue
    //     color:              "white"
    //     font.family:        ScreenTools.demiboldFontFamily
    //     font.pointSize:     ScreenTools.mediumFontPointSize
    //     horizontalAlignment:Text.AlignHCenter
    //     Layout.alignment:   Qt.AlignHCenter
    //     Layout.columnSpan:  2
    // }
}
