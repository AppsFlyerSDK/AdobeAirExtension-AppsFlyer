package com.appsflyer.adobeair
{
	import flash.events.EventDispatcher;

	import flash.external.ExtensionContext;

	
	
	public class TrackingSDK extends EventDispatcher
	{
		
		//----------------------------------------
		//
		// Variables
		//
		//----------------------------------------
		
		private static var _instance:TrackingSDK;
		private var extContext:flash.external.ExtensionContext;
		
		
		
		//----------------------------------------
		//
		// Public Methods
		//
		//----------------------------------------
		
		public static function get instance():TrackingSDK {
			if ( !_instance ) {
				_instance = new TrackingSDK( new SingletonEnforcer() );
			}
			return _instance;
		}
		
		/**
		 * Sets the AppsFlyer developer key
		 *  
		 * @param newVolume The new system volume.  This value should be between 0 and 1.
		 */		
		public function setDeveloperKey(developmentKey:String ):void 
		{
			extContext.call( "setDeveloperKey", developmentKey);
		}

		
		public function sendTracking():void 
		{
			extContext.call( "sendTracking", null);
		}

		
		
		
		
		/**
		 * Cleans up the instance of the native extension. 
		 */		
		public function dispose():void { 
			extContext.dispose(); 
		}
		
		
		
		
		
		//----------------------------------------
		//
		// Constructor
		//
		//----------------------------------------
		
		/**
		 * Constructor. 
		 */	
		
		public function TrackingSDK(enforcer:SingletonEnforcer)
		{
			super();
			extContext = ExtensionContext.createExtensionContext("com.appsfyer.adobeair", "" );
			if ( !extContext ) {
				throw new Error( "AppsFlyer Tracking is not supported on this platform" );
			}
		}
		
	}
}

class SingletonEnforcer {
	
}






		