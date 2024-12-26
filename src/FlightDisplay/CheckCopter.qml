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
    property var _activeVehicle     : QGroundControl.multiVehicleManager.activeVehicle
    property Fact _frameClass       : controllerss.getParameterFact(-1, "FRAME_CLASS")
    property int motorPercent       : 30
    property int timeOut            : 2
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

    function getCopterMotor(index) {// Ada Di FirmwarePlugin untik nilai index FRAME_CLASS
        switch (index) {
            case 1: return "/checklists/QuadCopter.qml";    // QUADCOPTER
            case 2: return "/checklists/HexaCopter.qml";    // HEXACOPTER
            // case 3: return "/checklists/Motor_4.qml";    // OCTACOPTER
            case 4: return "/checklists/OctoQuad.qml";      // OCTOQUAD
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
    Loader{
        id: modelContainer
        source: getCopterMotor(_frameClass.rawValue)
        Layout.alignment: Qt.AlignHCenter
    }
}
