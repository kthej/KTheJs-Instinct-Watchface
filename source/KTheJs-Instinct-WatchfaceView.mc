import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Application;
using Toybox.Application.Properties as Store;

class KTheJs_Instinct_WatchfaceView extends WatchUi.WatchFace {

    // Main Variable Assignments //////////////////////////////////////////////////////////////////////

    // Main Clock variables

    public var hours_element;
    public var minutes_element;
    public var lastHourCheckVar = -1;

    // Fonts, all custom made :)

    public var FONT_BLACK;
    public var FONT_WHITE;
    public var FONT_SMALL;
    public var FONT_MEDIUM_HOLLOW;
    public var FONT_MEDIUM_FILLED;
    public var FONT_DATA;

    // Colors

    public var COLOR_WHITE = Graphics.COLOR_WHITE;
    public var COLOR_BLACK = Graphics.COLOR_BLACK;
    public var COLOR_CLEAR = Graphics.COLOR_TRANSPARENT;

    // Text Alignment
    public var ALIGN_LEFT = Graphics.TEXT_JUSTIFY_LEFT;
    public var ALIGN_RIGHT = Graphics.TEXT_JUSTIFY_RIGHT;
    public var ALIGN_CENTER = Graphics.TEXT_JUSTIFY_CENTER;
    public var ALIGN_VCENTER = Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER;

    // Icons

    public var Icons;
    // Settings Options

    public var dataField1Value;
    public var dataField2Value;
    public var dataField3Value;
    public var dataField4Value;

    // Other

    public var hr_element;
    public var currentHeartRate;
    public var glance = true;

    // Functions and stuff ////////////////////////////////////////////////////////////////////////////

    // Initialization

    function initialize() { WatchFace.initialize(); }

    // Resource Loading

    function onLayout(dc as Dc) as Void {

        setLayout(Rez.Layouts.WatchFace(dc));

        FONT_BLACK = WatchUi.loadResource(Rez.Fonts.Time_Black);
        FONT_WHITE = WatchUi.loadResource(Rez.Fonts.Time_White);
        FONT_SMALL = WatchUi.loadResource(Rez.Fonts.SmallFont);
        FONT_MEDIUM_FILLED = WatchUi.loadResource(Rez.Fonts.MediumFontFilled);
        FONT_MEDIUM_HOLLOW = WatchUi.loadResource(Rez.Fonts.MediumFontHollow);
        FONT_DATA = WatchUi.loadResource(Rez.Fonts.DataFont);
        Icons = WatchUi.loadResource(Rez.Fonts.Icons);
    }

    // Called when this View is brought to the foreground

    function onShow() as Void {}

    // Main Loop

    function onUpdate(dc as Dc) as Void {

        // Main loop callback thingy

        View.onUpdate(dc);

        // Variables

        var is24Hour = System.getDeviceSettings().is24Hour;
        var clockTime = System.getClockTime();
        var hours = clockTime.hour.format("%02d");
        var minutes = clockTime.min.format("%02d");
        var timeFillPercentage = null;

        if (!is24Hour) { // Check for 12/24hr time.
            hours = (clockTime.hour % 12).format("%02d");
            if (hours.toFloat() == 0) {
                hours = 12;
            }
        }

        // Font Fill Drawing ///////////////////////////////////////////////////////////////////////////////

        // Draw Clock

        if (Store.getValue("TimeFill") == 1) {
            timeFillPercentage = (clockTime.hour.toFloat() * 60 + clockTime.min.toFloat()) / 1440;
        } else if (Store.getValue("TimeFill") == 2) {
            timeFillPercentage = ActivityMonitor.getInfo().steps.toFloat() /
                                 ActivityMonitor.getInfo().stepGoal.toFloat();
        } else if (Store.getValue("TimeFill") == 3) {
            timeFillPercentage = ActivityMonitor.getInfo().floorsClimbed.toFloat() /
                                 ActivityMonitor.getInfo().floorsClimbedGoal.toFloat();
        } else if (Store.getValue("TimeFill") == 4) {
            if (System.getSystemStats().solarIntensity != null) {
                timeFillPercentage = System.getSystemStats().solarIntensity.toFloat() / 100.0;
            } else {
                timeFillPercentage = 0;
            }
        } else {
            timeFillPercentage = (clockTime.hour.toFloat() * 60 + clockTime.min.toFloat()) / 1440;
        }
        if (timeFillPercentage > 1.0) {
            timeFillPercentage = 1.0;
        }
        dc.setColor(COLOR_WHITE, COLOR_CLEAR);
        dc.fillRectangle(30, 26, 65, 124);
        dc.setColor(COLOR_BLACK, COLOR_CLEAR);
        dc.fillRectangle(30, 26, 65, 124 * (1 - timeFillPercentage));

        dc.setColor(COLOR_BLACK, COLOR_CLEAR);
        dc.drawText(65, 25, FONT_BLACK, hours, ALIGN_CENTER);
        dc.drawText(65, 90, FONT_BLACK, minutes, ALIGN_CENTER);

        dc.setColor(COLOR_WHITE, COLOR_CLEAR);
        dc.drawText(65, 25, FONT_WHITE, hours, ALIGN_CENTER);
        dc.drawText(65, 90, FONT_WHITE, minutes, ALIGN_CENTER);
        dc.setColor(COLOR_BLACK, COLOR_CLEAR);

        dc.fillRectangle(60, 26, 5, 125); // Vertical black bar
        dc.fillRectangle(30, 86, 65, 5); // Horizontal black bar

        // SubScreen Circle ///////////////////////////////////////////////////////////////////////////////

        // Variables

        var sub_screen = WatchUi.getSubscreen();
        var sub_screen_x = sub_screen.x;
        var sub_screen_y = sub_screen.y;
        var sub_screen_width = sub_screen.width;
        var sub_screen_height = sub_screen.height;
        var sub_screen_middle_x = sub_screen_x + sub_screen_width / 2;
        var sub_screen_middle_y = sub_screen_y + sub_screen_height / 2;

        var integer_seconds = clockTime.sec as Integer;

        var arcThickness = 12;
        var circleRadius = sub_screen_width / 2 - arcThickness - 2;

        // Background for Seconds text (just a white circle)

        dc.setColor(COLOR_WHITE, COLOR_CLEAR);

        dc.fillCircle(sub_screen_middle_x, sub_screen_middle_y, circleRadius);

        // Seconds Arc

        dc.setColor(COLOR_WHITE, COLOR_CLEAR);
        dc.setPenWidth(arcThickness);

        if (integer_seconds != 0) {
            dc.drawArc(sub_screen_middle_x, sub_screen_middle_y, sub_screen_height / 2 - arcThickness / 2,
                       Graphics.ARC_CLOCKWISE, 90, -integer_seconds * 6 + 90);
        }

        // Seconds Text

        dc.setColor(COLOR_BLACK, COLOR_CLEAR);

        if (glance == true) {
            var seconds = clockTime.sec;
            dc.drawText(sub_screen_middle_x + 1, sub_screen_middle_y, FONT_MEDIUM_FILLED, seconds, ALIGN_VCENTER);
        }

        // Battery and battery icon ///////////////////////////////////////////////////////////////////////

        // Variables

        var batteryPercentage = System.getSystemStats().battery.format("%.0f");
        var recX = 70;
        var recY = 9;
        var recW = 20;
        var recH = 9;

        dc.setColor(COLOR_WHITE, COLOR_CLEAR);
        dc.setPenWidth(1);

        if (Store.getValue("ShowBattery") == 1) {
            // Battery Text

            dc.drawText(66, 8, FONT_SMALL, Lang.format("$1$%", [batteryPercentage]), ALIGN_RIGHT);

            // Battery Icon

            dc.drawRectangle(recX, recY, recW, recH);
            for (var i = 0; i < recH; i++) {
                dc.drawLine(recX, recY + i, recX + ((recW)*batteryPercentage.toFloat() * 0.01), recY + i);
            }
            dc.drawLine(recX + recW + 1, recY + 2, recX + recW + 1, recY + recH - 2);
        }

        // Date
        var dateVar = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var dateString = null;
        if (Store.getValue("DateFormat") == 1) {
            dateString = dateVar.day_of_week + " " + dateVar.month + " " + dateVar.day;
        } else if (Store.getValue("DateFormat") == 2) {
            dateString = dateVar.day_of_week + " " + dateVar.day + " " + dateVar.month;
        } else if (Store.getValue("DateFormat") == 0) {
            dateString = null;
        }

        // Data Fields ////////////////////////////////////////////////////////////////////////////////////

        /*
        Data Field char assignments for future reference
        72  H  Heart Rate
        67  C  Calories
        83  S  Steps
        70  F  Floors Climbed
        85  U  Solar Intensity
        */

        if (Store.getValue("DataField1") == 72) {
            dataField1Value = Activity.getActivityInfo().currentHeartRate;
            dc.drawText(110, 80, Icons, 72.toChar(), ALIGN_LEFT);
        } else if (Store.getValue("DataField1") == 67) {
            dataField1Value = (ActivityMonitor.getInfo().calories / 1000.0).format("%.1f") + "k";
            dc.drawText(110, 80, Icons, 67.toChar(), ALIGN_LEFT);
        } else if (Store.getValue("DataField1") == 83) {
            dataField1Value = (ActivityMonitor.getInfo().steps / 1000.0).format("%.1f") + "k";
            dc.drawText(110, 80, Icons, 83.toChar(), ALIGN_LEFT);
        } else if (Store.getValue("DataField1") == 70) {
            dataField1Value = ActivityMonitor.getInfo().floorsClimbed;
            dc.drawText(110, 80, Icons, 70.toChar(), ALIGN_LEFT);
        } else {
            System.print("Error: No valid numbers returned");
        }

        if (Store.getValue("DataField2") == 72) {
            dataField2Value = Activity.getActivityInfo().currentHeartRate;
            dc.drawText(110, 100, Icons, 72.toChar(), ALIGN_LEFT);
        } else if (Store.getValue("DataField2") == 67) {
            dataField2Value = (ActivityMonitor.getInfo().calories / 1000.0).format("%.1f") + "k";
            dc.drawText(110, 100, Icons, 67.toChar(), ALIGN_LEFT);
        } else if (Store.getValue("DataField2") == 83) {
            dataField2Value = (ActivityMonitor.getInfo().steps / 1000.0).format("%.1f") + "k";
            dc.drawText(110, 100, Icons, 83.toChar(), ALIGN_LEFT);
        } else if (Store.getValue("DataField2") == 70) {
            dataField2Value = ActivityMonitor.getInfo().floorsClimbed;
            dc.drawText(110, 100, Icons, 70.toChar(), ALIGN_LEFT);
        } else {
            System.print("Error: No valid numbers returned");
        }

        if (Store.getValue("DataField3") == 72) {
            dataField3Value = Activity.getActivityInfo().currentHeartRate;
            dc.drawText(110, 120, Icons, 72.toChar(), ALIGN_LEFT);
        } else if (Store.getValue("DataField3") == 67) {
            dataField3Value = (ActivityMonitor.getInfo().calories / 1000.0).format("%.1f") + "k";
            dc.drawText(110, 120, Icons, 67.toChar(), ALIGN_LEFT);
        } else if (Store.getValue("DataField3") == 83) {
            dataField3Value = (ActivityMonitor.getInfo().steps / 1000.0).format("%.1f") + "k";
            dc.drawText(110, 120, Icons, 83.toChar(), ALIGN_LEFT);
        } else if (Store.getValue("DataField3") == 70) {
            dataField3Value = ActivityMonitor.getInfo().floorsClimbed;
            dc.drawText(110, 120, Icons, 70.toChar(), ALIGN_LEFT);
        } else {
            System.print("Error: No valid numbers returned");
        }

        // Draw text after
        if (dataField1Value != null) {
            dc.drawText(135, 81, FONT_DATA, dataField1Value, ALIGN_LEFT);
        }
        if (dataField3Value != null) {
            dc.drawText(135, 101, FONT_DATA, dataField2Value, ALIGN_LEFT);
        }
        if (dataField3Value != null) {
            dc.drawText(135, 121, FONT_DATA, dataField3Value, ALIGN_LEFT);
        }

        if (Store.getValue("SideBar") == 85) {

            if (System.getSystemStats().solarIntensity != null) {
                dataField4Value = System.getSystemStats().solarIntensity.toFloat();
            } else {
                dataField4Value = 1.0;
            }
        } else if(Store.getValue("SideBar") == 83){
            dataField4Value = ActivityMonitor.getInfo().steps.toFloat() / ActivityMonitor.getInfo().stepGoal.toFloat();
        } else if(Store.getValue("SideBar") == 70){
            dataField4Value = ActivityMonitor.getInfo().floorsClimbed.toFloat() / ActivityMonitor.getInfo().floorsClimbedGoal.toFloat();
        } else if(Store.getValue("SideBar") == 0){
            dataField4Value = 0;
        }

        if (dataField4Value > 1.0) {
            dataField4Value = 1.0;
        }

        if (dateString != null) {
            dc.drawText(88, 150, Graphics.FONT_XTINY, dateString, ALIGN_CENTER);
        }

        // Progress Bar drawing ///////////////////////////////////////////////////////////////////////////

        // Variables

        var barHeight = 150;
        var barWidth = 10;
        var barY = 15;
        var barX = 10;

        // Draw progress bar

        dc.setColor(COLOR_WHITE, COLOR_CLEAR);
        dc.fillRectangle(barX, barY, barWidth, barHeight);

        dc.setColor(COLOR_BLACK, COLOR_CLEAR);
        dc.fillRectangle(barX, barY, barWidth, (barHeight - (dataField4Value * barHeight)));

        // Icon
        // dc.setPenWidth(1);
        dc.setColor(COLOR_WHITE, COLOR_BLACK);
        if(Store.getValue("SideBar") != 0){
        dc.drawText(barX + 5, 87, Icons, Store.getValue("SideBar").toChar(), ALIGN_VCENTER);
        }
    }

    // reverse peekaboo

    function onHide() as Void { WatchUi.requestUpdate(); }

    // User looks at watch

    function onExitSleep() as Void {
        glance = true;
        WatchUi.requestUpdate();
    }

    // User looks away from watch

    function onEnterSleep() as Void {

        glance = false;
        WatchUi.requestUpdate();
    }

    function onSettingsChange() as Void { WatchUi.requestUpdate(); }
}
