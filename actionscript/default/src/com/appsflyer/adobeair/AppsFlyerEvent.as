package com.appsflyer.adobeair {
	
import flash.events.Event;

public class AppsFlyerEvent extends Event {

	public static const INSTALL_CONVERSATION_DATA_LOADED:String = "installConversionDataLoaded";
	public static const INSTALL_CONVERSATION_FAILED:String = "installConversionFailure";
	public static const APP_OPEN_ATTRIBUTION:String = "appOpenAttribution";
	public static const ATTRIBUTION_FAILURE:String = "attributionFailure";
	public static const VALIDATE_IN_APP:String = "validateInApp";
	public static const VALIDATE_IN_APP_FAILURE:String = "validateInAppFailure";
//		public static const ON_DEEP_LINKING:String="onDeepLinking";

		public var data:String;
		
		public function AppsFlyerEvent(type:String,data:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}