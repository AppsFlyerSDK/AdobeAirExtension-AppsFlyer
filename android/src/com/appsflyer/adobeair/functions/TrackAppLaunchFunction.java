package com.appsflyer.adobeair.functions;


import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.AppsFlyerContext;

public class TrackAppLaunchFunction implements com.adobe.fre.FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        final AppsFlyerContext cnt = (AppsFlyerContext)freContext;
        AppsFlyerLib.getInstance().trackAppLaunch(freContext.getActivity().getApplicationContext(), cnt.getDevKey());
        return null;
    }
}