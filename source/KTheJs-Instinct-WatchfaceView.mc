import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class DataElement{
    protected var elementView;
    protected var elementString;
    protected var layoutId;

    public function initialize(vView, vString, vLayoutId as String){
        
        elementString = vString;
        elementView = vView.findDrawableById(vLayoutId);
    }
    public function render(vDc){
        elementView.setText(elementString);
        elementView.draw(vDc);
    }

}


class KTheJs_Instinct_WatchfaceView extends WatchUi.WatchFace {

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
        
    }
    
    // Update the view
    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        // Current Time

        var clockTime = System.getClockTime();
        var clock_element = new DataElement(self,
            Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]),
            "TimeLabel"
             );
        clock_element.render(dc);
        
        //Heart Rate

        var currentHeartRate = Activity.getActivityInfo().currentHeartRate;
        var hr_element = new DataElement(
            self,
            Lang.format("$1$", [currentHeartRate]),
            "HeartRateLabel"
        );
        
       if (currentHeartRate != null){
        hr_element.render(dc);
       }

        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(144,32,30);
        dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_TRANSPARENT);
        

        var seconds = System.getClockTime().sec;
        var sec_element = new DataElement(
            self,
            Lang.format("$1$",[seconds]),
            "SecondsLabel"

        );

        sec_element.render(dc);
        
        //Testing Graphics Drawing
        

        
        
        

        // Call the parent onUpdate function to redraw the layout
        
        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
