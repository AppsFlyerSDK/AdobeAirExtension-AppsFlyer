package com.appsflyer.adobeair;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.appsflyer.adobeair.functions.*;

import java.util.HashMap;
import java.util.Map;

public class AppsFlyerContext extends FREContext {

    public static final String EXTENSION_TYPE = "AIR";

    private String lastConversionData;
    private String devKey;

    @Override
    public void dispose() {
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        map.put("init", new AppsFlyerInit());
        map.put("registerConversionListener", new RegisterConversionListener());
        map.put("startTracking", new StartTracking());
        map.put("stopTracking", new StopTracking());
        map.put("isTrackingStopped", new IsTrackingStopped());
        map.put("trackAppLaunch", new TrackAppLaunchFunction());
        map.put("trackEvent", new TrackEventFunction());
        map.put("registerUninstall", new RegisterUninstallFunction());
        map.put("setCurrency", new SetCurrency());
        map.put("getConversionData", new GetConversionData());
        map.put("setAndroidIdData", new SetAndroidIdData());
        map.put("setImeiData", new SetImeiData());
        map.put("setCollectAndroidID", new SetCollectAndroidID());
        map.put("setCollectIMEI", new SetCollectIMEI());
        map.put("getAppsFlyerUID", new GetAppsFlyerUID());
        map.put("setAppUserId", new SetCustomerUserId());
        map.put("setUserEmails", new SetUserEmails());
        map.put("setDebug", new SetDebug());
        map.put("sendDeepLinkData", new SendDeepLinkData());
        map.put("validateAndTrackInAppPurchase", new ValidateAndTrackInAppPurchaseFunction());
        map.put("registerValidatorListener", new RegisterValidatorListenerFunction());
        map.put("useReceiptValidationSandbox", new UseReceiptValidationSandboxFunction());


        return map;
    }

    public String getLastConversionData() {
        return lastConversionData;
    }

    public void setLastConversionData(String lastConversionData) {
        this.lastConversionData = lastConversionData;
    }

    public String getDevKey() {
        return devKey;
    }

    public void setDevKey(String devKey) {
        this.devKey = devKey;
    }
}
