import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
// import Toybox.Math;
import Toybox.Time;
import Toybox.Activity;
import Toybox.ActivityMonitor;

class KTheJs_Instinct_WatchfaceView extends WatchUi.WatchFace {
    public var hours_element;
    public var minutes_element;
    public var clockTime;
    public var hr_element;
    public var currentHeartRate;
    public var glance = true;
    public var hours;
    public var minutes;
    public var seconds;
    public var vFontHours;
    public var vFontMinutes;
    public var lastHourCheckVar = -1;
    public var SmallFont;
    public var MediumFontHollow;
    public var MediumFontFilled;
    public var Icons;
    public var DataFont;

    public var dataField1Value;
    public var dataField2Value;
    public var dataField3Value;
    public var dataField4Value;

    function initialize() {
        WatchFace.initialize();
        
        
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        vFontHours = WatchUi.loadResource(Rez.Fonts.Font0);
        vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font0);
        SmallFont = WatchUi.loadResource(Rez.Fonts.SmallFont);
        MediumFontFilled = WatchUi.loadResource(Rez.Fonts.MediumFontFilled);
        MediumFontHollow = WatchUi.loadResource(Rez.Fonts.MediumFontHollow);
        DataFont = WatchUi.loadResource(Rez.Fonts.DataFont);
        Icons = WatchUi.loadResource(Rez.Fonts.Icons);
        // var MediumFontFilled;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        
        View.onUpdate(dc);
        var is24Hour = System.getDeviceSettings().is24Hour;

        // Current Time

        clockTime = System.getClockTime();


        //Check for 12/24hr time
        if (!is24Hour) {
            hours = (clockTime.hour % 12).format("%02d");
            if (hours.toFloat() == 0) {
                hours = 12;
            }
        }
        minutes = clockTime.min.format("%02d");

        //Hours
        if (clockTime.hour != lastHourCheckVar) {
            vFontHours = null;
            vFontMinutes = null;

            if (clockTime.hour == 0 || clockTime.hour == 1) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font0);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font0);
            } else if (clockTime.hour == 2 || clockTime.hour == 3) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font0);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font1);
            } else if (clockTime.hour == 4 || clockTime.hour == 5) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font0);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font2);
            } else if (clockTime.hour == 6 || clockTime.hour == 7) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font0);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font3);
            } else if (clockTime.hour == 8 || clockTime.hour == 9) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font0);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font4);
            } else if (clockTime.hour == 10 || clockTime.hour == 11) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font0);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font5);
            } else if (clockTime.hour == 12 || clockTime.hour == 13) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font0);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font6);
            } else if (clockTime.hour == 14 || clockTime.hour == 15) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font1);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font6);
            } else if (clockTime.hour == 16 || clockTime.hour == 17) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font2);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font6);
            } else if (clockTime.hour == 18 || clockTime.hour == 19) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font3);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font6);
            } else if (clockTime.hour == 20 || clockTime.hour == 21) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font4);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font6);
            } else if (clockTime.hour == 22) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font5);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font6);
            }
             else if (clockTime.hour == 23) {
                vFontHours = WatchUi.loadResource(Rez.Fonts.Font6);
                vFontMinutes = WatchUi.loadResource(Rez.Fonts.Font6);
            }
            lastHourCheckVar = clockTime.hour;
        }

        //Draw Clock
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(65, 25, vFontHours, hours, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(65, 90, vFontMinutes, minutes, Graphics.TEXT_JUSTIFY_CENTER);

        //SubScreen Circle variables
        var sub_screen_x = WatchUi.getSubscreen().x;
        var sub_screen_y = WatchUi.getSubscreen().y;
        var sub_screen_width = WatchUi.getSubscreen().width;
        var sub_screen_height = WatchUi.getSubscreen().height;
        var sub_screen_middle_x = sub_screen_x + sub_screen_width / 2;
        var sub_screen_middle_y = sub_screen_y + sub_screen_height / 2;
        var integer_seconds = clockTime.sec as Integer;

        //White Circle
        var arcThickness = 12;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(
            sub_screen_middle_x,
            sub_screen_middle_y,
            sub_screen_width / 2 - arcThickness - 2
        );

        //Seconds Arc
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
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
        
        dc.setPenWidth(1);

        //Seconds Text
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        if (glance == true) {
            var seconds = clockTime.sec;
            dc.drawText(
                sub_screen_middle_x+1,
                sub_screen_middle_y,
                MediumFontFilled,
                seconds,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }

    //Battery
    dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
    var batteryPercentage = System.getSystemStats().battery.format("%.0f");
    // var batteryInDays = System.getSystemStats().batteryInDays.format("%.0f");
    
        
    var recX = 40;
    var recY = 9;
    var recW = 22;
    var recH = 9;
    
    dc.drawRectangle(recX,recY,recW,recH);
    
    for (var i = 0; i < recH; i++){dc.drawLine(recX,recY+i,recX+((recW)*batteryPercentage.toFloat()*0.01),recY+i);}
    dc.setPenWidth(1);
    dc.drawLine(recX+recW+1,recY+2,recX+recW+1,recY+recH-2);
    if(batteryPercentage.toFloat() != 100){
    dc.drawText(70,8,SmallFont,Lang.format("$1$%",[batteryPercentage]),Graphics.TEXT_JUSTIFY_LEFT);
    }
    else{
        dc.drawText(70,8,SmallFont,"100%",Graphics.TEXT_JUSTIFY_LEFT);
    }
    

    //Day of Week
    var dateVar = Time.Gregorian.info(Time.now(),Time.FORMAT_LONG);
    var dateString = dateVar.day_of_week+" "+dateVar.month+" "+dateVar.day;
    dc.drawText(88,150, Graphics.FONT_XTINY,dateString,Graphics.TEXT_JUSTIFY_CENTER);
    



    //Data Fields

    /*
    72  H  Heart Rate
    67  C  Calories
    83  S  Steps
    70  F  Floors Climbed
    85  U  Solar Intensity
    
    
    
    */

    //DATA FIELD 1

    // dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);

    // var settingDataField1 = Application.Properties.getValue("DataField1");
    
    // var settingDataField2 = Application.Properties.getValue("DataField2");
    // var settingDataField3 = Application.Properties.getValue("DataField3");
    // var settingDataField4 = Application.Properties.getValue("DataField4");
    // dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
    // dc.drawLine(102,70,102,155);
    
    
    dc.drawText(110,80,Icons,72.toChar(),Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(110,100,Icons,83.toChar(),Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(110,120,Icons,70.toChar(),Graphics.TEXT_JUSTIFY_LEFT);

    // dc.drawText(135,79,SmallFont,dataField2Value,Graphics.TEXT_JUSTIFY_LEFT);
    dataField1Value = Activity.getActivityInfo().currentHeartRate;
    dataField2Value = (ActivityMonitor.getInfo().steps/1000.0).format("%.1f")+"k";
    dataField3Value = ActivityMonitor.getInfo().floorsClimbed;
    dataField4Value = System.getSystemStats().solarIntensity.toFloat();
    if (dataField4Value >100){dataField4Value = 100;}
    if(dataField1Value != null){dc.drawText(135,81,DataFont,dataField1Value,Graphics.TEXT_JUSTIFY_LEFT);}
    dc.drawText(135,101,DataFont,dataField2Value,Graphics.TEXT_JUSTIFY_LEFT);
    if(dataField3Value != null){dc.drawText(135,121,DataFont,dataField3Value,Graphics.TEXT_JUSTIFY_LEFT);}
    // dc.setPenWidth(12);
    // dc.drawLine(11,50+(75-(dataField4Value*0.75)),11,125);
    dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(5,45,12,85);
    dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(5,45,12,(85-(dataField4Value*0.85)));
    dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
    dc.setPenWidth(1);
    dc.drawRectangle(0,135,20,40);
    dc.drawRectangle(0,10,20,30);
    // dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
    // dc.fillRectangle(4,75,10,20);
    dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_BLACK);
    dc.drawText(11,87,Icons,85.toChar(),Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

    
        
    // dc.drawText(100,140,Icons,settingDataField4.toChar(),Graphics.TEXT_JUSTIFY_LEFT);
    

    }



    function onHide() as Void {
        WatchUi.requestUpdate();
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        glance = true;
        WatchUi.requestUpdate();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        glance = false;
        WatchUi.requestUpdate();
    }

    function onSettingsChange() as Void {
        
        WatchUi.requestUpdate();

    }
}
