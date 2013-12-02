AdobeAirExtension-AppsFlyer
===========================

##Adobe Air Extension for AppsFlyer

This project provides support for Adobe Air Extension.

##Installation

###Android
Add the ane file (located under ScriptsAndBuild folder) into your project.

follow the instructions about permissions and receiver as described here:
http://support.appsflyer.com/attachments/token/97dg7dz6jpnctc9/?name=AF-iOS-Integration-Guide-v2.5.1.9.8.pdf

import the AppsFlyer Extension into your project

			import com.appsflyer.adobeair.TrackingSDK;
			
construct the AppsFlyer

			var trackingSdk:TrackingSDK = new TrackingSDK();
			
			
set the developer key by calling the function:

			trackingSdk.setDeveloperKey("asdfasdfasdfas");
			
add a call for tracking whenever the app is launched

			trackingSdk.sendTracking();
			
			

###IOS
Coming soon...


