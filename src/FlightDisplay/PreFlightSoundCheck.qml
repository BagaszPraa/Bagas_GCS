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

PreFlightCheckButton {
    name:                   qsTr("Keluaran Audio GCS")
    manualText:             qsTr("Output audio ATBase diaktifkan. Output audio sistem juga diaktifkan?")
    telemetryTextFailure:   qsTr("Output audio ATBase dinonaktifkan. Harap aktifkan di Application Settings->General untuk mendengar peringatan audio!")
    telemetryFailure:       QGroundControl.settingsManager.appSettings.audioMuted.rawValue
}
