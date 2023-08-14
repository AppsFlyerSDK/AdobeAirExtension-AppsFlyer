package com.appsflyer.adobeair.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.AppsFlyerContext;
import com.appsflyer.adobeair.Utils;
import com.appsflyer.internal.platform_extension.Plugin;
import com.appsflyer.internal.platform_extension.PluginInfo;

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

                @Override
                public void onConversionDataSuccess(Map<String, Object> map) {
                    Log.i(LOG, "AppsFlyerConversionListener onInstallConversionDataLoaded");
                    cnt.setLastConversionData(Utils.mapToJsonString(map));
                    cnt.dispatchStatusEventAsync("installConversionDataLoaded", cnt.getLastConversionData());
                }

                @Override
                public void onConversionDataFail(String errorMessage) {
                    Log.i("AppsFlyer: ", "AppsFlyerConversionListener errorMessage");
                    cnt.setLastConversionData("Error retrieving conversion data " + errorMessage);
                    cnt.dispatchStatusEventAsync("installConversionFailure", cnt.getLastConversionData());
                }
            };

            AppsFlyerLib.getInstance().init(devKey, conversionDataListener, freContext.getActivity().getApplicationContext());
            PluginInfo pluginInfo = new PluginInfo(Plugin.ADOBE_AIR, "6.12.1");
            AppsFlyerLib.getInstance().setPluginInfo(pluginInfo);
            cnt.setDevKey(devKey);

        } catch (Exception e) {
            Log.e("AppsFlyer: ", "Exception initializing SDK: " + e);
        }
        return null;
    }

}
