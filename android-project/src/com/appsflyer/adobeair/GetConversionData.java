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
            final StringBuilder sb = new StringBuilder();
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

            AppsFlyerLib.registerConversionListener(context, new AppsFlyerConversionListener() {

                public void onInstallConversionDataLoaded(java.util.Map<java.lang.String, java.lang.String> conversionData) {
                    Log.e("AppsFlyer: ", "GetConversionData onConversionDataLoaded");
                    arg0.dispatchStatusEventAsync("installConversionDataLoaded", getResultString(conversionData));
                }

                public void onCurrentAttributionDataLoaded(Map<String, String> conversionData) {
                    Log.e("AppsFlyer: ", "GetConversionData onConversionDataLoaded");
                    arg0.dispatchStatusEventAsync("currentAttributionDataLoaded", getResultString(conversionData));
                }

                private String getResultString(Map<String, String> conversionData) {
                    boolean first = true;
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
                    Log.e("AppsFlyer: ", "GetConversionData errorMessage");
                    sb.append("Error retrieving conversion data").append(errorMessage);
                    arg0.dispatchStatusEventAsync("installConversionFailure", sb.toString());
                }
            });
            Log.e("AppsFlyer: ", "GetConversionData with registerConversionListener");
        } catch (Exception e) {
            Log.e("AppsFlyer: ", "Exception GetConversionData: " + e);
        }
        return null;
    }
}
