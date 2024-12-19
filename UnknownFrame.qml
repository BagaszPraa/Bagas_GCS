import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQml.Models                 2.1
import QtQuick.Layouts              1.12

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0

Item {
    width:  60 * ScreenTools.defaultFontPixelWidth
    height:  60 * ScreenTools.defaultFontPixelWidth
    // property alias motorRotate_1: motorRotate_1
    // property alias motorRotate_2: motorRotate_2
    // property alias motorRotate_3: motorRotate_3
    // property alias motorRotate_4: motorRotate_4
    Image {
        id: motorAnimasi
        source: "/qmlimages/Airframe/AirframeUnknown" // Path ke gambar pic1.svg
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
    }
}
