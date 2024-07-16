/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Layouts          1.2

import QGroundControl                           1.0
import QGroundControl.ScreenTools               1.0
import QGroundControl.Controls                  1.0
import QGroundControl.Palette                   1.0
import QGroundControl.Vehicle                   1.0
import QGroundControl.FlightMap                 1.0

/// This provides the smarts behind the guided mode commands, minus the user interface. This way you can change UI
/// without affecting the underlying functionality.
Item {
    id: _root

    property var missionController
    property var confirmDialog
    property var actionList
    property var guidedValueSlider
    property var orbitMapCircle

    readonly property string emergencyStopTitle:            qsTr("PEMBERHENTIAN DARURAT")
    readonly property string armTitle:                      qsTr("Arm")
    readonly property string forceArmTitle:                 qsTr("Memaksa Arm")
    readonly property string disarmTitle:                   qsTr("Disarm")
    readonly property string rtlTitle:                      qsTr("Kembali")
    readonly property string takeoffTitle:                  qsTr("Takeoff")
    readonly property string gripperTitle:                  qsTr("Fungsi Gripper")
    readonly property string landTitle:                     qsTr("Land")
    readonly property string startMissionTitle:             qsTr("Mulai Misi ")
    readonly property string mvStartMissionTitle:           qsTr("Mulai Misi (MV) ")
    readonly property string continueMissionTitle:          qsTr("Lanjutkan Misi")
    readonly property string resumeMissionUploadFailTitle:  qsTr("Resume gagal")
    readonly property string pauseTitle:                    qsTr("Jeda")
    readonly property string mvPauseTitle:                  qsTr("Jeda (MV)")
    readonly property string changeAltTitle:                qsTr("Ubah ketinggian ")
    readonly property string changeCruiseSpeedTitle:        qsTr("Ubah Kecepatan Tanah Max")
    readonly property string changeAirspeedTitle:           qsTr("Ubah kecepatan udara")
    readonly property string orbitTitle:                    qsTr("Orbit")
    readonly property string landAbortTitle:                qsTr("Batal Landing")
    readonly property string setWaypointTitle:              qsTr("Setel Waypoint ")
    readonly property string gotoTitle:                     qsTr("Pergi ke Lokasi")
    readonly property string vtolTransitionTitle:           qsTr("Transisi VTOL")
    readonly property string roiTitle:                      qsTr("ROI")
    readonly property string setHomeTitle:                  qsTr("Set Home")
    readonly property string actionListTitle:               qsTr("Aksi")

    readonly property string armMessage:                        qsTr("Arm kendaraan.")
    readonly property string forceArmMessage:                   qsTr("Peringatan: Ini akan memaksa mempersenjatai kendaraan yang melewati pemeriksaan keselamatan.")
    readonly property string disarmMessage:                     qsTr("Disarm kendaraan")
    readonly property string emergencyStopMessage:              qsTr("PERINGATAN: Ini akan menghentikan semua motor. Jika kendaraan saat ini mengudara, ia akan jatuh.")
    readonly property string takeoffMessage:                    qsTr("Lepas landas dari tanah dan tahan posisi.")
    readonly property string gripperMessage:                    qsTr("Ambil atau lepaskan kargo")
    readonly property string startMissionMessage:               qsTr("Lepas landas dari tanah dan mulai misi saat ini.")
    readonly property string continueMissionMessage:            qsTr("Lanjutkan misi dari titik arah saat ini.")
    readonly property string resumeMissionUploadFailMessage:    qsTr("Unggah Misi Resume Gagal. Konfirmasikan untuk mencoba lagi mengunggah")
    readonly property string landMessage:                       qsTr("Mendarat kendaraan di posisi saat ini.")
    readonly property string rtlMessage:                        qsTr("Kembali ke posisi peluncuran kendaraan.")
    readonly property string changeAltMessage:                  qsTr("Ubah ketinggian kendaraan naik atau turun. ")
    readonly property string changeCruiseSpeedMessage:          qsTr("Ubah kecepatan pelayaran horizontal maksimum.")
    readonly property string changeAirspeedMessage:             qsTr("Ubah setpoint kecepatan udara yang setara")
    readonly property string gotoMessage:                       qsTr("Pindahkan kendaraan ke lokasi yang ditentukan.")
             property string setWaypointMessage:                qsTr("Sesuaikan titik arah saat ini %1.").arg(_actionData)
    readonly property string orbitMessage:                      qsTr("Orbit kendaraan di sekitar lokasi yang ditentukan.")
    readonly property string landAbortMessage:                  qsTr("Batalkan urutan pendaratan.")
    readonly property string pauseMessage:                      qsTr("Jeda kendaraan pada posisi saat ini, menyesuaikan ketinggian naik atau turun sesuai kebutuhan.")
    readonly property string mvPauseMessage:                    qsTr("Jeda semua kendaraan di posisi mereka saat ini.")
    readonly property string vtolTransitionFwdMessage:          qsTr("Transisi VTOL ke Penerbangan Sayap Memperbaiki.")
    readonly property string vtolTransitionMRMessage:           qsTr("Transisi VTOL ke penerbangan multi-rotor.")
    readonly property string roiMessage:                        qsTr("Jadikan lokasi yang ditentukan sebagai wilayah yang menarik.")
    readonly property string setHomeMessage:                    qsTr("Setel kendaraan pulang sebagai lokasi yang ditentukan. Ini akan mempengaruhi posisi pulang")

    readonly property int actionRTL:                        1
    readonly property int actionLand:                       2
    readonly property int actionTakeoff:                    3
    readonly property int actionArm:                        4
    readonly property int actionDisarm:                     5
    readonly property int actionEmergencyStop:              6
    readonly property int actionChangeAlt:                  7
    readonly property int actionGoto:                       8
    readonly property int actionSetWaypoint:                9
    readonly property int actionOrbit:                      10
    readonly property int actionLandAbort:                  11
    readonly property int actionStartMission:               12
    readonly property int actionContinueMission:            13
    readonly property int actionResumeMission:              14
    readonly property int _actionUnused:                    15
    readonly property int actionResumeMissionUploadFail:    16
    readonly property int actionPause:                      17
    readonly property int actionMVPause:                    18
    readonly property int actionMVStartMission:             19
    readonly property int actionVtolTransitionToFwdFlight:  20
    readonly property int actionVtolTransitionToMRFlight:   21
    readonly property int actionROI:                        22
    readonly property int actionActionList:                 23
    readonly property int actionForceArm:                   24
    readonly property int actionChangeSpeed:                25
    readonly property int actionGripper:                    26
    readonly property int actionSetHome:                    27

    property var    _activeVehicle:             QGroundControl.multiVehicleManager.activeVehicle
    property bool   _useChecklist:              QGroundControl.settingsManager.appSettings.useChecklist.rawValue && QGroundControl.corePlugin.options.preFlightChecklistUrl.toString().length
    property bool   _enforceChecklist:          _useChecklist && QGroundControl.settingsManager.appSettings.enforceChecklist.rawValue
    property bool   _checklistPassed:           _activeVehicle ? (_useChecklist ? (_enforceChecklist ? _activeVehicle.checkListState === Vehicle.CheckListPassed : true) : true) : true
    property bool   _canArm:                    _activeVehicle ? (_checklistPassed && (!_activeVehicle.healthAndArmingCheckReport.supported || _activeVehicle.healthAndArmingCheckReport.canArm)) : false
    property bool   _canTakeoff:                _activeVehicle ? (_checklistPassed && (!_activeVehicle.healthAndArmingCheckReport.supported || _activeVehicle.healthAndArmingCheckReport.canTakeoff)) : false
    property bool   _canStartMission:           _activeVehicle ? (_checklistPassed && (!_activeVehicle.healthAndArmingCheckReport.supported || _activeVehicle.healthAndArmingCheckReport.canStartMission)) : false
    property bool   _initialConnectComplete:    _activeVehicle ? _activeVehicle.initialConnectComplete : false

    property bool showEmergenyStop:     _guidedActionsEnabled && !_hideEmergenyStop && _vehicleArmed && _vehicleFlying
    property bool showArm:              _guidedActionsEnabled && !_vehicleArmed && _canArm
    property bool showForceArm:         _guidedActionsEnabled && !_vehicleArmed
    property bool showDisarm:           _guidedActionsEnabled && _vehicleArmed && !_vehicleFlying
    property bool showRTL:              _guidedActionsEnabled && _vehicleArmed && _activeVehicle.guidedModeSupported && _vehicleFlying && !_vehicleInRTLMode
    property bool showTakeoff:          _guidedActionsEnabled && _activeVehicle.takeoffVehicleSupported && !_vehicleFlying && _canTakeoff
    property bool showLand:             _guidedActionsEnabled && _activeVehicle.guidedModeSupported && _vehicleArmed && !_activeVehicle.fixedWing && !_vehicleInLandMode
    property bool showStartMission:     _guidedActionsEnabled && _missionAvailable && !_missionActive && !_vehicleFlying && _canStartMission
    property bool showContinueMission:  _guidedActionsEnabled && _missionAvailable && !_missionActive && _vehicleArmed && _vehicleFlying && (_currentMissionIndex < _missionItemCount - 1)
    property bool showPause:            _guidedActionsEnabled && _vehicleArmed && _activeVehicle.pauseVehicleSupported && _vehicleFlying && !_vehiclePaused && !_fixedWingOnApproach
    property bool showChangeAlt:        _guidedActionsEnabled && _vehicleFlying && _activeVehicle.guidedModeSupported && _vehicleArmed && !_missionActive
    property bool showChangeSpeed:      _guidedActionsEnabled && _vehicleFlying && _activeVehicle.guidedModeSupported && _vehicleArmed && !_missionActive && _speedLimitsAvailable
    property bool showOrbit:            _guidedActionsEnabled && _vehicleFlying && __orbitSupported && !_missionActive
    property bool showROI:              _guidedActionsEnabled && _vehicleFlying && __roiSupported && !_missionActive
    property bool showLandAbort:        _guidedActionsEnabled && _vehicleFlying && _fixedWingOnApproach
    property bool showGotoLocation:     _guidedActionsEnabled && _vehicleFlying
    property bool showSetHome:          _guidedActionsEnabled
    property bool showActionList:       _guidedActionsEnabled && (showStartMission || showResumeMission || showChangeAlt || showLandAbort || actionList.hasCustomActions)
    property bool showGripper:          _initialConnectComplete ? _activeVehicle.hasGripper : false
    property string changeSpeedTitle:   _fixedWing ? changeAirspeedTitle : changeCruiseSpeedTitle
    property string changeSpeedMessage: _fixedWing ? changeAirspeedMessage : changeCruiseSpeedMessage

    // Note: The '_missionItemCount - 2' is a hack to not trigger resume mission when a mission ends with an RTL item
    property bool showResumeMission:    _activeVehicle && !_vehicleArmed && _vehicleWasFlying && _missionAvailable && _resumeMissionIndex > 0 && (_resumeMissionIndex < _missionItemCount - 2)

    property bool guidedUIVisible:      confirmDialog.visible || actionList.visible

    property var    _corePlugin:            QGroundControl.corePlugin
    property var    _corePluginOptions:     QGroundControl.corePlugin.options
    property bool   _guidedActionsEnabled:  (!ScreenTools.isDebug && _corePluginOptions.guidedActionsRequireRCRSSI && _activeVehicle) ? _rcRSSIAvailable : _activeVehicle
    property string _flightMode:            _activeVehicle ? _activeVehicle.flightMode : ""
    property bool   _missionAvailable:      missionController.containsItems
    property bool   _missionActive:         _activeVehicle ? _vehicleArmed && (_vehicleInLandMode || _vehicleInRTLMode || _vehicleInMissionMode) : false
    property bool   _vehicleArmed:          _activeVehicle ? _activeVehicle.armed  : false
    property bool   _vehicleFlying:         _activeVehicle ? _activeVehicle.flying  : false
    property bool   _vehicleLanding:        _activeVehicle ? _activeVehicle.landing  : false
    property bool   _vehiclePaused:         false
    property bool   _vehicleInMissionMode:  false
    property bool   _vehicleInRTLMode:      false
    property bool   _vehicleInLandMode:     false
    property int    _missionItemCount:      missionController.missionItemCount
    property int    _currentMissionIndex:   missionController.currentMissionIndex
    property int    _resumeMissionIndex:    missionController.resumeMissionIndex
    property bool   _hideEmergenyStop:      !_corePluginOptions.flyView.guidedBarShowEmergencyStop
    property bool   _hideOrbit:             !_corePluginOptions.flyView.guidedBarShowOrbit
    property bool   _hideROI:               !_corePluginOptions.flyView.guidedBarShowROI
    property bool   _vehicleWasFlying:      false
    property bool   _rcRSSIAvailable:       _activeVehicle ? _activeVehicle.rcRSSI > 0 && _activeVehicle.rcRSSI <= 100 : false
    property bool   _fixedWingOnApproach:   _activeVehicle ? _activeVehicle.fixedWing && _vehicleLanding : false
    property bool   _fixedWing:             _activeVehicle ? _activeVehicle.fixedWing || _activeVehicle.vtolInFwdFlight : false
    property bool  _speedLimitsAvailable:   _activeVehicle && ((_fixedWing && _activeVehicle.haveFWSpeedLimits) || (!_fixedWing && _activeVehicle.haveMRSpeedLimits))
    property var   _gripperFunction:        undefined

    // You can turn on log output for GuidedActionsController by turning on GuidedActionsControllerLog category
    property bool __guidedModeSupported:    _activeVehicle ? _activeVehicle.guidedModeSupported : false
    property bool __pauseVehicleSupported:  _activeVehicle ? _activeVehicle.pauseVehicleSupported : false
    property bool __roiSupported:           _activeVehicle ? !_hideROI && _activeVehicle.roiModeSupported : false
    property bool __orbitSupported:         _activeVehicle ? !_hideOrbit && _activeVehicle.orbitModeSupported : false
    property bool __flightMode:             _flightMode

    function _outputState() {
        if (_corePlugin.guidedActionsControllerLogging()) {
            console.log(qsTr("_activeVehicle(%1) _vehicleArmed(%2) guidedModeSupported(%3) _vehicleFlying(%4) _vehicleWasFlying(%5) _vehicleInRTLMode(%6) pauseVehicleSupported(%7) _vehiclePaused(%8) _flightMode(%9) _missionItemCount(%10) roiSupported(%11) orbitSupported(%12) _missionActive(%13) _hideROI(%14) _hideOrbit(%15)").arg(_activeVehicle ? 1 : 0).arg(_vehicleArmed ? 1 : 0).arg(__guidedModeSupported ? 1 : 0).arg(_vehicleFlying ? 1 : 0).arg(_vehicleWasFlying ? 1 : 0).arg(_vehicleInRTLMode ? 1 : 0).arg(__pauseVehicleSupported ? 1 : 0).arg(_vehiclePaused ? 1 : 0).arg(_flightMode).arg(_missionItemCount).arg(__roiSupported).arg(__orbitSupported).arg(_missionActive).arg(_hideROI).arg(_hideOrbit))
        }
    }

    function setupSlider(actionCode) {
        // generic defaults
        guidedValueSlider.configureAsLinearSlider()
        guidedValueSlider.setIsSpeedSlider(false)

        if (actionCode === actionTakeoff) {
                guidedValueSlider.setMinVal(_activeVehicle.minimumTakeoffAltitude())
                guidedValueSlider.setValue(_activeVehicle ? _activeVehicle.minimumTakeoffAltitude() : 0)
                guidedValueSlider.setDisplayText("Tinggi")
        } else if (actionCode === actionChangeSpeed) {
            guidedValueSlider.setIsSpeedSlider(true)
            if (_fixedWing) {
                guidedValueSlider.setDisplayText("Atur kecepatan udara")
                guidedValueSlider.setMinVal(QGroundControl.unitsConversion.metersSecondToAppSettingsSpeedUnits(_activeVehicle.minimumEquivalentAirspeed()).toFixed(1))
                guidedValueSlider.setMaxVal(QGroundControl.unitsConversion.metersSecondToAppSettingsSpeedUnits(_activeVehicle.maximumEquivalentAirspeed()).toFixed(1))
                guidedValueSlider.setValue(_activeVehicle.airSpeed.value)
            } else if (!_fixedWing && _activeVehicle.haveMRSpeedLimits) {
                guidedValueSlider.setDisplayText("Atur kecepatan")
                guidedValueSlider.setMinVal(QGroundControl.unitsConversion.metersSecondToAppSettingsSpeedUnits(0.1).toFixed(1))
                guidedValueSlider.setMaxVal(QGroundControl.unitsConversion.metersSecondToAppSettingsSpeedUnits(_activeVehicle.maximumHorizontalSpeedMultirotor()).toFixed(1))
                guidedValueSlider.setValue(QGroundControl.unitsConversion.metersSecondToAppSettingsSpeedUnits(_activeVehicle.maximumHorizontalSpeedMultirotor()/2).toFixed(1))
            }
        } else if (actionCode === actionChangeAlt || actionCode === actionOrbit || actionCode === actionGoto || actionCode === actionPause) {
            guidedValueSlider.setDisplayText("Alt baru (rel)")
            guidedValueSlider.configureAsRelativeAltSliderExp()
        }
    }

    on_ActiveVehicleChanged: _outputState()

    Component.onCompleted:              _outputState()
    on_VehicleArmedChanged:             _outputState()
    on_VehicleInRTLModeChanged:         _outputState()
    on_VehiclePausedChanged:            _outputState()
    on__FlightModeChanged:              _outputState()
    on__GuidedModeSupportedChanged:     _outputState()
    on__PauseVehicleSupportedChanged:   _outputState()
    on__RoiSupportedChanged:            _outputState()
    on__OrbitSupportedChanged:          _outputState()
    on_MissionItemCountChanged:         _outputState()
    on_MissionActiveChanged:            _outputState()

    on_CurrentMissionIndexChanged: {
        if (_corePlugin.guidedActionsControllerLogging()) {
            console.log("_currentMissionIndex", _currentMissionIndex)
        }
    }
    on_ResumeMissionIndexChanged: {
        if (_corePlugin.guidedActionsControllerLogging()) {
            console.log("_resumeMissionIndex", _resumeMissionIndex)
        }
    }
    onShowResumeMissionChanged: {
        if (_corePlugin.guidedActionsControllerLogging()) {
            console.log("showResumeMission", showResumeMission)
        }
        _outputState()
    }
    onShowStartMissionChanged: {
        if (_corePlugin.guidedActionsControllerLogging()) {
            console.log("showStartMission", showStartMission)
        }
        _outputState()
        if (showStartMission) {
            confirmAction(actionStartMission)
        }
    }
    onShowContinueMissionChanged: {
        if (_corePlugin.guidedActionsControllerLogging()) {
            console.log("showContinueMission", showContinueMission)
        }
        _outputState()
        if (showContinueMission) {
            confirmAction(actionContinueMission)
        }
    }
    onShowRTLChanged: {
        if (_corePlugin.guidedActionsControllerLogging()) {
            console.log("showRTL", showRTL)
        }
        _outputState()
    }
    onShowChangeAltChanged: {
        if (_corePlugin.guidedActionsControllerLogging()) {
            console.log("showChangeAlt", showChangeAlt)
        }
        _outputState()
    }
    onShowROIChanged: {
        if (_corePlugin.guidedActionsControllerLogging()) {
            console.log("showROI", showROI)
        }
        _outputState()
    }
    onShowOrbitChanged: {
        if (_corePlugin.guidedActionsControllerLogging()) {
            console.log("showOrbit", showOrbit)
        }
        _outputState()
    }
    onShowGotoLocationChanged: {
        if (_corePlugin.guidedActionsControllerLogging()) {
            console.log("showGotoLocation", showGotoLocation)
        }
        _outputState()
    }
    onShowLandAbortChanged: {
        if (showLandAbort) {
            confirmAction(actionLandAbort)
        }
    }

    on_VehicleFlyingChanged: {
        _outputState()
        if (!_vehicleFlying) {
            // We use _vehicleWasFLying to help trigger Resume Mission only if the vehicle actually flew and came back down.
            // Otherwise it may trigger during the Start Mission sequence due to signal ordering or armed and resume mission index.
            _vehicleWasFlying = true
        }
    }

    property var _actionData

    on_FlightModeChanged: {
        _vehiclePaused =        _activeVehicle ? _flightMode === _activeVehicle.pauseFlightMode : false
        _vehicleInRTLMode =     _activeVehicle ? _flightMode === _activeVehicle.rtlFlightMode || _flightMode === _activeVehicle.smartRTLFlightMode : false
        _vehicleInLandMode =    _activeVehicle ? _flightMode === _activeVehicle.landFlightMode : false
        _vehicleInMissionMode = _activeVehicle ? _flightMode === _activeVehicle.missionFlightMode : false // Must be last to get correct signalling for showStartMission popups
    }

    Connections {
        target:                     missionController
        function onResumeMissionUploadFail() { confirmAction(actionResumeMissionUploadFail) }
    }

    Connections {
        target:                             mainWindow
        function onArmVehicleRequest() { armVehicleRequest() }
        function onForceArmVehicleRequest() { forceArmVehicleRequest() }
        function onDisarmVehicleRequest() { disarmVehicleRequest() }
        function onVtolTransitionToFwdFlightRequest() { vtolTransitionToFwdFlightRequest() }
        function onVtolTransitionToMRFlightRequest() { vtolTransitionToMRFlightRequest() }
    }

    function armVehicleRequest() {
        confirmAction(actionArm)
    }

    function forceArmVehicleRequest() {
        confirmAction(actionForceArm)
    }

    function disarmVehicleRequest() {
        if (showEmergenyStop) {
            confirmAction(actionEmergencyStop)
        } else {
            confirmAction(actionDisarm)
        }

    }

    function vtolTransitionToFwdFlightRequest() {
        confirmAction(actionVtolTransitionToFwdFlight)
    }

    function vtolTransitionToMRFlightRequest() {
        confirmAction(actionVtolTransitionToMRFlight)
    }

    function closeAll() {
        confirmDialog.visible =     false
        actionList.visible =        false
        guidedValueSlider.visible =    false
    }

    // Called when an action is about to be executed in order to confirm
    function confirmAction(actionCode, actionData, mapIndicator) {
        var showImmediate = true
        closeAll()
        confirmDialog.action = actionCode
        confirmDialog.actionData = actionData
        confirmDialog.hideTrigger = true
        confirmDialog.mapIndicator = mapIndicator
        confirmDialog.optionText = ""
        _actionData = actionData

        setupSlider(actionCode)

        switch (actionCode) {
        case actionArm:
            if (_vehicleFlying || !_guidedActionsEnabled) {
                return
            }
            confirmDialog.title = armTitle
            confirmDialog.message = armMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showArm })
            break;
        case actionForceArm:
            confirmDialog.title = forceArmTitle
            confirmDialog.message = forceArmMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showForceArm })
            break;
        case actionDisarm:
            if (_vehicleFlying) {
                return
            }
            confirmDialog.title = disarmTitle
            confirmDialog.message = disarmMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showDisarm })
            break;
        case actionEmergencyStop:
            confirmDialog.title = emergencyStopTitle
            confirmDialog.message = emergencyStopMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showEmergenyStop })
            break;
        case actionTakeoff:
            confirmDialog.title = takeoffTitle
            confirmDialog.message = takeoffMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showTakeoff })
            guidedValueSlider.visible = true
            break;
        case actionStartMission:
            showImmediate = false
            confirmDialog.title = startMissionTitle
            confirmDialog.message = startMissionMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showStartMission })
            break;
        case actionMVStartMission:
            confirmDialog.title = mvStartMissionTitle
            confirmDialog.message = startMissionMessage
            confirmDialog.hideTrigger = true
            break;
        case actionContinueMission:
            showImmediate = false
            confirmDialog.title = continueMissionTitle
            confirmDialog.message = continueMissionMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showContinueMission })
            break;
        case actionResumeMission:
            // Resume Mission is handled in mission end dialog
            return
        case actionResumeMissionUploadFail:
            confirmDialog.title = resumeMissionUploadFailTitle
            confirmDialog.message = resumeMissionUploadFailMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showResumeMission })
            break;
        case actionLand:
            confirmDialog.title = landTitle
            confirmDialog.message = landMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showLand })
            break;
        case actionRTL:
            confirmDialog.title = rtlTitle
            confirmDialog.message = rtlMessage
            if (_activeVehicle.supportsSmartRTL) {
                confirmDialog.optionText = qsTr("Smart RTL")
                confirmDialog.optionChecked = false
            }
            confirmDialog.hideTrigger = Qt.binding(function() { return !showRTL })
            break;
        case actionChangeAlt:
            confirmDialog.title = changeAltTitle
            confirmDialog.message = changeAltMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showChangeAlt })
            guidedValueSlider.visible = true
            break;
        case actionGoto:
            confirmDialog.title = gotoTitle
            confirmDialog.message = gotoMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showGotoLocation })
            break;
        case actionSetWaypoint:
            confirmDialog.title = setWaypointTitle
            confirmDialog.message = setWaypointMessage
            break;
        case actionOrbit:
            confirmDialog.title = orbitTitle
            confirmDialog.message = orbitMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showOrbit })
            guidedValueSlider.visible = true
            break;
        case actionLandAbort:
            confirmDialog.title = landAbortTitle
            confirmDialog.message = landAbortMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showLandAbort })
            break;
        case actionPause:
            confirmDialog.title = pauseTitle
            confirmDialog.message = pauseMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showPause })
            guidedValueSlider.visible = true
            break;
        case actionMVPause:
            confirmDialog.title = mvPauseTitle
            confirmDialog.message = mvPauseMessage
            confirmDialog.hideTrigger = true
            break;
        case actionVtolTransitionToFwdFlight:
            confirmDialog.title = vtolTransitionTitle
            confirmDialog.message = vtolTransitionFwdMessage
            confirmDialog.hideTrigger = true
            break
        case actionVtolTransitionToMRFlight:
            confirmDialog.title = vtolTransitionTitle
            confirmDialog.message = vtolTransitionMRMessage
            confirmDialog.hideTrigger = true
            break
        case actionROI:
            confirmDialog.title = roiTitle
            confirmDialog.message = roiMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showROI })
            break;
        case actionActionList:
            actionList.show()
            return
        case actionChangeSpeed:
            confirmDialog.hideTrigger = true
            confirmDialog.title = changeSpeedTitle
            confirmDialog.message = changeSpeedMessage
            guidedValueSlider.visible = true
            break
        case actionGripper:
            confirmDialog.hideTrigger = true
            confirmDialog.title = gripperTitle
            confirmDialog.message = gripperMessage
            _widgetLayer._gripperMenu.createObject(mainWindow).open()
            break
        case actionSetHome:
            confirmDialog.title = setHomeTitle
            confirmDialog.message = setHomeMessage
            confirmDialog.hideTrigger = Qt.binding(function() { return !showSetHome })
            break
        default:
            console.warn("Unknown actionCode", actionCode)
            return
        }
        confirmDialog.show(showImmediate)
    }

    // Executes the specified action
    function executeAction(actionCode, actionData, sliderOutputValue, optionChecked) {
        var i;
        var rgVehicle;
        switch (actionCode) {
        case actionRTL:
            _activeVehicle.guidedModeRTL(optionChecked)
            break
        case actionLand:
            _activeVehicle.guidedModeLand()
            break
        case actionTakeoff:
            _activeVehicle.guidedModeTakeoff(sliderOutputValue)
            break
        case actionResumeMission:
        case actionResumeMissionUploadFail:
            missionController.resumeMission(missionController.resumeMissionIndex)
            break
        case actionStartMission:
        case actionContinueMission:
            _activeVehicle.startMission()
            break
        case actionMVStartMission:
            rgVehicle = QGroundControl.multiVehicleManager.vehicles
            for (i = 0; i < rgVehicle.count; i++) {
                rgVehicle.get(i).startMission()
            }
            break
        case actionArm:
            _activeVehicle.armed = true
            break
        case actionForceArm:
            _activeVehicle.forceArm()
            break
        case actionDisarm:
            _activeVehicle.armed = false
            break
        case actionEmergencyStop:
            _activeVehicle.emergencyStop()
            break
        case actionChangeAlt:
            _activeVehicle.guidedModeChangeAltitude(sliderOutputValue, false /* pauseVehicle */)
            break
        case actionGoto:
            _activeVehicle.guidedModeGotoLocation(actionData)
            break
        case actionSetWaypoint:
            _activeVehicle.setCurrentMissionSequence(actionData)
            break
        case actionOrbit:
            _activeVehicle.guidedModeOrbit(orbitMapCircle.center, orbitMapCircle.radius() * (orbitMapCircle.clockwiseRotation ? 1 : -1), _activeVehicle.altitudeAMSL.rawValue + sliderOutputValue)
            break
        case actionLandAbort:
            _activeVehicle.abortLanding(50)     // hardcoded value for climbOutAltitude that is currently ignored
            break
        case actionPause:
            _activeVehicle.guidedModeChangeAltitude(sliderOutputValue, true /* pauseVehicle */)
            break
        case actionMVPause:
            rgVehicle = QGroundControl.multiVehicleManager.vehicles
            for (i = 0; i < rgVehicle.count; i++) {
                rgVehicle.get(i).pauseVehicle()
            }
            break
        case actionVtolTransitionToFwdFlight:
            _activeVehicle.vtolInFwdFlight = true
            break
        case actionVtolTransitionToMRFlight:
            _activeVehicle.vtolInFwdFlight = false
            break
        case actionROI:
            _activeVehicle.guidedModeROI(actionData)
            break
        case actionChangeSpeed:
            if (_activeVehicle) {
                // We need to convert back to m/s as that is what mavlink standard uses for MAV_CMD_DO_CHANGE_SPEED
                var metersSecondSpeed = QGroundControl.unitsConversion.appSettingsSpeedUnitsToMetersSecond(sliderOutputValue).toFixed(1)
                if (_activeVehicle.vtolInFwdFlight || _activeVehicle.fixedWing) {
                   _activeVehicle.guidedModeChangeEquivalentAirspeedMetersSecond(metersSecondSpeed)
                } else {
                    _activeVehicle.guidedModeChangeGroundSpeedMetersSecond(metersSecondSpeed)
                }
            }
            break
        case actionGripper:
            _gripperFunction === undefined ? _activeVehicle.sendGripperAction(Vehicle.Invalid_option) : _activeVehicle.sendGripperAction(_gripperFunction)
            break
        case actionSetHome:
            _activeVehicle.doSetHome(actionData)
            break
        default:
            console.warn(qsTr("Internal error: unknown actionCode"), actionCode)
            break
        }
    }
}
