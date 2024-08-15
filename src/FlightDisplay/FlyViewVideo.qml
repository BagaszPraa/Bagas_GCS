/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick 2.12
import QtQuick.Controls                 2.12

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.ScreenTools   1.0
import customcontrols               1.0

Item {
    id:         _root
    visible:    QGroundControl.videoManager.hasVideo
    property Item pipState: videoPipState
    QGCPipState {
        id:         videoPipState
        pipOverlay: _pipOverlay
        isDark:     true

        onWindowAboutToOpen: {
            QGroundControl.videoManager.stopVideo()
            videoStartDelay.start()
        }

        onWindowAboutToClose: {
            QGroundControl.videoManager.stopVideo()
            videoStartDelay.start()
        }

        onStateChanged: {
            if (pipState.state !== pipState.fullState) {
                QGroundControl.videoManager.fullScreen = false
            }
        }
    }

    Timer {
        id:           videoStartDelay
        interval:     2000;
        running:      false
        repeat:       false
        onTriggered:  QGroundControl.videoManager.startVideo()
    }

    //-- Video Streaming
    FlightDisplayViewVideo {
        id:             videoStreaming
        anchors.fill:   parent
        useSmallFont:   _root.pipState.state !== _root.pipState.fullState
        visible:        QGroundControl.videoManager.isGStreamer
    }
    //-- UVC Video (USB Camera or Video Device)
    Loader {
        id:             cameraLoader
        anchors.fill:   parent
        visible:        !QGroundControl.videoManager.isGStreamer
        source:         QGroundControl.videoManager.uvcEnabled ? "qrc:/qml/FlightDisplayViewUVC.qml" : "qrc:/qml/FlightDisplayViewDummy.qml"
    }
    // roiSender{
    //     id : roiSender
    // }
    ROIsender{
        id : roisender
    }

    QGCLabel {
        text: qsTr("Double-click to exit full screen")
        font.pointSize: ScreenTools.largeFontPointSize
        visible: QGroundControl.videoManager.fullScreen && flyViewVideoMouseArea.containsMouse
        anchors.centerIn: parent
        onVisibleChanged: {
            if (visible) {
                labelAnimation.start()
            }
        }
        PropertyAnimation on opacity {
            id: labelAnimation
            duration: 10000
            from: 1.0
            to: 0.0
            easing.type: Easing.InExpo
        }
    }

    MouseArea {
        id: flyViewVideoMouseArea
        anchors.fill: parent
        enabled: pipState.state === pipState.fullState
        hoverEnabled: true
        onDoubleClicked: QGroundControl.videoManager.fullScreen = !QGroundControl.videoManager.fullScreen
        Rectangle {
            id: pembatas
            anchors.centerIn: parent
            width: parent.width * 0.90
            height: parent.height
            border.color: "green"
            border.width: 5
            color: "transparent"
            property int targetWidth: 640
            property int targetHeight: 480
            property real scaleX: targetWidth / width
            property real scaleY: targetHeight / height
            property real convertedX: Math.round(roiSelector.x * scaleX)
            property real convertedY: Math.round(roiSelector.x * scaleY)
            property real convertedWidth: Math.round(roiSelector.width * scaleX)
            property real convertedHeight: Math.round(roiSelector.height * scaleY)
            Rectangle {
                id: roiSelector
                color: "transparent"
                border.color: "blue"
                border.width: 5
                width: 100
                height: 100
                visible: false
                onXChanged: {
                    if (x < 0) x = 0;
                    if (x + width > parent.width) x = parent.width - width;
                }
                onYChanged: {
                    if (y < 0) y = 0;
                    if (y + height > parent.height) y = parent.height - height;
                }
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                property bool selecting: false
                onPressed: {
                    selecting = true;
                    roiSelector.x = mouse.x - roiSelector.width / 2;
                    roiSelector.y = mouse.y - roiSelector.height / 2;
                    roiSelector.visible = true;
                    console.log(qsTr("Pressed"))
                }
                onPositionChanged: {
                    if (selecting) {
                        roiSelector.x = mouse.x - roiSelector.width / 2;
                        roiSelector.y = mouse.y - roiSelector.height / 2;
                        console.log(qsTr("Dragged"))
                    }
                }
                onReleased: {
                    selecting = false;
                    roiSelector.visible = false;
                    let logData = qsTr("%1,%2,%3,%4")
                                .arg(pembatas.convertedX)
                                .arg(pembatas.convertedY)
                                .arg(pembatas.convertedWidth)
                                .arg(pembatas.convertedHeight);
                    roisender.sendData(logData);
                    console.log(logData);
                    // console.log(qsTr("%1,%2,%3,%4")
                    //         .arg(parent.convertedX)
                    //         .arg(parent.convertedY)
                    //         .arg(parent.convertedWidth)
                    //         .arg(parent.convertedHeight))
                }
            }
        }
    }

    ProximityRadarVideoView{
        anchors.fill:   parent
        vehicle:        QGroundControl.multiVehicleManager.activeVehicle
    }

    ObstacleDistanceOverlayVideo {
        id: obstacleDistance
        showText: pipState.state === pipState.fullState
    }
}
