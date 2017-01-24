package {

import com.freshplanet.nativeExtensions.PushNotification;
import com.freshplanet.nativeExtensions.PushNotificationEvent;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.InvokeEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.setTimeout;


public class Main extends Sprite {

    private static const DEVELOPER_KEY:String = "2MUJ9GP6pVoMU4c76jqiuA";//"your_developer_key";
    private static const APP_ID:String = "201420144";//"your_app_id";
    private static const USER_ID:String = "orenorensdfasdfasdf";//"your_user_id";

    private static var appsFlyer:AppsFlyerInterface;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeHandler);
    }
    private var logField:TextField;

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

    private function log(s:String):void {
        logField.appendText("\n" + s);
        trace(s);
    }

    private function createUI():void {
        logField = new TextField();
        var tf:TextFormat = logField.defaultTextFormat;
        tf.size = int(stage.stageWidth / 60);
        tf.align = TextFormatAlign.CENTER;
        logField.setTextFormat(tf);
        logField.y = 80;

        logField.textColor = 0x000000;
        logField.selectable = false;
        logField.mouseEnabled = false;
        logField.width = stage.stageWidth - 20;
        logField.height = stage.stageHeight - 20;
        logField.x = 10;
        logField.y = 10;
        addChild(logField);

        var b:Sprite = createButton("Test");
        b.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            sendJSON();
//            appsFlyer.validateAndTrackInAppPurchase("1", "1", "", "100", "USD", "");
//            appsFlyer.validateAndTrackInAppPurchase("1", "1", "", "100", "USD", null);
//            setTimeout(function ():void {
//                log("AdvertiserId: " + appsFlyer.getAdvertiserId());
//                log("AdvertiserId enabled: " + appsFlyer.getAdvertiserIdEnabled());
//                appsFlyer.validateAndTrackInAppPurchase("1", "1", "", "100", "USD", '{"test": "val" , "test1" : "val1"}');
//            }, 1000)
        });
        addChild(b);
    }

    private function sendJSON():void {
        var param:String = "Deposit";
        var value:String = '{"amount":10, "FTDLevel":"-"}';
        appsFlyer.trackEvent(param, value);
        log("Call sendTrackingWithValues: '" + param + "' with value '" + value + "' --");
    }

    private function invokeHandler(event:InvokeEvent):void {
        log("invokeHandler " + event.reason + ". Arguments: " + event.arguments[0]);
        if (event.arguments && event.arguments.length) {
            for (var key:* in event.arguments[0]) {
                log("param " + key + ": " + event.arguments[0][key]);
            }
        }
    }

    private function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        appsFlyer = new AppsFlyerInterface();
        appsFlyer.registerConversionListener();
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_DATA_LOADED, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_FAILED, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.ATTRIBUTION_FAILURE, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.APP_OPEN_ATTRIBUTION, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.VALIDATE_IN_APP, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.VALIDATE_IN_APP_FAILURE, eventHandler);
        appsFlyer.setDebug(true);
        appsFlyer.setDeveloperKey(DEVELOPER_KEY, APP_ID); // first param is developer key and second (NA for Android)is Apple app id.
        appsFlyer.setGCMProjectNumber("11234");
        appsFlyer.setAppUserId(USER_ID);
        appsFlyer.setCurrency("EUR");
        appsFlyer.setCollectAndroidID(false);
        appsFlyer.setCollectIMEI(false);
        appsFlyer.setImeiData("11234");
        appsFlyer.setAndroidIdData("11234");
        appsFlyer.trackAppLaunch();
        appsFlyer.sendDeepLinkData();

        appsFlyer.registerValidatorListener();
        appsFlyer.useReceiptValidationSandbox(true);
        appsFlyer.validateAndTrackInAppPurchase("1", "1", "", "100", "USD", '{"test": "val" , "test1" : "val1"}');

        createUI();

        log("ANE initialized! \nDeveloper key: " + DEVELOPER_KEY + "\nApple AppID: " + APP_ID);
        log("App user id set to: " + USER_ID);
        log("AppsFlyer UID: " + appsFlyer.getAppsFlyerUID());

        PushNotification.getInstance().registerForPushNotification();
        PushNotification.getInstance().addEventListener(PushNotificationEvent.PERMISSION_GIVEN_WITH_TOKEN_EVENT, onPushNotificationToken);
        PushNotification.getInstance().addEventListener(PushNotificationEvent.NOTIFICATION_RECEIVED_WHEN_IN_FOREGROUND_EVENT, onNotificationHandler);
        PushNotification.getInstance().addEventListener(PushNotificationEvent.APP_BROUGHT_TO_FOREGROUND_FROM_NOTIFICATION_EVENT, onNotificationHandler);
        PushNotification.getInstance().addListenerForStarterNotifications(onNotificationHandler);
    }

    private function onPushNotificationToken(event:PushNotificationEvent):void {
        log("Notification token: " + event.token);
        appsFlyer.registerUninstall(event.token);
    }

    private function onNotificationHandler(event:PushNotificationEvent):void {
        log("Notification event: " + event.type + "; \nData: " + event.parameters + " \n");
    }

    private function eventHandler(event:AppsFlyerEvent):void {
        log("AppsFlyer event: " + event.type + "; \nData: " + event.data + " \n");
    }
}
}
