package {
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

public class AppsFlyerInterface extends EventDispatcher {

	private static var context:ExtensionContext;

	public function AppsFlyerInterface() {
		if (!context) {
			try {
				context = ExtensionContext.createExtensionContext("com.appsflyer.adobeair", null);
			} catch (e:ArgumentError) {
				trace("AppsFlyerInterface error: " + e.message);
			}
		}
	}

	private const EXTENSION_TYPE:String = "AIR";

	public function init(key:String, appId:String):void {
	    context.call("init", key, appId);
	}

	public function startTracking(key:String, appId:String):void {
	    context.call("startTracking", key, appId);
	}

	public function stopTracking(isTrackingStopped:Boolean):void {
	    context.call("stopTracking", isTrackingStopped);
	}

	public function isTrackingStopped():Boolean {
	    return context.call("isTrackingStopped") as Boolean;
	}

	public function setUserEmails(emails:Array):void {
	    context.call("setUserEmails", emails);
	}

	public function performOnAppAttribution(uri:String): void {
        context.call("performOnAppAttribution", uri);
    }

    public function setSharingFilter(filters:Array):void {
        context.call("setSharingFilter", filters);
    }

    public function setSharingFilterForAllPartners():void {
    }

	public function setResolveDeepLinkURLs(urls:Array):void {
	    context.call("setResolveDeepLinkURLs", urls);
	}

	public function setOneLinkCustomDomain(domains:Array):void {
	    context.call("setOneLinkCustomDomain", domains);
    }

	public function trackAppLaunch():void {
	    context.call("trackAppLaunch");
	}

	public function registerConversionListener():void {
	    context.addEventListener(StatusEvent.STATUS, _handleStatusEvents);
    	    context.call("registerConversionListener");
	}

	public function trackEvent(eventName:String, json:String):void {
	    context.call("trackEvent", eventName, json);
	}

	public function validateAndTrackInAppPurchase(publicKey:String, signature:String, purchaseData:String, price:String,
                                                      currency:String, additionalParameters:String):void {
    	    context.call("validateAndTrackInAppPurchase", publicKey, signature, purchaseData, price, currency, additionalParameters);
	}

	public function useReceiptValidationSandbox(value:Boolean):void {
	    context.call("useReceiptValidationSandbox", value);
	}

	public function registerValidatorListener():void {
	    context.addEventListener(StatusEvent.STATUS, _handleStatusEvents);
	    context.call("registerValidatorListener");
	}

	public function setCurrency(currency:String):void {
	    context.call("setCurrency", currency);
	}

    [Deprecated(replacement="setCustomerUserId")]
	public function setAppUserId(appUserId:String):void {
	    context.call("setCustomerUserId", appUserId);
	}

	public function setCustomerUserId(customerUserId:String):void {
	    context.call("setCustomerUserId", customerUserId);
	}

	public function waitForCustomerUserID(value:Boolean):void {
    	    context.call("waitForCustomerUserID", value);
	}

	public function setCustomerIdAndTrack(value:String):void {
             context.call("setCustomerIdAndTrack", value);
   	}

	public function registerUninstall(deviceToken:String):void {
            context.call("registerUninstall", deviceToken.replace(/[ <>]/g, ""));
   	}

	[Deprecated(replacement="registerConversionListener")]
	public function getConversionData():void {
		context.addEventListener(StatusEvent.STATUS, _handleStatusEvents);
		context.call("getConversionData");
	}

	public function setCollectAndroidID(collect:Boolean):void {
		context.call("setCollectAndroidID", collect);
	}

	public function setAndroidIdData(androidId:String):void {
		context.call("setAndroidIdData", androidId);
	}

	public function setCollectIMEI(collect:Boolean):void {
		context.call("setCollectIMEI", collect);
	}

	public function setImeiData(imei:String):void {
	    context.call("setImeiData", imei);
	}

	public function getAppsFlyerUID():String {
	    return context.call("getAppsFlyerUID") as String;
	}

	public function setDebug(value:Boolean):void{
	    context.call("setDebug", value);
	}

	public function handlePushNotification(userInfo:String):void{
    	    context.call("handlePushNotification", userInfo);
	}

    [Deprecated]
	public function sendDeepLinkData():void {
	    context.call("sendDeepLinkData");
	}

	protected function _handleStatusEvents(e:StatusEvent):void {
	    var event:AppsFlyerEvent = new AppsFlyerEvent(e.code, e.level);
	    if (event != null) {
		this.dispatchEvent(event);
	    }
	}
    }
}
