package com.appsflyer.adobeair;

import java.util.Map;

import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.ConversionDataListener;


public class GetConversionData implements FREFunction {

	@Override
	public FREObject call(final FREContext arg0, FREObject[] arg1) {
		
		try
		{
			Context context = arg0.getActivity().getApplicationContext();
			final StringBuilder sb = new StringBuilder();
            //AppsFlyerLib.getConversionData(context, new ConversionDataListener() {
            AppsFlyerLib.registerConversionListener(context, new AppsFlyerConversionListener() {

                public void onInstallConversionDataLoaded(java.util.Map<java.lang.String,java.lang.String> conversionData) {
                    arg0.dispatchStatusEventAsync("installConversionDataLoaded", getResultString(conversionData));
                }

                public void onCurrentAttributionDataLoaded(Map<String, String> conversionData) {
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
                    sb.append("Error retrieving conversion data").append(errorMessage);
                    arg0.dispatchStatusEventAsync("installConversionFailure", sb.toString());
                }
            });
            AppsFlyerLib.getConversionData(context);
			return null;
		}
		catch(Exception e)
		{
			return null;
		}
	}
}
