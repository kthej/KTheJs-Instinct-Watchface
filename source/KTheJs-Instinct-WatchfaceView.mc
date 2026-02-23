import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Activity;
import Toybox.ActivityMonitor;

class KTheJs_Instinct_WatchfaceView extends WatchUi.WatchFace {

// Main Variable Assignments //////////////////////////////////////////////////////////////////////
    
    // Main Clock variables
    
    public var hours_element;
    public var minutes_element;
    public var lastHourCheckVar = -1;
    

    // Fonts, all custom made :)

    public var FONT_HOURS;
    public var FONT_MINUTES;
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

    /*
    Data Field char assignments for future reference
    72  H  Heart Rate
    67  C  Calories
    83  S  Steps
    70  F  Floors Climbed
    85  U  Solar Intensity
    */
    



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

        FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font0);
        FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font0);
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

        if (!is24Hour) { //Check for 12/24hr time.
            hours = (clockTime.hour % 12).format("%02d");
            if (hours.toFloat() == 0) {
                hours = 12;
            }
        }
        

// Hour font loop /////////////////////////////////////////////////////////////////////////////////
// Checks for how much of day has passed and selects fill font accordingly

        if (clockTime.hour != lastHourCheckVar) {
            
            //Free resource from memory to be reassigned later

            FONT_HOURS = null; 
            FONT_MINUTES = null;

            if (clockTime.hour == 0 or clockTime.hour == 1) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font0);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font0);
            }
            else if (clockTime.hour == 2 or clockTime.hour == 3) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font0);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font1);
            }
            else if (clockTime.hour == 4 or clockTime.hour == 5) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font0);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font2);
            }
            else if (clockTime.hour == 6 or clockTime.hour == 7) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font0);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font3);
            }
            else if (clockTime.hour == 8 or clockTime.hour == 9) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font0);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font4);
            }
            else if (clockTime.hour == 10 or clockTime.hour == 11) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font0);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font5);
            }
            else if (clockTime.hour == 12 or clockTime.hour == 13) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font0);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font6);
            }
            else if (clockTime.hour == 14 or clockTime.hour == 15) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font1);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font6);
            }
            else if (clockTime.hour == 16 or clockTime.hour == 17) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font2);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font6);
            }
            else if (clockTime.hour == 18 or clockTime.hour == 19) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font3);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font6);
            }
            else if (clockTime.hour == 20 or clockTime.hour == 21) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font4);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font6);
            } 
            else if (clockTime.hour == 22) {
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font5);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font6);
            }
            
            // I wanted to have the font be fully filled at somepoint, so the last hour is filled fully

             else if (clockTime.hour == 23) { 
                FONT_HOURS = WatchUi.loadResource(Rez.Fonts.Font6);
                FONT_MINUTES = WatchUi.loadResource(Rez.Fonts.Font6);
            }

            lastHourCheckVar = clockTime.hour;
        }

        // Draw Clock

        dc.setColor(COLOR_WHITE, COLOR_CLEAR);
        dc.drawText(65, 25, FONT_HOURS, hours, ALIGN_CENTER);
        dc.drawText(65, 90, FONT_MINUTES, minutes, ALIGN_CENTER);

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

        dc.fillCircle(
            sub_screen_middle_x,
            sub_screen_middle_y,
            circleRadius
        );

        // Seconds Arc
        
        dc.setColor(COLOR_WHITE, COLOR_CLEAR);
        dc.setPenWidth(arcThickness);

        if (integer_seconds != 0){
        dc.drawArc(
                sub_screen_middle_x,
                sub_screen_middle_y,
                sub_screen_height / 2 - arcThickness/2,
                Graphics.ARC_CLOCKWISE,
                90,
                -integer_seconds * 6 + 90
            );
        }
        
        // Seconds Text

        dc.setColor(COLOR_BLACK, COLOR_CLEAR);
    
        if (glance == true) {
            var seconds = clockTime.sec;
            dc.drawText(
                sub_screen_middle_x+1,
                sub_screen_middle_y,
                FONT_MEDIUM_FILLED,
                seconds,
                ALIGN_VCENTER
            );
        }

// Battery and battery icon ///////////////////////////////////////////////////////////////////////

    // Variables

    var batteryPercentage = System.getSystemStats().battery.format("%.0f");
    var recX = 70;
    var recY = 9;
    var recW = 20;
    var recH = 9;
    
    dc.setColor(COLOR_WHITE,COLOR_CLEAR);
    dc.setPenWidth(1);

    // Battery Text

    dc.drawText(66,8,FONT_SMALL,Lang.format("$1$%",[batteryPercentage]),ALIGN_RIGHT);
    
    // Battery Icon

    dc.drawRectangle(recX,recY,recW,recH);
    for (var i = 0; i < recH; i++){dc.drawLine(recX,recY+i,recX+((recW)*batteryPercentage.toFloat()*0.01),recY+i);}
    dc.drawLine(recX+recW+1,recY+2,recX+recW+1,recY+recH-2);

    
    
// Data Fields ////////////////////////////////////////////////////////////////////////////////////

    // Date

    var dateVar = Time.Gregorian.info(Time.now(),Time.FORMAT_LONG);
    var dateString = dateVar.day_of_week+" "+dateVar.month+" "+dateVar.day;

    var dataField1Value = Activity.getActivityInfo().currentHeartRate;
    var dataField2Value = (ActivityMonitor.getInfo().steps/1000.0).format("%.1f")+"k";
    var dataField3Value = ActivityMonitor.getInfo().floorsClimbed;
    var dataField4Value = System.getSystemStats().solarIntensity.toFloat();
    if (dataField4Value >100) { dataField4Value = 100; }

    // Bottom date text, will create custom font later

    dc.drawText(88,150, Graphics.FONT_XTINY,dateString,ALIGN_CENTER); 

    // Data Field Icons

    dc.drawText(110,80,Icons,72.toChar(),ALIGN_LEFT);
    dc.drawText(110,100,Icons,83.toChar(),ALIGN_LEFT);
    dc.drawText(110,120,Icons,70.toChar(),ALIGN_LEFT);

    if(dataField1Value != null){ dc.drawText(135,81,FONT_DATA,dataField1Value,ALIGN_LEFT);  }
    if(dataField3Value != null){ dc.drawText(135,101,FONT_DATA,dataField2Value,ALIGN_LEFT); }
    if(dataField3Value != null){ dc.drawText(135,121,FONT_DATA,dataField3Value,ALIGN_LEFT); }

// Progress Bar drawing ///////////////////////////////////////////////////////////////////////////
    
    // Variables

    var barHeight = 150;
    var barY = 15;
    var barX = 10;
    


    // Draw progress bar

    dc.setColor(COLOR_WHITE,COLOR_CLEAR);
    dc.fillRectangle(barX,barY,10,barHeight);

    dc.setColor(COLOR_BLACK,COLOR_CLEAR);
    dc.fillRectangle(barX,barY,10,(barHeight-(dataField4Value*barHeight/100)));

    // Icon
    // dc.setPenWidth(1);
    dc.setColor(COLOR_WHITE,COLOR_BLACK);
    dc.drawText(barX+5,87,Icons,85.toChar(),ALIGN_VCENTER);

    }

    // reverse peekaboo

    function onHide() as Void {
        WatchUi.requestUpdate();
    }

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

    function onSettingsChange() as Void {

        WatchUi.requestUpdate();

    }
}
