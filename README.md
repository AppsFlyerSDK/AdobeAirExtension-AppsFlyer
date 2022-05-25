# AppsFlyer Adobe Air extension 

In order for us to provide optimal support, we would kindly ask you to submit any issues to support@appsflyer.com

*When submitting an issue please specify your AppsFlyer sign-up (account) email , your app ID , production steps, logs, code snippets and any additional relevant information.*

## Table of content

- [v6 Breaking changes](#v6-breaking-changes)
- [Plugin info](#plugin-info)
- [Installation](#installation)
  - [Notes for Android apps](#android_notes)
  - [Notes for iOS apps](#ios_notes)
- [Usage](#Usage)
- [Deep Linking](#dl)
- [IMEI And Android ID Collection  (Android Only)](#imei-id)
- [API Methods](#api-methods)
- [Changelog](#changelog)

---

## <a id="v6-breaking-changes"> ❗ v6 Breaking Changes

We have renamed the following APIs:

| Old API                       | New API                       |
| ------------------------------|-------------------------------|
| trackEvent                    | logEvent                      |
| startTracking                 | start                         |
| stopTracking                  | stop                          |
| isTrackingStopped             | isStopped                     |
| setCustomerIdAndTrack         | startWithCUID                 |
| validateAndTrackInAppPurchase | validateAndLogInAppPurchase   |

And removed the following ones:

- trackAppLaunch -> no longer needed. See new init guide
- sendDeepLinkData -> no longer needed

If you have used 1 of the removed APIs, please check the integration guide for the updated instructions

## <a id="plugin-info"> Plugin info

Supported platforms:

- Android
- iOS 6+

Based on:

- iOS AppsFlyerSDK **v6.5.4**
- Android AppsFlyerSDK **v6.5.4**

Built with:

- SWF-version = 44
- AIR SDK version = 33.1.1.821

---

## <a id="installation"> Installation
Download the [AppsFlyerAIRExtension.ane](https://github.com/AppsFlyerSDK/AdobeAirExtension-AppsFlyer/blob/master/bin/AppsFlyerAIRExtension.ane "AppsFlyerAIRExtension.ane") file from the bin folder
Add the ANE to your project and make sure the IDE is marked to package it.

If the following was not added automatically please add it to the APP_NAME-app.xml:

```
<extensions> 
	<extensionID>com.appsflyer.adobeair</extensionID> 
</extensions>
```

### <a id="android_notes"> **Special instructions for Android applications:**
<details>
	
- On AppsFlyer's dashboard you will need to add "air." prefix to the package name as this is added automatically by Air.  For example -  an app with the package name "**com.test.android**"  ,  should set the app id on AppsFlyer's Dashboard as "**air.com.test.android**".

- Add the following permissions to Android Manifest (in the app description `APP_NAME-app.xml`):  
```
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE"/>
<uses-permission android:name="com.google.android.finsky.permission.BIND_GET_INSTALL_REFERRER_SERVICE" />
```
- Add the following metatag to Android Manifest within the application tag (in the app description `APP_NAME-app.xml`):  
`<meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version" />`

As a result, you should see your Manifest like this:

![image](https://user-images.githubusercontent.com/50541317/88154121-047b8100-cc0f-11ea-9647-5dae37e9817f.png)


**IMPORTANT If you use AIR SDK < v33.1.1.856**  

Due to some limitations in the [ADT](https://help.adobe.com/en_US/air/build/WS5b3ccc516d4fbf351e63e3d118666ade46-7fd9.html)
bundled with AIR SDK < 33.1.1.856, after APK is built it is missing some important files.

To add those files (with the help of **automated** script):
 
 1. Place into single directory of your choice:
- apk file
- keystore that was used to sign the apk
- [af_apk_fix.sh script](https://github.com/AppsFlyerSDK/AdobeAirExtension-AppsFlyer/blob/master/bin/af_apk_fix.sh)  

2. Run `./af_apk_fix.sh` and enter requested info when prompted

Here is what the script is doing. In case of any issues you can perform those steps **manually**: 

1. Decode the apk using [apktool](https://ibotpeaches.github.io/Apktool/). This will create app_name folder.  
   `apktool d app_name.apk`
2. Download
   the [AppsFlyer SDK jar/aar](https://repo.maven.apache.org/maven2/com/appsflyer/af-android-sdk/6.5.4/af-android-sdk-6.5.4.aar)
   of the same version that was used in the apk
3. Extract files `a-` and `b-` from the jar (by renaming jar into a zip) and place them into the folder with the
   decompiled apk to `app_name/unknown/com/appsflyer/internal`

4. Edit `apktool.yml` by adding these lines under `unknownFiles:` like in the screenshot below:
```
com/appsflyer/internal/b-: '0'
com/appsflyer/internal/a-: '0'
```

![image](https://user-images.githubusercontent.com/50541317/87637508-05ae3900-c74b-11ea-8a22-9757c088c4c4.png)


5. Build the apk back (will appear under `app_name/dist` folder)  
   `apktool b app`

6. Zipalign the apk
   `zipalign -p -f -v 4 app_name/dist/app_name.apk app_name/dist/app_name-aligned.apk`

7. Sign the apk
   `apksigner sign -v --ks myKeystore.jks --ks-key-alias myKey --out app_name/dist/app_name-aligned-signed.apk app_name/dist/app_name-aligned.apk`

8. Verify signature
   `apksigner verify app_name/dist/app_name-aligned-signed.apk`

9. Verify zipalignment  
   `zipalign -c -v 4 app_name/dist/app_name-aligned-signed.apk`

10. Your apk `app_name/dist/app_name-aligned-signed.apk` is ready to use!

</details>

### <a id="ios_notes"> **Special instructions for iOS applications:**
<details>
If you use Strict mode ANE, make sure not to call any IDFA related APIs listed below. They are still present in the ActionScript, but will cause an app to crash if invoked.

- `waitForATTUserAuthorization(timeout:int):void;`
</details>

---

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

(Optional) If you want to perform deep linking or access AppsFlyer conversion data from the application, register Conversion Listener:

```
appsFlyer.registerConversionListener();
```

Set the Developer key and iOS app ID and Initialise the SDK:

```
appsFlyer.appsFlyer.init("DevKey", "iOSAppID");
```

Initialise session reporting (automatically report app launches and background-to-foreground transitions) with DevKey and iOS app ID:

```
appsFlyer.start("DevKey", "iOSAppID");
```

### Note:
If you don't target iOS as a platform, specifying `iOSAppID` ID is not required

---

## <a id="dl"> Deep Linking
	
#### <a id="dl-su">Setting up  Deep Links in Adobe Air applications
**Android:** Create an `intent-filter` in the Android-Manifest.xml containing the required scheme/host/path properties. For additional reading on App-Links in Adobe Air: https://www.adobe.com/devnet/air/articles/android-app-links.html

**iOS:** Using `URI schemes`. For additional reading on URI schemes in iOS: https://help.adobe.com/en_US/air/build/WSfffb011ac560372f7e64a7f12cd2dd1867-8000.html#WS901d38e593cd1bac354f4f7b12e260e3e67-8000  

**More on DeepLinks and AppsFlyer:** [OneLink™ Overview](https://support.appsflyer.com/hc/en-us/articles/115005248543-OneLink-Overview) 

### <a id="dl-cb">Receiving Deep Link Callbacks
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

##  <a id="imei-id"> IMEI And Android ID Collection  (Android Only)
By default, IMEI and Android ID are not collected by the SDK if the OS version is higher than KitKat (4.4) and the device contains Google Play Services.

To explicitly send these IDs to AppsFlyer, developers can use the following APIs and place it before initialising the SDK.

If the app does NOT contain Google Play Services, the IMEI and Android ID are collected by the SDK. However, **apps with Google play services should avoid IMEI collection as this is in violation of the Google Play policy**.

#### Enable / Disable IMEI collection (disabled by default)

```
appsFlyer.setCollectIMEI(bool);
```

#### Manually setting IMEI Data 

```
appsFlyer.setImeiData("imeiString");
```

#### Enable / Disable Android ID collection (disabled by default)

```
appsFlyer.setCollectAndroidID(bool);
```

#### Manually setting Android ID Data

```
appsFlyer.setAndroidIdData("AndroidIDString");
```

---

## <a id="api-methods"> API Methods

### <a id="event-logging"> Logging In-App Events
In-App  Events can be logged using the `logEvent("eventName", "eventValue") API.
For Example: 
	
```
var param:String = "Deposit";
var value:String = '{"amount":10, "FTDLevel":"-"}';
appsFlyer.logEvent(param, value);         
```

### <a id="appUserId"> Setting App User ID
	
```
appsFlyer.setAppUserId("user_id_as_used_in_the_app");
```

### <a id="appUserEmail"> Setting App User Email

```
appsFlyer.setUserEmails("example@example.com");
```

### <a id="currency"> Setting  Currency

```
appsFlyer.setCurrency("USD");
```

### <a id ="opt"> Stop (Opt-Out)
In some extreme cases you might want to shut down all SDK reporting due to legal and privacy compliance. This can be achieved with the stop() API. Once this API is invoked, our SDK will no longer communicate with our servers and stop functioning.

```
appsFlyer.stop();
```

###  <a id="debugLogs"> Enable / Disable AppsFlyer Debug-Logs

```
appsFlyer.setDebug(bool);
```

**Important :** do not release the application to the AppStore / Google Play with debug logs enabled.

---

## <a id="changelog">Changelog
You can find the release changelog [here](https://appsflyer.zendesk.com/hc/en-us/articles/207032226).
