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


public class GetConversionData implements FREFunction {

    private final static String LOG = "AppsFlyer";

    @Override
    public FREObject call(final FREContext freContext, FREObject[] freObjects) {

        try {
            //Context context = freContext.getActivity().getApplicationContext();
            final AppsFlyerContext cnt = (AppsFlyerContext) freContext;
            if (cnt.getLastConversionData() != null) {
                freContext.dispatchStatusEventAsync("installConversionDataLoaded", cnt.getLastConversionData());
                Log.i(LOG, "GetConversionData from cache " + cnt.getLastConversionData());
            }
//            else {
//                AppsFlyerLib.getInstance().registerConversionListener(context, new AppsFlyerConversionListener() {
//                    @Override
//                    public void onAppOpenAttribution(Map<String, String> map) {
//                        Log.i(LOG, "RegisterConversionListener onAppOpenAttribution");
//                        cnt.setLastConversionData(getResultString(map));
//                        freContext.dispatchStatusEventAsync("appOpenAttribution", cnt.getLastConversionData());
//                    }
//
//                    @Override
//                    public void onAttributionFailure(String s) {
//                        Log.i(LOG, "RegisterConversionListener onAttributionFailure");
//                        cnt.setLastConversionData("Error retrieving conversion data " + s);
//                        freContext.dispatchStatusEventAsync("attributionFailure", cnt.getLastConversionData());
//                    }
//
//                    public void onInstallConversionDataLoaded(Map<String, String> conversionData) {
//                        Log.i(LOG, "GetConversionData onConversionDataLoaded");
//                        cnt.setLastConversionData(getResultString(conversionData));
//                        freContext.dispatchStatusEventAsync("installConversionDataLoaded", cnt.getLastConversionData());
//                    }
//
//                    public void onInstallConversionFailure(String errorMessage) {
//                        Log.e("AppsFlyer: ", "GetConversionData errorMessage" + errorMessage);
//                        cnt.setLastConversionData("Error retrieving conversion data " + errorMessage);
//                        freContext.dispatchStatusEventAsync("installConversionFailure", cnt.getLastConversionData());
//                    }
//
//                    private String getResultString(Map<String, String> data) {
//                        StringWriter out = new StringWriter();
//                        try {
//                            JSONValue.writeJSONString(data, out);
//                        } catch (IOException e) {
//                            e.printStackTrace();
//                        }
//                        return out.toString();
//                    }
//                });
//                Log.i("AppsFlyer: ", "GetConversionData with registerConversionListener");
//            }

        } catch (Exception e) {
            Log.e("AppsFlyer: ", "Exception GetConversionData: " + e);
        }
        return null;
    }
}
