package {
import flash.events.EventDispatcher;

//	import flash.external.ExtensionContext;

public class AppsFlyerInterface extends  EventDispatcher {

	public function AppsFlyerInterface() {
	}


	public function setDeveloperKey(key:String, appId:String):void {
	}

	public function sendTracking():void {
	}

	public function sendTrackingWithEvent(eventName:String, eventValue:String):void {
	}

	public function sendTrackingWithValues(eventName:String, json:String):void {
	}

	public function setCurrency(currency:String):void {
	}

	public function setAppUserId(appUserId:String):void {
	}

	public function getConversionData():String {
		return "conversionData";
	}

	public function setCollectAndroidID(collect:Boolean):void {
	}

	public function setCollectIMEI(collect:Boolean):void {
	}

	public function getAppsFlyerUID():String {
		return "-1";
	}

//	public function setExtension():void {
//
//	}
}
}