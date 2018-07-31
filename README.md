<img src="https://www.appsflyer.com/wp-content/uploads/2016/11/logo-1.svg"  width="200">

# AppsFlyer Adobe Air extension 


In order for us to provide optimal support, we would kindly ask you to submit any issues to support@appsflyer.com

*When submitting an issue please specify your AppsFlyer sign-up (account) email , your app ID , production steps, logs, code snippets and any additional relevant information.*

----------

## Table of content

- [Supported Platforms](#supported-platforms)
- [SDK versions](#plugin-build-for)
- [Installation](#installation)
- [Usage](#Usage)
- [Android: initialisation and session tracking](#android-init)
- [iOS: initialisation and session tracking](#ios-init)
- [API Methods](#api-methods)
- [Tracking In-App Events](#event-tracking)
- [Setting App User ID](#appUserId)
- [Setting App User Email](#appUserEmail)
- [Setting  Currency](#currency)
- [StopTracking (Opt-Out)](#opt)
- [In-App Purchase Validation](#iapp-validation)
- [Enable / Disable AppsFlyer Debug-Logs](#debugLogs)
- [Deep Linking](#dl)
- [Setting up Deep Links in Adobe Air applications](#dl-su)
- [Receiving Deep Link Callbacks](#dl-cb)
- [Deferred Deep Links (get Conversion Data)](#df)
- [IMEI And Android ID Collection  (Android Only)](#imei-id)
- [Changelog](#changelog)

## <a id="supported-platforms"> Supported Platforms

- Android
- iOS 6+

### <a id="plugin-build-for"> This plugin is built for

- iOS AppsFlyerSDK **v4.8.4**
- Android AppsFlyerSDK **v4.8.11**


## <a id="installation"> Installation
Download the [AppsFlyerAIRExtension.ane](https://github.com/AppsFlyerSDK/AdobeAirExtension-AppsFlyer/blob/master/bin/AppsFlyerAIRExtension.ane "AppsFlyerAIRExtension.ane")  file from the bin folder
Add the ANE to your project and make sure the IDE is marked to package it.

If the following was not added automatically please add it to the APP_NAME-app.xml:
```
<extensions> 
	<extensionID>com.appsflyer.adobeair</extensionID> 
</extensions>
```
> **Note for Android applications:**
> On AppsFlyer's dashboard you will need to add "air." prefix to the package name as this is added automatically by Air.  For example -  an app with the package name "**com.test.android**"  ,  should set the app id on AppsFlyer's Dashboard as "**air.com.test.android**".


## <a id="Usage"> Usage
Import the AppsFlyer Extension into your project:
```
import AppsFlyerInterface;
```

Construct the AppsFlyer interface:
```
private static var appsFlyer:AppsFlyerInterface; 
appsFlyer = new AppsFlyerInterface();
```

### <a id="android-init"> Android: initialisation and  install/session tracking
Set the Developer key and Initialise the SDK:
```
appsFlyer.appsFlyer.init("DevKey");
```
Initialise session tracking (automatically track app launches and background-to-foreground transitions)
```
appsFlyer.startTracking("DevKey");
```
If you wish to track sessions manually (send a session tracking event, regardless of app state) use the trackAppLaunch method:
```
appsFlyer.trackAppLaunch();
```

### <a id="ios-init"> iOS: initialisation and  install/session tracking

Set the Developer key, the App ID and Initialise the SDK:
```
appsFlyer.startTracking("DevKey", "AppID");
```
Track a session whenever the application is launched / moved from background-to-foreground:
```
appsFlyer.trackAppLaunch();
```
## <a id="api-methods"> API Methods

### <a id="event-tracking"> Tracking In-App Events
In-App  Events can be tracked using the `trackEvent("eventName", "eventValue") API.
For Example: 
```
var param:String = "Deposit";
var value:String = '{"amount":10, "FTDLevel":"-"}';
appsFlyer.trackEvent(param, value);         
```

#### <a id="appUserID"> Setting App User ID
```
appsFlyer.setAppUserId("user_id_as_used_in_the_app");
```
#### <a id="appUserEmail"> Setting App User Email
```
appsFlyer.setUserEmails("example@example.com");
```

#### <a id="currency"> Setting  Currency
```
appsFlyer.setCurrency("USD");
```

#### <a id ="opt"> StopTracking (Opt-Out)
In some extreme cases you might want to shut down all SDK tracking due to legal and privacy compliance. This can be achieved with the isStopTracking API. Once this API is invoked, our SDK will no longer communicate with our servers and stop functioning.
```
appsFlyer.stopTracking();
```
####  <a id="debugLogs"> Enable / Disable AppsFlyer Debug-Logs
```
appsFlyer.setDebug(bool);
```
**Important :** do not release the application to the AppStore / Google Play with debug logs enabled.

----
### <a id="dl"> Deep Linking
#### <a id="dl-su">Setting up  Deep Links in Adobe Air applications
**Android:** Create an `intent-filter` in the Android-Manifest.xml containing the required scheme/host/path properties. For additional reading on App-Links in Adobe Air: https://www.adobe.com/devnet/air/articles/android-app-links.html

**iOS:** Using `URI schemes`. For additional reading on URI schemes in iOS: https://help.adobe.com/en_US/air/build/WSfffb011ac560372f7e64a7f12cd2dd1867-8000.html#WS901d38e593cd1bac354f4f7b12e260e3e67-8000  


**More on DeepLinks and AppsFlyer:** [OneLink™ Overview](https://support.appsflyer.com/hc/en-us/articles/115005248543-OneLink-Overview) 

#### <a id="dl-cb">Receiving Deep Link Callbacks
In order to receive the relevant AppsFlyer information from the deep link used, register the following event listeners:
```
appsFlyer.addEventListener(AppsFlyerEvent.APP_OPEN_ATTRIBUTION, eventHandler); // success 
appsFlyer.addEventListener(AppsFlyerEvent.ATTRIBUTION_FAILURE, eventHandler); // error 
```
And handle the response in a corresponding event handler:
```
private function eventHandler(event:AppsFlyerEvent):void {
	log("AppsFlyer event: " + event.type + "; \nData: " + event.data);
}
```

### <a id="df">Deferred Deep Links (get Conversion Data)
In order to receive the conversion data for the current install, register the following event listeners:
```
appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_DATA_LOADED, eventHandler); // success
appsFlyer.addEventListener(AppsFlyerEvent.INSTALL_CONVERSATION_FAILED, eventHandler); //error
```
And handle the response in a corresponding event handler:
```
private function eventHandler(event:AppsFlyerEvent):void {
	log("AppsFlyer event: " + event.type + "; \nData: " + event.data);
}
```
---

###  <a id="imei-id"> IMEI And Android ID Collection  (Android Only)
By default, IMEI and Android ID are not collected by the SDK if the OS version is higher than KitKat (4.4) and the device contains Google Play Services.

To explicitly send these IDs to AppsFlyer, developers can use the following APIs and place it before initialising the SDK.

If the app does NOT contain Google Play Services, the IMEI and Android ID are collected by the SDK. However, **apps with Google play services should avoid IMEI collection as this is in violation of the Google Play policy**.

#### Enable / Disable IMEI collection
```
appsFlyer.setCollectIMEI(bool);
```
###### *Default value is false (disabled)
#### Manually setting IMEI Data 
```
appsFlyer.setImeiData("imeiString");
```
#### Enable / Disable Android ID collection

```
appsFlyer.setCollectAndroidID(bool);
```
###### *Default value is false (disabled)

#### Manually setting Android ID Data
```
appsFlyer.setAndroidIdData("AndroidIDString");
```

---
### <a id="changelog">Changelog
You can find the release changelog [here](https://appsflyer.zendesk.com/hc/en-us/articles/207032226).