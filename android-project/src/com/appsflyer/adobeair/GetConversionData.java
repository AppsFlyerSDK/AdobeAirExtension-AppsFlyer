package com.appsflyer.adobeair;

import android.content.Context;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.AppsFlyerLib;

import java.util.Map;


public class GetConversionData implements FREFunction {

    @Override
    public FREObject call(final FREContext arg0, FREObject[] arg1) {

        try {
            Context context = arg0.getActivity().getApplicationContext();
            final AppsFlyerContext cnt = (AppsFlyerContext)arg0;
//            Log.e("AppsFlyer: ", "GetConversionData");
//            AppsFlyerLib.getConversionData(context, new ConversionDataListener() {
//
//                @Override
//                public void onConversionDataLoaded(Map<String, String> conversionData) {
//                    Log.e("AppsFlyer: ", "GetConversionData onConversionDataLoaded");
//                    arg0.dispatchStatusEventAsync("installConversionDataLoaded", getResultString(conversionData));
//                }
//
//                @Override
//                public void onConversionFailure(String errorMessage) {
//                    Log.e("AppsFlyer: ", "GetConversionData errorMessage");
//                    sb.append("Error retrieving conversion data").append(errorMessage);
//                    arg0.dispatchStatusEventAsync("installConversionFailure", sb.toString());
//                }
//
//                private String getResultString(Map<String, String> conversionData) {
//                    boolean first = true;
//                    sb.append("{");
//                    for (String attrName : conversionData.keySet()) {
//                        if (!first) {
//                            sb.append(",");
//                        } else {
//                            first = false;
//                        }
//                        String str = "\"" + attrName + "\" : \"" + conversionData.get(attrName) + "\"";
//                        sb.append(str);
//                    }
//
//                    sb.append("}");
//                    return sb.toString();
//                }
//            });
           if(cnt.getLastConversionData() != null) {
               arg0.dispatchStatusEventAsync("installConversionDataLoaded", cnt.getLastConversionData());
               Log.i("AppsFlyer: ", "GetConversionData from cache " + cnt.getLastConversionData());
           } else {
                AppsFlyerLib.registerConversionListener(context, new AppsFlyerConversionListener() {

                    public void onInstallConversionDataLoaded(java.util.Map<java.lang.String, java.lang.String> conversionData) {
                        Log.i("AppsFlyer: ", "GetConversionData onConversionDataLoaded");
                        cnt.setLastConversionData(getResultString(conversionData));
                        arg0.dispatchStatusEventAsync("installConversionDataLoaded", cnt.getLastConversionData());
                    }

                    public void onCurrentAttributionDataLoaded(Map<String, String> conversionData) {
                        Log.i("AppsFlyer: ", "GetConversionData onConversionDataLoaded");
                        cnt.setLastConversionData(getResultString(conversionData));
                        arg0.dispatchStatusEventAsync("currentAttributionDataLoaded", cnt.getLastConversionData());
                    }

                    private String getResultString(Map<String, String> conversionData) {
                        boolean first = true;
                        StringBuilder sb = new StringBuilder();
                        sb.append("{");
                        for (String attrName : conversionData.keySet()) {
                            if (!first) {
                                sb.append(",");
                            } else {
                                first = false;
                            }
                            String str = "\"" + attrName + "\" : \"" + conversionData.get(attrName) + "\"";
                            sb.append(str);
                        }

                        sb.append("}");
                        return sb.toString();
                    }

                    public void onInstallConversionFailure(String errorMessage) {
                        Log.i("AppsFlyer: ", "GetConversionData errorMessage" + errorMessage);
                        cnt.setLastConversionData("Error retrieving conversion data " + errorMessage);
                        arg0.dispatchStatusEventAsync("installConversionFailure", cnt.getLastConversionData());
                    }
                });
               Log.i("AppsFlyer: ", "GetConversionData with registerConversionListener");
           }

        } catch (Exception e) {
            Log.e("AppsFlyer: ", "Exception GetConversionData: " + e);
        }
        return null;
    }
}
