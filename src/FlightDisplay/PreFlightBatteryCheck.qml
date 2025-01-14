/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick 2.3

import QGroundControl           1.0
import QGroundControl.Controls  1.0
import QGroundControl.Vehicle   1.0

// This class stores the data and functions of the check list but NOT the GUI (which is handled somewhere else).
PreFlightCheckButton {
    name:                           qsTr("Baterai Drone")
    manualText:                     qsTr("Apakah konektor baterai terpasang dengan kuat dan aman? Tidak kembung? Kondisi daya penuh?")
    telemetryFailure:               _batLow
    telemetryTextFailure:           allowTelemetryFailureOverride ?
                                        qsTr("Peringatan - Daya baterai di bawah %1%.").arg(failurePercent) :
                                        qsTr("Daya baterai di bawah %1%. Harap isi ulang.").arg(failurePercent)
    allowTelemetryFailureOverride:  allowFailurePercentOverride

    property int    failurePercent:                 40
    property bool   allowFailurePercentOverride:    false
    property var    _batteryGroup:                  globals.activeVehicle && globals.activeVehicle.batteries.count ? globals.activeVehicle.batteries.get(0) : undefined
    property var    _batteryValue:                  _batteryGroup ? _batteryGroup.percentRemaining.value : 0
    property var    _batPercentRemaining:           isNaN(_batteryValue) ? 0 : _batteryValue
    property bool   _batLow:                        _batPercentRemaining < failurePercent
}
