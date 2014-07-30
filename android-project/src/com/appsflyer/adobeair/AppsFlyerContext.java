package com.appsflyer.adobeair;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

import java.util.HashMap;
import java.util.Map;

public class AppsFlyerContext extends FREContext {

    public static final String EXTENSION_TYPE = "AIR";

    @Override
    public void dispose() {
        // TODO Auto-generated method stub
    }

    @Override
    public Map<String, FREFunction> getFunctions() {
        Map<String, FREFunction> map = new HashMap<String, FREFunction>();
        map.put("setDeveloperKey", new SetDeveloperKeyFuncation());
        map.put("sendTracking", new SendTrackingEventFunction());
        map.put("setCurrency", new SetCurrency());
        map.put("setAppUserId", new SetAppUserId());
        map.put("getConversionData", new GetConversionData());

        map.put("setCollectAndroidID", new SetCollectAndroidID());
        map.put("setCollectIMEI", new SetCollectIMEI());
        map.put("getAppsFlyerUID", new GetAppsFlyerUID());
        map.put("setExtension", new SetExtension());

        return map;
    }

//    public void test() {
//        try {
//            AdvertisingIdClient.class.getName();
//            Class.forName("com.appsflyer.AppsFlyerLib");
//            Class.forName("com.google.android.gms.ads.identifier.AdvertisingIdClient");
//            Log.i("TEST", " My WARNING  Google Play services SDK FOUND");
//        } catch (ClassNotFoundException e){
//            Log.i("TEST", " My WARNING ClassNotFoundException Google Play services SDK is missing: " + e.getMessage());
//            e.printStackTrace();
//        }   catch (NullPointerException e) {
//            Log.i("TEST",e.toString());
//        } catch (Exception e){
//            Log.i("TEST",e.toString());
//        }
//    }
}
