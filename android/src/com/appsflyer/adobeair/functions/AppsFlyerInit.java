package com.appsflyer.adobeair.functions;

import android.content.Context;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.AppsFlyerContext;

public class AppsFlyerInit implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String devKey = "";
        try {
            devKey = freObjects[0].getAsString();
        } catch (Exception e) {
            e.printStackTrace();
        }

        final AppsFlyerContext cnt = (AppsFlyerContext)freContext;
        cnt.setDevKey(devKey);

        AppsFlyerLib.getInstance().startTracking(freContext.getActivity().getApplication(), devKey);

        return null;
    }

}
