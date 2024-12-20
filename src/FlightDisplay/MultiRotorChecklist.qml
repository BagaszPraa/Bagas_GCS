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

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.Vehicle       1.0

Item {
    property var model: listModel
    PreFlightCheckModel {
        id:     listModel
        PreFlightCheckGroup {
            name: qsTr("Pengecekan Sensor & Baterai")
            PreFlightBatteryCheck {
                failurePercent:                 40
                allowFailurePercentOverride:    false
            }
            PreFlightSensorsHealthCheck {
            }
            PreFlightGPSCheck {
                failureSatCount:        9
                allowOverrideSatCount:  true
            }
            PreFlightRCCheck {
            }
            PreFlightSoundCheck {
            }
        }

        PreFlightCheckGroup {
            name: qsTr("Persiapan terakhir sebelum terbang")

            // Check list item group 2 - Final checks before launch
            PreFlightCheckButton {
                name:           qsTr("Misi")
                manualText:     qsTr("Harap konfirmasikan bahwa misi tersebut valid (titik arah valid, tidak ada tabrakan medan).")
            }
            PreFlightCheckButton {
                name:           qsTr("Payload")
                manualText:     qsTr("Apakah Payload Sudah Terpasang dengan Benar?")
            }

            PreFlightCheckButton {
                name:           qsTr("Angin & Cuaca")
                manualText:     qsTr("Apakah aman untuk menerbangkan Multirotor")
            }

            PreFlightCheckButton {
                name:           qsTr("Flight area")
                manualText:     qsTr("Area peluncuran dan jalur bebas dari gangguan/orang?")
            }
        }
    }
}
