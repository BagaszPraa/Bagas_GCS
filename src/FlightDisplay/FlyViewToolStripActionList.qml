/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQml.Models 2.12

import QGroundControl           1.0
import QGroundControl.Controls  1.0

ToolStripActionList {
    id: _root
    signal displayPreFlightChecklist
    model: [
        // ToolStripAction {
        //     text:           qsTr("Plan")
        //     iconSource:     "/qmlimages/Plan.svg"
        //     onTriggered:    mainWindow.showPlanView()
        // },
        PreFlightCheckListShowAction { onTriggered: displayPreFlightChecklist() },
        GuidedActionTakeoff { },
        GuidedActionLand { },
        GuidedActionRTL { },
        GuidedActionPause { },
        GuidedActionActionList { },
        GuidedActionGripper { },
        ToolStripAction {
            text: _activeVehicle ? (_activeVehicle.readyToFly ? qsTr("Safety OFF") : qsTr("Safety ON")) : qsTr("N/A")
            iconSource: _activeVehicle ? (_activeVehicle.readyToFly ? "/res/LockOpen" : "/res/LockClosed") : "/res/LockClosed"
            enabled: _activeVehicle && !_activeVehicle.armed
            onTriggered: {
                if (_activeVehicle) {
                    if (!_activeVehicle.readyToFly) {
                        _activeVehicle.toggleSafetySwitch(false); // Mengirim false jika kendaraan di-arm
                    } else {
                        _activeVehicle.toggleSafetySwitch(true);  // Mengirim true jika kendaraan tidak di-arm
                    }
                }
            }
        }
    ]
}
