package {

import com.freshplanet.ane.AirInAppPurchase.InAppPurchase;
import com.freshplanet.ane.AirInAppPurchase.InAppPurchaseEvent;
import com.freshplanet.ane.AirPushNotification.PushNotification;
import com.freshplanet.ane.AirPushNotification.PushNotificationEvent;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.InvokeEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;

public class Main extends Sprite {

    private static const DEVELOPER_KEY:String = "developer_key";
    private static const APP_ID:String = "app_id";
    private static const USER_ID:String = "user_id";
    private static const ANDROID_SENDER_ID:String = "sender_id";
    private static const PURCHASE_PRODUCT_ID:String = "product_id";


    private static var appsFlyer:AppsFlyerInterface;
    private static var _inAppPurchase:InAppPurchase;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, invokeHandler);
    }

    private function initAppsFlyer():void {
        appsFlyer = new AppsFlyerInterface();
        //appsFlyer.registerConversionListener();
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_DATA_LOADED, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_FAILED, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.ATTRIBUTION_FAILURE, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.APP_OPEN_ATTRIBUTION, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.VALIDATE_IN_APP, eventHandler);
        appsFlyer.addEventListener(AppsFlyerEvent.VALIDATE_IN_APP_FAILURE, eventHandler);

        appsFlyer.setDebug(true);
        appsFlyer.setAppUserId(USER_ID);

        appsFlyer.waitForCustomerUserID(true);
        appsFlyer.setCustomerIdAndTrack(USER_ID);

        init();

        log("App user id set to: " + USER_ID);
        log("AppsFlyer UID: " + appsFlyer.getAppsFlyerUID());

        appsFlyer.setUserEmails(["email1@mail.com", "email2@mail.com"]);

        appsFlyer.setCurrency("USD");
        appsFlyer.setCollectAndroidID(false);
        appsFlyer.setCollectIMEI(false);
        appsFlyer.setImeiData("11234");
        appsFlyer.setAndroidIdData("11234");
        appsFlyer.trackAppLaunch();

        appsFlyer.registerValidatorListener();
        appsFlyer.useReceiptValidationSandbox(true);

        appsFlyer.setResolveDeepLinkURLs(["url1.com", "url2.com"]);

        trackInAppPurchase(PURCHASE_PRODUCT_ID, 100, "USD");
    }

    private function init():void {
        logField.text = "";
        //appsFlyer.registerUninstall(androidSenderIdInput.text);
        appsFlyer.init(developerKeyInput.text, appIdInput.text); // first param is developer key and second (NA for Android)is Apple app id.
        log("ANE initialized! \nDeveloper key: " + developerKeyInput.text + "\nApple AppID: " + appIdInput.text);
    }

    private var logField:TextField;
    private var developerKeyInput:TextField;
    private var appIdInput:TextField;

    private function log(s:String):void {
        logField.appendText("\n" + s);
        trace(s);
    }

    private function createUI():void {
        logField = UIUtils.createTextField(new Rectangle(20, 120, stage.stageWidth - 40, stage.stageHeight - 100), false, int(stage.stageWidth / 60));
        logField.wordWrap = true;
        addChild(logField);

        developerKeyInput = createInput(new Rectangle(20, 20, 100, 20), "Developer Key");
        developerKeyInput.text = DEVELOPER_KEY;
        appIdInput = createInput(new Rectangle(140, 20, 100, 20), "Application ID (iOS)");
        appIdInput.text = APP_ID;
        var androidSenderIdInput:TextField = createInput(new Rectangle(260, 20, 100, 20), "Android sender ID");
        androidSenderIdInput.text = ANDROID_SENDER_ID;


        var size:Number = int(stage.stageWidth / 60);
        var updateButton:Sprite = UIUtils.createButton("Renew", size);
        updateButton.x = 380;
        updateButton.y = 20;
        updateButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            init();
        });
        addChild(updateButton);

        var sendEventButton:Sprite = UIUtils.createButton("Send tracking", size);
        sendEventButton.x = 380;
        sendEventButton.y = updateButton.y + updateButton.height + 10;
        sendEventButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            sendJSON();
        });
        addChild(sendEventButton);

        var makePurchaseButton:Sprite = UIUtils.createButton("Make purchase", size);
        makePurchaseButton.x = 380;
        makePurchaseButton.y = sendEventButton.y + sendEventButton.height + 10;
        makePurchaseButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            _inAppPurchase.makeSubscription(PURCHASE_PRODUCT_ID);
        });
        addChild(makePurchaseButton);

        var trachingButton:Sprite = UIUtils.createButton("Start/Stop tracking", size);
        trachingButton.x = 380;
        trachingButton.y = makePurchaseButton.y + makePurchaseButton.height + 10;
        trachingButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            appsFlyer.stopTracking(!appsFlyer.isTrackingStopped());
            log("AppsFlyer isTrackingStopped: " + appsFlyer.isTrackingStopped());
        });
        addChild(trachingButton);
    }

    public function createInput(dimensions:Rectangle, labelText:String):TextField {
        var size:Number = int(stage.stageWidth / 80);
        var label:TextField = UIUtils.createTextField(dimensions, false, size);
        label.text = labelText;
        addChild(label);
        var input:TextField = UIUtils.createTextField(new Rectangle(dimensions.x, label.y + label.height + 5, dimensions.width, dimensions.height), true, size);
        addChild(input);
        return input;
    }

    public static function trackInAppPurchase(product:String, revenue:Number, currency:String, verify:Boolean = true):void {
        if (verify) {
            var additionalParameters:Object = {
                key1: "val1",
                key2: "val2"
            };
            appsFlyer.validateAndTrackInAppPurchase(product, "1", "", revenue.toString(), currency, JSON.stringify(additionalParameters));
        } else {
            var param:String = "af_purchase";
            var value:Object = {
                "af_content_id": product,
                "af_revenue": revenue,
                "af_currency": currency
            };
            appsFlyer.logEvent(param, JSON.stringify(value));
        }
    }

    private function sendJSON():void {
        var param:String = "Deposit";
        var value:Object = {
            amount: 10,
            FTDLevel: "-"
        };
        appsFlyer.logEvent(param, JSON.stringify(value));
        log("Call sendTrackingWithValues: '" + param + "' with value '" + JSON.stringify(value));
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
        //initInAppPurchase();
        //_inAppPurchase.getProductsInfo([PURCHASE_PRODUCT_ID], null);

        PushNotification.instance().registerForPushNotification();
        PushNotification.instance().addEventListener(PushNotificationEvent.PERMISSION_GIVEN_WITH_TOKEN_EVENT, onPushNotificationToken);
        PushNotification.instance().addEventListener(PushNotificationEvent.NOTIFICATION_RECEIVED_WHEN_IN_FOREGROUND_EVENT, onNotificationHandler);
        PushNotification.instance().addEventListener(PushNotificationEvent.APP_BROUGHT_TO_FOREGROUND_FROM_NOTIFICATION_EVENT, onNotificationHandler);
        PushNotification.instance().addListenerForStarterNotifications(onNotificationHandler);
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
        log("onProductInfoRecieved " + event.data);
        //products = JSON.parse(event.data);
    }

    private function onPurchaseSuccess(event:InAppPurchaseEvent):void {
        log("onPurchaseSuccess " + event.data);
    }

    private function onPurchaseError(event:InAppPurchaseEvent):void {
        log("onPurchaseError " + event.data);
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
