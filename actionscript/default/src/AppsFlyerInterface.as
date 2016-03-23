package {
import flash.events.EventDispatcher;

//	import flash.external.ExtensionContext;

public class AppsFlyerInterface extends  EventDispatcher {

	public function AppsFlyerInterface() {
	}


	public function setDeveloperKey(key:String, appId:String):void {
	}

//	public function sendTracking():void {
//	}

	public function registerConversionListener():void {
    }

//	public function sendTrackingWithEvent(eventName:String, eventValue:String):void {
//	}

	public function trackAppLaunch():void {
    }

	public function trackEvent(eventName:String, json:String):void {
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

	public function setDebug(value:Boolean):void{

	}


	public function getAdvertiserId():String {
		return "-1";
	}

	public function getAdvertiserIdEnabled():Boolean {
		return false;
	}

	public function handlePushNotification(userInfo:String):void{

    }

//	public function setExtension():void {
//
//	}
}
}