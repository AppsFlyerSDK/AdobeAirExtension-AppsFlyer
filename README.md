AdobeAirExtension-AppsFlyer
===========================


This project provides support for Adobe Air Extension. 
please follow the steps for both IOS and Android.

##Installation (common both for IOS and Android)

Download the appsflyer.ane file from the ANE folder.

Add the ANE to your project and make sure the ide is marked to package it.

If the following was not added automatically please add it to the APP_NAME-app.xml:

			<extensions>
        			<extensionID>com.appsflyer.adobeair</extensionID>
    			</extensions>

Note: On AppsFlyer's dashboard you will need to add "air." prefix to the package name as this is added automatically by Air. For the above exmaple the app id on AppsFlyer's dashboard should be "air.com.appsflyer.adobeair"


import the AppsFlyer Extension into your project

			import AppsFlyerInterface;
			
construct the AppsFlyer

			var afInterface:AppsFlyerInterface = new AppsFlyerInterface();
			
			
set the developer key by calling the function:

Android

			afInterface.setDeveloperKey("your_developer_key_here",null);
			
iOS
			
			afInterface.setDeveloperKey("your_developer_key_here","your_apple_id_here");// second paramter is just for IOS
			
add a call for tracking whenever the app is launched
			
			
			
			afInterface.sendTracking();
			
add a call for tracking in-app events when desired

			afInterface.sendTrackingWithEvent("purchase","90.0"); // purchase is the event name, 90 is the value
			
get conversion data (attribution info)			

			afInterface.getConversionData(); // calls async function to get the conversion data
			
			afInterface.addEventListener(AppsFlyerEvent.SUCCESS,function(e){var text=e.data}); // e.data holds the string with the conversion data.
			
Setting your app's user (Optional)

			afInterface.setAppUserId("user_id_as_used_in_the_app"); (Optional) set your app's user id

Getting AppsFlyer's user id:

			appsFlyerID = afInterface.getAppsFlyerUID();
                        
###Android Notes

follow the instructions about permissions and receiver as described here:
http://support.appsflyer.com/entries/22801952?challenge=GxUdr14D3G5LHMqCvkRnp1FvC

####please note: the package name of the receiver is com.appsflyer.MultipleInstallBroadcastReceiver.
It's highly recommended to add Google Play services into your app so we can track Google Advertising ID. See http://developer.android.com/google/play-services/setup.html
