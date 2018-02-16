package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.AppsFlyerContext;

public class StopTracking implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        final AppsFlyerContext cnt = (AppsFlyerContext)freContext;
        boolean isTrackingStopped = false;
        try {
            isTrackingStopped = freObjects[0].getAsBool();
        } catch (Exception e) {
            e.printStackTrace();
        }
        AppsFlyerLib.getInstance().stopTracking(isTrackingStopped, cnt.getActivity().getApplicationContext());

        return null;
    }

}
