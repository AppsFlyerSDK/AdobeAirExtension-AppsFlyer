package {

import com.freshplanet.ane.AirInAppPurchase.InAppPurchase;
import com.freshplanet.ane.AirInAppPurchase.InAppPurchaseEvent;
import com.freshplanet.nativeExtensions.PushNotification;
import com.freshplanet.nativeExtensions.PushNotificationEvent;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.InvokeEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;


public class Main extends Sprite {

    private static const DEVELOPER_KEY:String = "enter developer key";
    private static const APP_ID:String = "enter app id";
    private static const USER_ID:String = "enter user id";
    private static const ANDROID_SENDER_ID:String = "sender_id";
    private static const PURCHASE_PRODUCT_ID:String = "product_id";


    private static var appsFlyer:AppsFlyerInterface;
    private static var _inAppPurchase:InAppPurchase;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeHandler);
    }

    private function initAppsFlyer() : void {
        appsFlyer = new AppsFlyerInterface();
        appsFlyer.registerConversionListener();
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_DATA_LOADED, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_FAILED, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.ATTRIBUTION_FAILURE, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.APP_OPEN_ATTRIBUTION, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.VALIDATE_IN_APP, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.VALIDATE_IN_APP_FAILURE, eventHandler);
        appsFlyer.setDebug(true);

        refreshSettings();

        appsFlyer.setAppUserId(USER_ID);
        log("App user id set to: " + USER_ID);
        log("AppsFlyer UID: " + appsFlyer.getAppsFlyerUID());

        appsFlyer.setCurrency("EUR");
        appsFlyer.setCollectAndroidID(false);
        appsFlyer.setCollectIMEI(false);
        appsFlyer.setImeiData("11234");
        appsFlyer.setAndroidIdData("11234");
        appsFlyer.trackAppLaunch();
        appsFlyer.sendDeepLinkData();

        appsFlyer.registerValidatorListener();
        appsFlyer.useReceiptValidationSandbox(true);
        appsFlyer.validateAndTrackInAppPurchase(PURCHASE_PRODUCT_ID, "1", "", "100", "USD", '{"test": "val" , "test1" : "val1"}');
    }

    private function refreshSettings():void {
        logField.text = "";
        appsFlyer.registerUninstall(androidSenderIdInput.text);
        appsFlyer.setDeveloperKey(developerKeyInput.text, appIdInput.text); // first param is developer key and second (NA for Android)is Apple app id.
        log("ANE initialized! \nDeveloper key: " + developerKeyInput.text + "\nApple AppID: " + appIdInput.text);
    }

    private var logField:TextField;
    private var developerKeyInput:TextField;
    private var appIdInput:TextField;
    private var androidSenderIdInput:TextField;

    private function createButton(label:String):Sprite {
        var s:Sprite = new Sprite();
        s.graphics.lineStyle(1, 0x0000FF);
        s.graphics.beginFill(0x222222, 1);
        s.graphics.drawRoundRect(0, 0, 80, 30, 7, 7);
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
        logField = createTextField(new Rectangle(20, 120, stage.stageWidth - 40, stage.stageHeight - 100));
        addChild(logField);

        developerKeyInput = createInput(new Rectangle(20, 20, 100, 20), "Developer Key");
        developerKeyInput.text = DEVELOPER_KEY;
        appIdInput = createInput(new Rectangle(140, 20, 100, 20), "Application ID (iOS)");
        appIdInput.text = APP_ID;
        androidSenderIdInput = createInput(new Rectangle(260, 20, 100, 20), "Android sender ID");
        androidSenderIdInput.text = ANDROID_SENDER_ID;

        var updateButton:Sprite = createButton("Renew");
        updateButton.x = 380;
        updateButton.y = 20;
        updateButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            refreshSettings();
        });
        addChild(updateButton);

        var sendEventButton:Sprite = createButton("Send tracking");
        sendEventButton.x = 380;
        sendEventButton.y = updateButton.y + updateButton.height + 10;
        sendEventButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            sendJSON();
        });
        addChild(sendEventButton);

        var makePurchaseButton:Sprite = createButton("Make purchase");
        makePurchaseButton.x = 380;
        makePurchaseButton.y = sendEventButton.y + sendEventButton.height + 10;
        makePurchaseButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            _inAppPurchase.makeSubscription(PURCHASE_PRODUCT_ID);
        });
        addChild(makePurchaseButton);
    }

    private function createInput(dimensions:Rectangle, labelText:String):TextField {
        var label:TextField = createTextField(dimensions);
        label.text = labelText;
        addChild(label);
        var input:TextField = createTextField(new Rectangle(dimensions.x, label.y + label.height + 5, dimensions.width, dimensions.height), true);
        addChild(input);
        return input;
    }

    private function createTextField(dimensions:Rectangle, ediatble:Boolean = false):TextField {
        var field:TextField = new TextField();
        var tf:TextFormat = field.defaultTextFormat;
        tf.size = int(stage.stageWidth / 60);
        tf.align = TextFormatAlign.CENTER;
        field.setTextFormat(tf);
        field.textColor = 0x000000;
        field.type = ediatble ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
        field.selectable = ediatble;
        field.mouseEnabled = ediatble;

        field.x = dimensions.x;
        field.y = dimensions.y;
        field.width = dimensions.width;
        field.height = dimensions.height;

        return field;
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

        createUI();

        initAppsFlyer();

        initInAppPurchase();

        _inAppPurchase.getProductsInfo([PURCHASE_PRODUCT_ID], null);

        PushNotification.getInstance().registerForPushNotification();
        PushNotification.getInstance().addEventListener(PushNotificationEvent.PERMISSION_GIVEN_WITH_TOKEN_EVENT, onPushNotificationToken);
        PushNotification.getInstance().addEventListener(PushNotificationEvent.NOTIFICATION_RECEIVED_WHEN_IN_FOREGROUND_EVENT, onNotificationHandler);
        PushNotification.getInstance().addEventListener(PushNotificationEvent.APP_BROUGHT_TO_FOREGROUND_FROM_NOTIFICATION_EVENT, onNotificationHandler);
        PushNotification.getInstance().addListenerForStarterNotifications(onNotificationHandler);
    }

    private function initInAppPurchase():void {
        _inAppPurchase = InAppPurchase.instance;
        _inAppPurchase.init("", true);
        _inAppPurchase.addEventListener(InAppPurchaseEvent.PRODUCT_INFO_ERROR, onProductInfoError);
        _inAppPurchase.addEventListener(InAppPurchaseEvent.PRODUCT_INFO_RECEIVED, onProductInfoRecieved);
        _inAppPurchase.addEventListener(InAppPurchaseEvent.PURCHASE_SUCCESSFUL, onPurchaseSuccess);
        _inAppPurchase.addEventListener(InAppPurchaseEvent.PURCHASE_ERROR, onPurchaseError);
    }

    private function onProductInfoError(event:InAppPurchaseEvent):void {
        log("onProductInfoError " + event.data);
    }

    private function onProductInfoRecieved(event:InAppPurchaseEvent):void {
        log("onProductInfoRecieved " +  event.data);
        //products = JSON.parse(event.data);
    }

    private function onPurchaseSuccess(event:InAppPurchaseEvent):void {
        log("onPurchaseSuccess " + event.data);
    }

    private function onPurchaseError(event:InAppPurchaseEvent):void {
        log("onPurchaseError " +  event.data);
    }

    private function onPushNotificationToken(event:PushNotificationEvent):void {
        log("Notification token: " + event.token);
        appsFlyer.registerUninstall(event.token);
    }

    private function onNotificationHandler(event:PushNotificationEvent):void {
        log("Notification event: " + event.type + "; \nData: " + event.parameters + " \n");
    }

    private function eventHandler(event:AppsFlyerEvent):void {
        log("AppsFlyer event: " + event.type + "; \nData: " + event.data);
    }
}
}
