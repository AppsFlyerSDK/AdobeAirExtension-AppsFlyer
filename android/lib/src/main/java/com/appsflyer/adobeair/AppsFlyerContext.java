package com.appsflyer.adobeair;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.appsflyer.adobeair.functions.*;

import java.util.HashMap;
import java.util.Map;

public class AppsFlyerContext extends FREContext {

    public static final String EXTENSION_TYPE = "AIR";
    public final static String LOG_TAG = "AppsFlyer";

    private String lastConversionData;
    private String devKey;
//    private DeepLinkResult lastDeepLinkResult;

    @Override
    public void dispose() {
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        map.put("init", new AppsFlyerInit());
        map.put("registerConversionListener", new RegisterConversionListener());
        map.put("start", new Start());
        map.put("stop", new Stop());
        map.put("isStopped", new IsStopped());
        map.put("logEvent", new LogEvent());
        map.put("registerUninstall", new RegisterUninstall());
        map.put("setCurrency", new SetCurrency());
        map.put("setAndroidIdData", new SetAndroidIdData());
        map.put("setImeiData", new SetImeiData());
        map.put("setCollectAndroidID", new SetCollectAndroidID());
        map.put("setCollectIMEI", new SetCollectIMEI());
        map.put("getAppsFlyerUID", new GetAppsFlyerUID());
        map.put("waitForCustomerUserID", new WaitForCustomerUserID());
        map.put("startWithCUID", new StartWithCUID());
        map.put("setDebug", new SetDebug());
        map.put("setResolveDeepLinkURLs", new SetResolveDeepLinkURLsFunction());
        map.put("validateAndLogInAppPurchase", new ValidateAndLogInAppPurchaseFunction());
        map.put("registerValidatorListener", new RegisterValidatorListenerFunction());
        map.put("useReceiptValidationSandbox", new UseReceiptValidationSandboxFunction());
        map.put("setOneLinkCustomDomain", new SetOneLinkCustomDomain());
        map.put("performOnAppAttribution", new PerformOnAppAttribution());
        map.put("setSharingFilter", new SetSharingFilter());
        map.put("setSharingFilterForAllPartners", new SetSharingFilterForAllPartners());
        map.put("setCustomerUserId", new SetCustomerUserId());
        map.put("setUserEmails", new SetUserEmails());
        map.put("waitForATTUserAuthorization", new waitForATTUserAuthorization());
        map.put("disableSKAdNetwork", new DisableSKAdNetwork());
        map.put("setDisableAdvertisingIdentifiers", new SetDisableAdvertisingIdentifiers());
        map.put("setSharingFilterForPartners", new SetSharingFilterForPartners());
        map.put("setCurrentDeviceLanguage", new SetCurrentDeviceLanguage());
        map.put("EnableTCFDataCollection", new EnableTCFDataCollection());
        map.put("SetConsentForNonGDPRUser", new SetConsentForNonGDPRUser());
        map.put("SetConsentForGDPRUser", new SetConsentForGDPRUser());
//        map.put("subscribeForDeepLink", new SubscribeForDeepLink());
        return map;
    }

    public String getLastConversionData() {
        return lastConversionData;
    }

    public void setLastConversionData(String lastConversionData) {
        this.lastConversionData = lastConversionData;
    }

//    public void setLastDeepLinkResult(DeepLinkResult deepLinkResult) {
//        this.lastDeepLinkResult = deepLinkResult;
//    }

    public String getDevKey() {
        return devKey;
    }

    public void setDevKey(String devKey) {
        this.devKey = devKey;
    }

//    public String getLastDeepLinkResult() {
//        return lastDeepLinkResult.toString();
//    }
}
