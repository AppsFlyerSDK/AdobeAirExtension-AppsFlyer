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


###Android

follow the instructions about permissions and receiver as described here:
http://support.appsflyer.com/attachments/token/w51runonzngnrl4/?name=AF-Android-Integration-Guide-v1.3.19.pdf

import the AppsFlyer Extension into your project

			import AppsFlyerInterface;
			
construct the AppsFlyer

			var afInterface:AppsFlyerInterface = new AppsFlyerInterface();
			
			
set the developer key by calling the function:

			afInterface.setDeveloperKey("your_developer_key_here",null);// second paramter is just for IOS
			
add a call for tracking whenever the app is launched

			afInterface.sendTracking();
			
add a call for tracking in-app events when desired

			afInterface.sendTrackingWithEvent("purchase","90.0"); // purchase is the event name, 90 is the value
			
			

###IOS

import the AppsFlyer Extension into your project

			import AppsFlyerInterface;
			
construct the AppsFlyer

			var afInterface:AppsFlyerInterface = new AppsFlyerInterface();
			
			
set the developer key by calling the function:

			afInterface.setDeveloperKey("your_developer_key_here","your_apple_id_here");
			
add a call for tracking whenever the app is launched

			afInterface.sendTracking();
			
add a call for tracking in-app events when desired

			afInterface.sendTrackingWithEvent("purchase","90.0"); // purchase is the event name, 90 is the value


