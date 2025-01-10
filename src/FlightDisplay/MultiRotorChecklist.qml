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
            name: qsTr("Pemeriksaan Fisik")
            PreFlightCheckButton {
                name:           qsTr("Frame")
                manualText:     qsTr("Apakah frame sudah terpasang dengan baik? Tidak ada kendor? Kondisi layak terbang?")
            }
            PreFlightCheckButton {
                name:           qsTr("Motor")
                manualText:     qsTr("Apakah motor sudah terpasang dengan kuat? Tidak ada kendor? Kondisi layak terbang?")
            }
            PreFlightCheckButton {
                name:           qsTr("Propeller")
                manualText:     qsTr("Apakah propeller (baling-baling) sudah terpasang dengan kuat? Tidak ada kendor? Kondisi layak terbang?")
            }
            PreFlightCheckButton {
                name:           qsTr("Kabel")
                manualText:     qsTr("Apakah koneksi kabel tidak ada yang longgar, terkelupas dan putus?")
            }
        }
        PreFlightCheckGroup {
            name: qsTr("Pemeriksaan Sistem")
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
            name: qsTr("Pemeriksaan Baterai")
            PreFlightBatteryCheck {
                failurePercent:                 40
                allowFailurePercentOverride:    false
            }
            PreFlightCheckButton {
                name:           qsTr("Baterai RC")
                manualText:     qsTr("Apakah baterai RC sudah terisi daya penuh?")
            }
            PreFlightCheckButton {
                name:           qsTr("Baterai GCS (Ground Control Station)")
                manualText:     qsTr("Apakah baterai GCS sudah terisi daya penuh?")
            }
        }
        PreFlightCheckGroup {
            name: qsTr("Pemeriksaan Payload")
            PreFlightCheckButton {
                name:           qsTr("Daya")
                manualText:     qsTr("Apakah Payload sudah dinyalakan?")
            }
            PreFlightCheckButton {
                name:           qsTr("Kondisi")
                manualText:     qsTr("Apakah Payload Sudah Terpasang dengan Benar? dalam kondisi baik?")
            }
            PreFlightCheckButton {
                name:           qsTr("Fungsi")
                manualText:     qsTr("Lakukan uji coba fungsi dari Payload yang digunakan")
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
