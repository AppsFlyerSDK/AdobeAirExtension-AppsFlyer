package com.appsflyer.adobeair.lib;

import android.content.Context;
import android.content.SharedPreferences;

import java.util.HashMap;
import java.util.Map;

/**
 * static properties
 */
public class AppsFlyerProperties {

    // the user id given by the app (optional)
    public static final String APP_USER_ID = "AppUserId";
    public static final String APP_ID = "appid";
    public static final String CURRENCY_CODE = "currencyCode";
    public static final String IS_UPDATE = "IS_UPDATE";
    public static final String AF_KEY = "AppsFlyerKey";
    public static final String USE_HTTP_FALLBACK = "useHttpFallback";
    public static final String COLLECT_ANDROID_ID = "collectAndroidId";
    public static final String COLLECT_IMEI = "collectIMEI";
    public static final String CHANNEL = "channel";

    public static final String COLLECT_MAC = "collectMAC";
    public static final String DEVICE_TRACKING_DISABLED = "deviceTrackingDisabled";
    private static AppsFlyerProperties instance = new AppsFlyerProperties();

    private Map<String,String> properties = new HashMap<String, String>();
    private boolean isOnReceiveCalled;
    private boolean isLaunchCalled;
    private String  referrer;

    private AppsFlyerProperties() {
    }

    public static AppsFlyerProperties getInstance() {
        return instance;
    }

    public void set(String key, String value){
        properties.put(key,value);
    }

    public String get(String key){
        return properties.get(key);
    }

    public void set(String key, boolean value) {
        properties.put(key, Boolean.toString(value));
    }

    public boolean getBoolean(String key,boolean defaultValue){
        String value = get(key);
        if (value == null){
            return defaultValue;
        }
        return Boolean.valueOf(value);
    }

    protected boolean isOnReceiveCalled() {
        return isOnReceiveCalled;
    }

    protected void setOnReceiveCalled() {
        isOnReceiveCalled = true;
    }

    protected boolean isLaunchCalled() {
        return isLaunchCalled;
    }

    protected void setLaunchCalled() {
        isLaunchCalled = true;
    }

    protected void setReferrer(String referrer){
        this.referrer = referrer;
    }

    public String getReferrer(Context context) {
        if(referrer != null){
            return referrer;
        } else {
            SharedPreferences sharedPreferences = context.getSharedPreferences(AppsFlyerLib.AF_SHARED_PREF, 0);
            return sharedPreferences.getString(AppsFlyerLib.REFERRER_PREF,null);
        }
    }
}
