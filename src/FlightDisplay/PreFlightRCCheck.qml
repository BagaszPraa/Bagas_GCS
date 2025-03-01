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

PreFlightCheckButton {
    name:                   qsTr("Remote Control (RC)")
    manualText:             qsTr("Menerima sinyal? Lakukan uji jangkauan dan konfirmasi")
    telemetryTextFailure:   qsTr("Tidak ada sinyal atau konfigurasi autopilot-RC tidak valid. Periksa RC dan pengaturan.")
    telemetryFailure:       false//_unhealthySensors & Vehicle.SysStatusSensorRCReceiver

    property int _unhealthySensors: globals.activeVehicle ? globals.activeVehicle.sensorsUnhealthyBits : 0
}
