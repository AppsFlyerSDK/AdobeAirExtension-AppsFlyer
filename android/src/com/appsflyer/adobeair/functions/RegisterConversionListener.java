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

public class RegisterConversionListener implements FREFunction {

    private final static String LOG = "AppsFlyer";

    @Override
    public FREObject call(final FREContext freContext, FREObject[] freObjects) {


        try {

            final AppsFlyerContext cnt = (AppsFlyerContext) freContext;
            Context context = freContext.getActivity().getApplicationContext();

            Log.i(LOG, "RegisterConversionListener with registerConversionListener");
            AppsFlyerLib.getInstance().registerConversionListener(context, new AppsFlyerConversionListener() {

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
            });
        } catch (Exception e) {
            Log.e("AppsFlyer: ", "Exception RegisterConversionListener: " + e);
        }
        return null;
    }

}
