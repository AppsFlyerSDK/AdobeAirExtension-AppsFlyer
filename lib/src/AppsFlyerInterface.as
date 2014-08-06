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

	public function setDeveloperKey(key:String, appId:String):void {
		context.call("setDeveloperKey", key, appId);
	}

	public function sendTracking():void {
		context.call("sendTracking");
	}

	public function sendTrackingWithEvent(eventName:String, eventValue:String):void {
		context.call("sendTrackingWithEvent", eventName, eventValue);
	}

	public function setCurrency(currency:String):void {
		context.call("setCurrency", currency);
	}

	public function setAppUserId(appUserId:String):void {
		context.call("setAppUserId", appUserId);
	}

	public function getConversionData():void {
		context.addEventListener(StatusEvent.STATUS, _handleStatusEvents);
		context.call("getConversionData");
	}

	public function setCollectAndroidID(collect:Boolean):void {
		context.call("setCollectAndroidID", collect);
	}

	public function setCollectIMEI(collect:Boolean):void {
		context.call("setCollectIMEI", collect);
	}

	public function getAppsFlyerUID():String {
		return context.call("getAppsFlyerUID") as String;
	}

	public function setExtension():void {
		context.call("setExtension", EXTENSION_TYPE);
	}

	protected function _handleStatusEvents(e:StatusEvent):void {
		var event:AppsFlyerEvent = new AppsFlyerEvent(e.code, e.level);
		if (event != null) {
			this.dispatchEvent(event);
		}
	}

}
}