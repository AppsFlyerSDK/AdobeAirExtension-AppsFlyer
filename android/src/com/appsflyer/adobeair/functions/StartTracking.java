package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.AppsFlyerContext;

public class StartTracking implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        final AppsFlyerContext cnt = (AppsFlyerContext)freContext;
        String devKey = null;
        try {
            devKey = freObjects[0].getAsString();
        } catch (Exception e) {
            e.printStackTrace();
        }

        if(devKey == null) {
            AppsFlyerLib.getInstance().startTracking(cnt.getActivity().getApplication());
        } else {
            AppsFlyerLib.getInstance().startTracking(cnt.getActivity().getApplication(), devKey);
        }

        cnt.setDevKey(devKey);

        return null;
    }

}
