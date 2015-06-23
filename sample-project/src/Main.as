package {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Main extends Sprite {

    private static var appsFlyer:AppsFlyerInterface;
    private const DEVELOPER_KEY:String = "6aBJD2XbkHGPcLfQQ64cxE"; //"TcFCTFC4BdMYAqmBaeqXSN";//
    private const APP_ID:String = "201420144";

    private const USER_ID:String = "orenorensdfasdfasdf";

    private var logField:TextField;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void {
        logField = new TextField();
        var tf:TextFormat = logField.defaultTextFormat;
        tf.size = int(stage.stageWidth / 42);
        tf.font = "Helvetica";
        tf.align = TextFormatAlign.CENTER;
        logField.setTextFormat(tf);

        logField.textColor = 0x000000;
        logField.selectable = false;
        logField.mouseEnabled = false;
        logField.width = stage.stageWidth - 20;
        logField.height = 400;
        logField.x = 10;
        logField.y = 100;
        addChild(logField);

        var b:Sprite = createButton("Test");
        b.addEventListener(MouseEvent.CLICK, onMouseClick);
        addChild(b);

        appsFlyer = new AppsFlyerInterface();
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_DATA_LOADED, onSuccess);
        appsFlyer.addEventListener(AppsFlyerEvent.CURRENT_ATTRIBUTION_DATA_LOADED, onSuccess);
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_FAILED, onSuccess);
        appsFlyer.addEventListener(AppsFlyerEvent.ATTRIBUTION_FAILURE, onSuccess);
        appsFlyer.addEventListener(AppsFlyerEvent.APP_OPEN_ATTRIBUTION, onSuccess);

        appsFlyer.setDeveloperKey(DEVELOPER_KEY, APP_ID); // first param is developer key and second (NA for Android)is Apple app id.
        logField.text += "ANE initialized! \nDeveloper key: " + DEVELOPER_KEY + "\nApple AppID: " + APP_ID;
        appsFlyer.sendTracking();
        logField.text += "\nsendTracking() called";
        appsFlyer.setAppUserId(USER_ID);
        logField.text += "\nApp user id set to: " + USER_ID;
        //appsFlyer.setExtension();
        logField.text += "\nAppsFlyer UID: " + appsFlyer.getAppsFlyerUID();
        appsFlyer.setCurrency("EUR");
        logField.text += "\nSet currency: 'EUR'";
    }

    public function createButton(label:String):Sprite {
        var s:Sprite = new Sprite();

        s.graphics.lineStyle(1, 0x0000FF);
        s.graphics.beginFill(0x222222, 1);
        s.graphics.drawRoundRect(0, 0, stage.stageWidth * 0.17, stage.stageHeight * 0.05, 7, 7);
        s.graphics.endFill();

        var t:TextField = new TextField();
        t.text = label;

        var tf:TextFormat = t.defaultTextFormat;
        tf.size = int(stage.stageWidth / 42);
        tf.font = "Helvetica";
        tf.align = TextFormatAlign.CENTER;
        t.setTextFormat(tf);

        t.textColor = 0xFFFFFF;
        t.selectable = false;
        t.mouseEnabled = false;
        t.width = s.width * 0.95;
        t.height = s.height;
        t.x = (s.width * 0.020);
        t.y = (s.height * 0.5) - (t.textHeight * 0.5);

        s.addChild(t);

        return s;
    }

    private function onMouseClick(event:MouseEvent):void {
            appsFlyer.setCollectAndroidID(true);
            appsFlyer.setCollectIMEI(true);

        sendNumeric();
        sendJSON();
        sendWithoutValue();
        getConversionData();
    }

    private function sendNumeric():void {
        var value:String = "90";
        var param:String = "zivjhgziv";
        appsFlyer.sendTrackingWithEvent(param, value);
        logField.text += "\n-- Call sendTrackingWithEvent: '" + param + "' with value '" + value + "' --";
    }

    private function sendJSON():void {
        var value:String = '{"af_price": 9.99, "af_content_type": "something", "af_content_id": "234234", "af_currency": "USD", "af_quantity": "1"}';
        var param:String = 'af_add_to_cart';
        if(appsFlyer && appsFlyer.sendTrackingWithEvent && param && value) {
            appsFlyer.sendTrackingWithEvent(param, value);
        }
        logField.text += "\n-- Call sendTrackingWithEvent: '" + param + "' with value '" + value + "' --";
    }

    private function sendWithoutValue():void {
        appsFlyer.sendTrackingWithEvent("InstallOren", "");
        logField.text += "\n-- Call sendTrackingWithEvent: 'InstallOren' with value '' --";
    }

    private function getConversionData():void {
        appsFlyer.getConversionData();
        logField.text += "\n-- Call getConversionData --";
    }

    private function onSuccess(event:AppsFlyerEvent):void {
        logField.text += "\n-- Event: " + event.type + "; \nData: " + event.data + " \n";
    }
}
}
