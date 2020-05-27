package com.appsflyer.adobeair.functions;

import android.content.Context;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.AppsFlyerContext;
import com.appsflyer.adobeair.Utils;

import java.util.Map;

public class AppsFlyerInit implements FREFunction {

    private final static String LOG = "AppsFlyer";

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String devKey = "";
        try {
            devKey = freObjects[0].getAsString();
        } catch (Exception e) {
            e.printStackTrace();
        }

        final AppsFlyerContext cnt = (AppsFlyerContext)freContext;

        try {
            AppsFlyerConversionListener conversionDataListener = new AppsFlyerConversionListener() {

                @Override
                public void onAppOpenAttribution(Map<String, String> map) {
                    Log.i(LOG, "AppsFlyerConversionListener onAppOpenAttribution");
                    cnt.setLastConversionData(Utils.mapToJsonString(map));
                    cnt.dispatchStatusEventAsync("appOpenAttribution", cnt.getLastConversionData());
                }

                @Override
                public void onAttributionFailure(String s) {
                    Log.i(LOG, "AppsFlyerConversionListener onAttributionFailure");
                    cnt.setLastConversionData("Error retrieving conversion data " + s);
                    cnt.dispatchStatusEventAsync("attributionFailure", cnt.getLastConversionData());
                }

                public void onInstallConversionDataLoaded(java.util.Map<java.lang.String, java.lang.String> conversionData) {
                    Log.i(LOG, "AppsFlyerConversionListener onInstallConversionDataLoaded");
                    cnt.setLastConversionData(Utils.mapToJsonString(conversionData));
                    cnt.dispatchStatusEventAsync("installConversionDataLoaded", cnt.getLastConversionData());
                }

                public void onInstallConversionFailure(String errorMessage) {
                    Log.i("AppsFlyer: ", "AppsFlyerConversionListener errorMessage");
                    cnt.setLastConversionData("Error retrieving conversion data " + errorMessage);
                    cnt.dispatchStatusEventAsync("installConversionFailure", cnt.getLastConversionData());
                }
            };

            AppsFlyerLib.getInstance().init(devKey, conversionDataListener, freContext.getActivity().getApplicationContext());
            AppsFlyerLib.getInstance().startTracking(freContext.getActivity().getApplication());
            cnt.setDevKey(devKey);

        } catch (Exception e) {
            Log.e("AppsFlyer: ", "Exception initializing SDK: " + e);
        }
        return null;
    }

}
