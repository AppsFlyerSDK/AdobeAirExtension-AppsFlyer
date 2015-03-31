package 
{
	import flash.events.Event;
	
	public class AppsFlyerEvent extends Event
	{
		
		public static const INSTALL_CONVERSATION_DATA_LOADED:String="installConversionDataLoaded";
		public static const CURRENT_ATTRIBUTION_DATA_LOADED:String="currentAttributionDataLoaded";
		public static const INSTALL_CONVERSATION_FAILED:String="installConversionFailure";
		public static const APP_OPEN_ATTRIBUTION:String="appOpenAttribution";
		public static const ATTRIBUTION_FAILURE:String="attributionFailure";

		public var data:String;
		
		public function AppsFlyerEvent(type:String,data:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}