package {

import flash.display.Sprite;
import flash.text.TextField;

public class Main extends Sprite {
    private static var appsFlyer:AppsFlyerInterface;
    appsFlyer = new AppsFlyerInterface();


    public function Main() {
        var textField:TextField = new TextField();
        textField.width = 500;
        textField.text = "Hello, World";
        addChild(textField);

        trace("Main constructor")

        appsFlyer.setDebug(true);
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_DATA_LOADED, eventHandler); // GCD success
        appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_FAILED, eventHandler); // GCD error
        appsFlyer.addEventListener(AppsFlyerEvent.ATTRIBUTION_FAILURE, eventHandler); // OAOA error
        appsFlyer.addEventListener(AppsFlyerEvent.APP_OPEN_ATTRIBUTION, eventHandler);  // OAOA success

        appsFlyer.registerConversionListener();
        appsFlyer.setSharingFilter(["google_int", "facebook_int"]);
        appsFlyer.setOneLinkCustomDomain(["click.af-sup.com"]);
        appsFlyer.setResolveDeepLinkURLs(["5a5b39e8a8df.ngrok.io"]);
        appsFlyer.init("4UGrDF4vFvPLbHq5bXtCza", "753258300");
        appsFlyer.startTracking("4UGrDF4vFvPLbHq5bXtCza", "753258300");
        appsFlyer.trackEvent("testEvent", "{\"key1\":\"value1\"}");

        function eventHandler(event:AppsFlyerEvent):void {
            log("AppsFlyer event: " + event.type + "; \nData: " + event.data);
            textField.text = "AppsFlyer event: " + event.type + "; \nData: " + event.data + "\n";
            addChild(textField)
        }

        function log(s:String):void {
            trace("AppsFlyer" + s);
        }
    }


}
}
