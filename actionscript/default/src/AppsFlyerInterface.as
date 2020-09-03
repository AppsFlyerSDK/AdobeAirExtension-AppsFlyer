package {
import flash.events.EventDispatcher;

//	import flash.external.ExtensionContext;

public class AppsFlyerInterface extends EventDispatcher {

    public function AppsFlyerInterface() {
    }

    public function init(key:String, appId:String):void {
    }

    public function start(key:String, appId:String):void {
    }

    public function stop(shouldStop:Boolean):void {
    }

    public function isStopped():Boolean {
        return false;
    }

    public function setUserEmails(emails:Array):void {
    }

    public function setResolveDeepLinkURLs(urls:Array):void {
    }

    public function setSharingFilter(filters:Array):void {
    }

    public function setSharingFilterForAllPartners():void {
    }

    public function performOnAppAttribution(uri:String): void {
    }

    public function setOneLinkCustomDomain(domains:Array):void {
    }

    public function registerConversionListener():void {
    }

    public function registerUninstall(deviceToken:String):void {
    }

    public function logEvent(eventName:String, json:String):void {
    }

    public function setCurrency(currency:String):void {
    }

    [Deprecated(replacement="setCustomerUserId")]
    public function setAppUserId(appUserId:String):void {
    }

    public function setCustomerUserId(appUserId:String):void {
	}

	public function waitForCustomerUserID(value:Boolean):void {
    }

    public function startWithCUID(value:String):void {
    }

    public function setImeiData(imei:String):void {
    }

	public function setAndroidIdData(androidId:String):void {
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

	public function handlePushNotification(userInfo:String):void{
    }

    public function validateAndLogInAppPurchase(publicKey:String, signature:String, purchaseData:String, price:String,
                                                currency:String, additionalParameters:String):void {
    }

    public function useReceiptValidationSandbox(value:Boolean):void {
    }


    public function registerValidatorListener():void {
    }

    public function waitForAdvertisingIdentifier():void {
    }

//    public function requestATTPermission():void{
//    }

}
}
