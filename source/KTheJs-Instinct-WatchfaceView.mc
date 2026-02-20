import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;


class DataElement{
    protected var elementView;
    public var elementString;
    protected var layoutId;

    public function initialize(vView, vString, vLayoutId as String){
        
        elementString = vString;
        elementView = vView.findDrawableById(vLayoutId);
        
    }
    public function render(vDc){
       
        elementView.setText(elementString);
        elementView.draw(vDc);
    }
    public function updateString(vData, vDc){
        elementString = vData;
        elementView.setText(elementString);
        
    }
   
        

}


class KTheJs_Instinct_WatchfaceView extends WatchUi.WatchFace {
    public var clock_element;
    public var clockTime;
    public var seconds;
    public var hr_element;
    public var currentHeartRate;
    public var glance = true;
    public var hours;
    function initialize() {
        WatchFace.initialize();
    }


    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
        
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        clockTime = System.getClockTime();
        clock_element = new DataElement(self,
            Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]),
            "TimeLabel"
             );
        

        
    }
    
    // Update the view
    function onUpdate(dc as Dc) as Void {
        
        var is24Hour = System.getDeviceSettings().is24Hour;
        
        // Current Time
        clockTime = System.getClockTime();
        //Check for 12/24hr time
        if (!is24Hour){
            hours = clockTime.hour % 12;
            if(hours == 0){
                hours = 12;
            }
        }

        
        clock_element.updateString(Lang.format("$1$:$2$", [hours, clockTime.min.format("%02d")]),dc);
        
        dc.clear();
        View.onUpdate(dc);
       
     

        var sub_screen_x = WatchUi.getSubscreen().x;
        var sub_screen_y = WatchUi.getSubscreen().y;
        var sub_screen_width = WatchUi.getSubscreen().width;
        var sub_screen_height = WatchUi.getSubscreen().height;
        var sub_screen_middle_x = sub_screen_x + (sub_screen_width/2);
        var sub_screen_middle_y = sub_screen_y + (sub_screen_height/2);
        var integer_seconds = System.getClockTime().sec as Integer;
        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(sub_screen_middle_x,sub_screen_middle_y,sub_screen_width/2);
        dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < 7; i++){dc.drawArc(sub_screen_middle_x,sub_screen_middle_y + 1,sub_screen_height/2 - i + 1,Graphics.ARC_COUNTER_CLOCKWISE,90,-integer_seconds*6 + 90);}
        
        

        //SubScreen graphics
        if (glance == true){
        var seconds = System.getClockTime().sec;
        dc.drawText(sub_screen_middle_x, sub_screen_middle_y,Graphics.FONT_NUMBER_HOT,seconds,Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        

        
        
        

        // Call the parent onUpdate function to redraw the layout
        
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
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

}
