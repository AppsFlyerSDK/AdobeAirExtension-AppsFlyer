package com.appsflyer.adobeair;

import android.content.Context;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.AppsFlyerLib;

import java.util.Map;

public class SendTrackingFunction implements FREFunction {

    @Override
    public FREObject call(FREContext arg0, FREObject[] arg1) {
        final AppsFlyerContext cnt = (AppsFlyerContext)arg0;
        Context context = arg0.getActivity().getApplicationContext();

        AppsFlyerLib.sendTracking(context);
        Log.i("AppsFlyer: ", "SendTrackingFunction with registerConversionListener");
        AppsFlyerLib.registerConversionListener(context, new AppsFlyerConversionListener() {
            public void onInstallConversionDataLoaded(java.util.Map<java.lang.String, java.lang.String> conversionData) {
                Log.i("AppsFlyer: ", "SendTrackingFunction onInstallConversionDataLoaded");
                cnt.setLastConversionData(getResultString(conversionData));
            }

            public void onCurrentAttributionDataLoaded(Map<String, String> conversionData) {
                Log.i("AppsFlyer: ", "SendTrackingFunction onCurrentAttributionDataLoaded");
                cnt.setLastConversionData(getResultString(conversionData));
            }

            private String getResultString(Map<String, String> conversionData) {
                StringBuilder sb = new StringBuilder();
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
                Log.i("AppsFlyer: ", "SendTrackingFunction errorMessage");
                cnt.setLastConversionData("Error retrieving conversion data " + errorMessage);
            }
        });
        return null;
    }

}
