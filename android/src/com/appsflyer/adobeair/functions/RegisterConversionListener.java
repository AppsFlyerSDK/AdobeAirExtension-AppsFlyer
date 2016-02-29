package com.appsflyer.adobeair.functions;

import android.content.Context;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.AppsFlyerContext;
import org.json.simple.JSONValue;

import java.io.IOException;
import java.io.StringWriter;
import java.util.Map;

public class RegisterConversionListener implements FREFunction {

    private final static String LOG = "AppsFlyer";

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        final AppsFlyerContext cnt = (AppsFlyerContext)freContext;
        Context context = freContext.getActivity().getApplicationContext();

        Log.i(LOG, "RegisterConversionListener with registerConversionListener");
        AppsFlyerLib.getInstance().registerConversionListener(context, new AppsFlyerConversionListener() {

            @Override
            public void onAppOpenAttribution(Map<String, String> map) {
                Log.i(LOG, "AppsFlyerConversionListener onAppOpenAttribution");
                cnt.setLastConversionData(getResultString(map));
            }

            @Override
            public void onAttributionFailure(String s) {
                Log.i(LOG, "AppsFlyerConversionListener onAttributionFailure");
                cnt.setLastConversionData("Error retrieving conversion data " + s);
            }

            public void onInstallConversionDataLoaded(java.util.Map<java.lang.String, java.lang.String> conversionData) {
                Log.i(LOG, "AppsFlyerConversionListener onInstallConversionDataLoaded");
                cnt.setLastConversionData(getResultString(conversionData));
            }

            private String getResultString(Map<String, String> data) {
                StringWriter out = new StringWriter();
                try {
                    JSONValue.writeJSONString(data, out);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                return out.toString();
            }

            public void onInstallConversionFailure(String errorMessage) {
                Log.i("AppsFlyer: ", "AppsFlyerConversionListener errorMessage");
                cnt.setLastConversionData("Error retrieving conversion data " + errorMessage);
            }
        });
        return null;
    }

}
