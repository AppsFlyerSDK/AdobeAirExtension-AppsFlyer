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

	public function start(key:String, appId:String):void {
		context.call("start", key, appId);
	}

	public function stop(shouldStop:Boolean):void {
		context.call("stop", shouldStop);
	}

	public function isStopped():Boolean {
		return context.call("isStopped") as Boolean;
	}

	public function setUserEmails(emails:Array):void {
		context.call("setUserEmails", emails);
	}

	public function performOnAppAttribution(uri:String):void {
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

	public function registerConversionListener():void {
		context.addEventListener(StatusEvent.STATUS, _handleStatusEvents);
		context.call("registerConversionListener");
	}

	public function logEvent(eventName:String, json:String):void {
		context.call("logEvent", eventName, json);
	}

	public function validateAndLogInAppPurchase(publicKey:String, signature:String, purchaseData:String, price:String,
												currency:String, additionalParameters:String):void {
		context.call("validateAndLogInAppPurchase", publicKey, signature, purchaseData, price, currency, additionalParameters);
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

	public function startWithCUID(value:String):void {
		context.call("startWithCUID", value);
	}

	public function registerUninstall(deviceToken:String):void {
		context.call("registerUninstall", deviceToken.replace(/[ <>]/g, ""));
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

	public function setDebug(value:Boolean):void {
		context.call("setDebug", value);
	}

	public function handlePushNotification(userInfo:String):void {
		context.call("handlePushNotification", userInfo);
	}


	public function waitForATTUserAuthorization(timeout:int):void {
		if (TARGET::STRICT) {
		} else {
			context.call("waitForATTUserAuthorization", timeout);
		}
	}

//	public function requestATTPermission():void{
//		context.call("requestATTPermission");
//	}

	protected function _handleStatusEvents(e:StatusEvent):void {
		var event:AppsFlyerEvent = new AppsFlyerEvent(e.code, e.level);
		if (event != null) {
			this.dispatchEvent(event);
		}
	}
}
}
