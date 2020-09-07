package {

import flash.display.Sprite;
import flash.text.TextField;

public class Main extends Sprite {
    private static var appsFlyer:AppsFlyerInterface;
    appsFlyer = new AppsFlyerInterface();


    public function Main() {
        var textField:TextField = new TextField();
        textField.width = 1000;
        textField.text = "Hello, World";
        addChild(textField);

        trace("Main constructor")

        appsFlyer.setDebug(true);
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_DATA_LOADED, eventHandler); // GCD success
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_FAILED, eventHandler); // GCD error
        appsFlyer.addEventListener(AppsFlyerEvent.ATTRIBUTION_FAILURE, eventHandler); // OAOA error
        appsFlyer.addEventListener(AppsFlyerEvent.APP_OPEN_ATTRIBUTION, eventHandler);  // OAOA success

        appsFlyer.waitForATTUserAuthorization(10);
        //requestATTPermission for IDFA collection HERE
        appsFlyer.registerConversionListener();
        appsFlyer.setSharingFilter(["google_int", "facebook_int"]);
        appsFlyer.setOneLinkCustomDomain(["click.af-sup.com"]);
        appsFlyer.setResolveDeepLinkURLs(["5a5b39e8a8df.ngrok.io"]);
        appsFlyer.init("4UGrDF4vFvPLbHq5bXtCza", "753258300");
        appsFlyer.start("4UGrDF4vFvPLbHq5bXtCza", "753258300");

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


}
}
