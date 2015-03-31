package com.appsflyer.adobeair;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

public class AppsFlyerContext extends FREContext {

    public static final String EXTENSION_TYPE = "AIR";

    private String lastConversionData;

    @Override
    public void dispose() {
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        map.put("setDeveloperKey", new SetDeveloperKeyFuncation());
        map.put("sendTrackingWithEvent", new SendTrackingWithEventFunction());
        map.put("sendTrackingWithValues", new SendTrackingWithValuesFunction());
        map.put("sendTracking", new SendTrackingFunction());
        map.put("setCurrency", new SetCurrency());
        map.put("setAppUserId", new SetAppUserId());
        map.put("getConversionData", new GetConversionData());

        map.put("setCollectAndroidID", new SetCollectAndroidID());
        map.put("setCollectIMEI", new SetCollectIMEI());
        map.put("getAppsFlyerUID", new GetAppsFlyerUID());
//        map.put("setExtension", new SetExtension());

        return map;
    }

    public String getLastConversionData() {
        return lastConversionData;
    }

    public void setLastConversionData(String lastConversionData) {
        this.lastConversionData = lastConversionData;
    }
}
