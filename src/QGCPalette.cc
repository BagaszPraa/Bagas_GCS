/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


/// @file
///     @author Don Gagne <don@thegagnes.com>

#include "QGCPalette.h"
#include "QGCApplication.h"
#include "QGCCorePlugin.h"

#include <QApplication>
#include <QPalette>

QList<QGCPalette*>   QGCPalette::_paletteObjects;

QGCPalette::Theme QGCPalette::_theme = QGCPalette::Dark;

QMap<int, QMap<int, QMap<QString, QColor>>> QGCPalette::_colorInfoMap;

QStringList QGCPalette::_colors;

QGCPalette::QGCPalette(QObject* parent) :
    QObject(parent),
    _colorGroupEnabled(true)
{
    if (_colorInfoMap.isEmpty()) {
        _buildMap();
    }

    // We have to keep track of all QGCPalette objects in the system so we can signal theme change to all of them
    _paletteObjects += this;
}

QGCPalette::~QGCPalette()
{
    bool fSuccess = _paletteObjects.removeOne(this);
    if (!fSuccess) {
        qWarning() << "Internal error";
    }
}

void QGCPalette::_buildMap()
{
    DECLARE_QGC_COLOR(window, "#fff7fc", "#e4e4e4", "#05014f", "#000000")
    DECLARE_QGC_COLOR(windowShadeLight, "#909090", "#e4e4e4", "#707070", "#626262")
    DECLARE_QGC_COLOR(windowShade, "#79cbe8", "#ffffff", "#05014f", "#212121")
    DECLARE_QGC_COLOR(windowShadeDark, "#bdbdbd", "#e4e4e4", "#05014f", "#212121")
    DECLARE_QGC_COLOR(text, "#9d9d9d", "#000000", "#707070", "#e8e8e8")
    DECLARE_QGC_COLOR(warningText, "#cc0808", "#cc0808", "#f85761", "#f85761")
    DECLARE_QGC_COLOR(button, "#ffffff", "#79cbe8", "#707070", "#02426d")
    DECLARE_QGC_COLOR(buttonText, "#9d9d9d", "#000000", "#a6a6a6", "#e8e8e8")
    DECLARE_QGC_COLOR(buttonHighlight, "#e4e4e4", "#02426d", "#3a3a3a", "#79cbe8")
    DECLARE_QGC_COLOR(buttonHighlightText, "#2c2c2c", "#ffffff", "#2c2c2c", "#000000")
    DECLARE_QGC_COLOR(primaryButton, "#585858", "#79cbe8", "#585858", "#8cb3be")
    DECLARE_QGC_COLOR(primaryButtonText, "#2c2c2c", "#000000", "#2c2c2c", "#000000")
    DECLARE_QGC_COLOR(textField, "#ffffff", "#ffffff", "#707070", "#e8e8e8")
    DECLARE_QGC_COLOR(textFieldText, "#808080", "#000000", "#000000", "#000000")
    DECLARE_QGC_COLOR(mapButton, "#585858", "#000000", "#585858", "#000000")
    DECLARE_QGC_COLOR(mapButtonHighlight, "#585858", "#be781c", "#585858", "#be781c")
    DECLARE_QGC_COLOR(mapIndicator, "#585858", "#be781c", "#585858", "#be781c")
    DECLARE_QGC_COLOR(mapIndicatorChild, "#585858", "#766043", "#585858", "#766043")
    DECLARE_QGC_COLOR(colorGreen, "#009431", "#059212", "#00e04b", "#00e04b")
    DECLARE_QGC_COLOR(colorOrange, "#b95604", "#b95604", "#de8500", "#de8500")
    DECLARE_QGC_COLOR(colorRed, "#ed3939", "#ed3939", "#f32836", "#f32836")
    DECLARE_QGC_COLOR(colorGrey, "#808080", "#808080", "#bfbfbf", "#bfbfbf")
    DECLARE_QGC_COLOR(colorBlue, "#1a72ff", "#1a72ff", "#536dff", "#536dff")
    DECLARE_QGC_COLOR(alertBackground, "#eecc44", "#eecc44", "#eecc44", "#eecc44")
    DECLARE_QGC_COLOR(alertBorder, "#808080", "#808080", "#808080", "#808080")
    DECLARE_QGC_COLOR(alertText, "#000000", "#000000", "#000000", "#000000")
    DECLARE_QGC_COLOR(missionItemEditor, "#585858", "#79cbe8", "#585858", "#02426d")
    DECLARE_QGC_COLOR(toolStripHoverColor, "#585858", "#79cbe8", "#585858", "#5c5c5c")
    DECLARE_QGC_COLOR(statusFailedText, "#9d9d9d", "#000000", "#707070", "#e8e8e8")
    DECLARE_QGC_COLOR(statusPassedText, "#9d9d9d", "#000000", "#707070", "#e8e8e8")
    DECLARE_QGC_COLOR(statusPendingText, "#9d9d9d", "#000000", "#707070", "#e8e8e8")
    DECLARE_QGC_COLOR(toolbarBackground, "#ffffff", "#b7d6e6", "#222222", "#000000")
    DECLARE_QGC_COLOR(brandingPurple, "#4a2c6d", "#4a2c6d", "#4a2c6d", "#4a2c6d")
    DECLARE_QGC_COLOR(brandingBlue, "#48d6ff", "#6045c5", "#48d6ff", "#6045c5")
    DECLARE_QGC_COLOR(toolStripFGColor, "#707070", "#ffffff", "#707070", "#ffffff")
    DECLARE_QGC_COLOR(mapWidgetBorderLight, "#ffffff", "#ffffff", "#ffffff", "#ffffff")
    DECLARE_QGC_COLOR(mapWidgetBorderDark, "#000000", "#000000", "#000000", "#000000")
    DECLARE_QGC_COLOR(mapMissionTrajectory, "#be781c", "#be781c", "#be781c", "#be781c")
    DECLARE_QGC_COLOR(surveyPolygonInterior, "#008000", "#008000", "#008000", "#008000")
    DECLARE_QGC_COLOR(surveyPolygonTerrainCollision, "#ff0000", "#ff0000", "#ff0000", "#ff0000")
}

void QGCPalette::setColorGroupEnabled(bool enabled)
{
    _colorGroupEnabled = enabled;
    emit paletteChanged();
}

void QGCPalette::setGlobalTheme(Theme newTheme)
{
    // Mobile build does not have themes
    if (_theme != newTheme) {
        _theme = newTheme;
        _signalPaletteChangeToAll();
    }
}

void QGCPalette::_signalPaletteChangeToAll()
{
    // Notify all objects of the new theme
    foreach (QGCPalette* palette, _paletteObjects) {
        palette->_signalPaletteChanged();
    }
}

void QGCPalette::_signalPaletteChanged()
{
    emit paletteChanged();
}
