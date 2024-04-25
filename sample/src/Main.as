package {

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import com.appsflyer.adobeair.*;

public class Main extends Sprite {
    private static var appsFlyer: AppsFlyerInterface;
    appsFlyer = new AppsFlyerInterface();

    public function Main() {
        var textField:TextField = new TextField();
        textField.width = 1000;
        textField.text = "Hello, World";
        addChild(textField);

        ButtonInteractivity()

        trace("Main constructor")
        appsFlyer.setDebug(true);
        appsFlyer.setCurrency("GBP")
//        appsFlyer.disableSKAdNetwork(true)
        // Registering Conversion Listener
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_DATA_LOADED, eventHandler); // GCD success
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_FAILED, eventHandler); // GCD error
        appsFlyer.addEventListener(AppsFlyerEvent.ATTRIBUTION_FAILURE, eventHandler); // OAOA error
        appsFlyer.addEventListener(AppsFlyerEvent.APP_OPEN_ATTRIBUTION, eventHandler);  // OAOA success
        appsFlyer.registerConversionListener();
//        appsFlyer.setDisableAdvertisingIdentifiers(true)

        appsFlyer.waitForATTUserAuthorization(10);
        // requestATTPermission for IDFA collection HERE

        // onDeepLinking
//        appsFlyer.addEventListener(AppsFlyerEvent.ON_DEEP_LINKING, eventHandler);
//        appsFlyer.subscribeForDeepLink();

        appsFlyer.setSharingFilterForPartners(["google_int", "facebook_int"]);
        appsFlyer.setOneLinkCustomDomain(["click.af-sup.com"]);
        appsFlyer.setResolveDeepLinkURLs(["5a5b39e8a8df.ngrok.io"]);
        appsFlyer.init("4UGrDF4vFvPLbHq5bXtCza", "753258300");
        appsFlyer.start("4UGrDF4vFvPLbHq5bXtCza", "753258300");
        // Test 1
        appsFlyer.enableTCFDataCollection(true);
        // Test 2
        appsFlyer.setConsentForNonGDPRUser();
        // Test 3
        appsFlyer.setConsentForGDPRUser(true, true);
        function eventHandler(event:AppsFlyerEvent):void {
            log("AppsFlyer event: " + event.type + "; \nData: " + event.data);
            textField.text = "AppsFlyer event: " + event.type + "; \nData: " + event.data + "\n";
            addChild(textField)
        }

        function log(s:String):void {
            trace("AppsFlyer" + s);
        }

        // Adnroid only
        var publicKey:String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA3dkBTr2pD2YSqSK2ewlEWwH9Llu0iA4PkwgVOyNRxOsHfrOlqi0Cm51qdNS0aqh/SMZkuQTAroqH3pAr9gVFOiejKRw+ymTaL5wB9+5n1mAbdeO2tv2FDsbawDvp7u6fIBejYt7Dtmih+kcu707fEO58HZWqgzx9qSHmrkMZr6yvHCtAhdBLwSBBjyhPHy7RAwKA+PE+HYVV2UNb5urqIZ9eI1dAv3RHX/xxHVHRJcjnTyMAqBmfFM+o31tp8/1CxGIazVN6HpVk8Qi2uqSS5HdKUu6VnIK8VuAHQbXQn4bG6GXx5Tp0SX1fKrejo7hupNUCgOlqsYHFYxsRkEOi0QIDAQAB";
        var signature:String = "JeUD4BWZxMKRsNP5dtblYb/TnvKILUzTZyy60DD9uQJCeJgXeHR4SnjGZtWzn0kVG4jvqPWgd56PI33Dcn4sF/ppAZ03ctQMg5LKxWhAuv4j4lqwVPA4wRJ83VTT2qN58jDOtmtN63nuR/gj4SjBeiXtwgn4E9xjtC1UOKPrfIol3XXgvdj8v+EAIF1daPORAP3tIf/hxRUfUUQkC6dkKM3GIg3eOhJERVVpqU1qHoTRIZjnK1IhOwQ5BlJ/SEOgamQEwGCsxpI5OV0IOU23xNsaKroyJE3/Xj3Cw0nzxpldqIcsJ2D3U4gV9i3GIiisBjg6HaX4gv/zW83rFRa3BA==";
        var purchaseData:String = "{\"transactionReceipt\":\"GPA.3348-2388-4716-44022\",\"purchaseState\":0,\"purchaseTimeMillis\":1590514197336,\"consumptionState\":1,\"quantity\":1,\"signature\":\"JeUD4BWZxMKRsNP5dtblYb/TnvKILUzTZyy60DD9uQJCeJgXeHR4SnjGZtWzn0kVG4jvqPWgd56PI33Dcn4sF/ppAZ03ctQMg5LKxWhAuv4j4lqwVPA4wRJ83VTT2qN58jDOtmtN63nuR/gj4SjBeiXtwgn4E9xjtC1UOKPrfIol3XXgvdj8v+EAIF1daPORAP3tIf/hxRUfUUQkC6dkKM3GIg3eOhJERVVpqU1qHoTRIZjnK1IhOwQ5BlJ/SEOgamQEwGCsxpI5OV0IOU23xNsaKroyJE3/Xj3Cw0nzxpldqIcsJ2D3U4gV9i3GIiisBjg6HaX4gv/zW83rFRa3BA==\",\"errorCode\":\"\",\"productId\":\"com.belkatechnologies.fe.product.fe_gems_for_100_2\",\"kind\":\"androidpublisher#productPurchase\",\"transactionDate\":\"Tue May 26 20:29:57 GMT+0300 2020\",\"orderId\":\"GPA.3348-2388-4716-44022\",\"error\":\"\",\"transactionTimestamp\":1590514197336,\"acknowledgementState\":1,\"transactionId\":\"mmimekodacjaejogdedalpdh.AO-J1OzezYDw7V6Z00WcFj7FD-bHCw3KVNssso9ewghrowH-vqW7Jq75lVq2h2N8kB7EgY6utmFbKJPyhuTR-FcgHjcAwB7J1IOK-2fT3QAJMbzvMaIz7zuknlWIwkNYDe0qDwMPpvPIgavJBjKUU6eunc4yZw3whA_c-OVDTt_uVU7Kb3cRklU\",\"transactionState\":\"transaction:purchased\"}";
        var price:String = "4";
        var currency:String = "USD";
        var additionalParameters:Object = {
            key1: "val1",
            key2: "val2"
        };
        appsFlyer.validateAndLogInAppPurchase(publicKey, signature, purchaseData, price, currency, JSON.stringify(additionalParameters));
    }

    private var button:Sprite = new Sprite();

    public function ButtonInteractivity():void {
        drawButton()
        button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        addChild(button);
    }

    private function drawButton():void {
        var textLabel:TextField = new TextField()
        button.graphics.clear();
        button.graphics.beginFill(0xD4D4D4); // grey color
        button.graphics.drawRoundRect(100, 100, 80, 25, 10, 10); // x, y, width, height, ellipseW, ellipseH
        button.graphics.endFill();

        textLabel.text = "Log event";
        textLabel.x = 100
        textLabel.y = 100
        textLabel.width = 70;
        textLabel.height = 20;
        textLabel.selectable = false;
        button.addChild(textLabel)
    }

    private function mouseDownHandler(event:MouseEvent):void {
        var param:String = "af_purchase";
        var value:Object = {
            "af_content_id": "123",
            "af_revenue": "20",
            "af_currency": "GBP"
        };
        appsFlyer.logEvent("af_add_to_cart", JSON.stringify(value))
        appsFlyer.logEvent(param, JSON.stringify(value))
    }


}
}