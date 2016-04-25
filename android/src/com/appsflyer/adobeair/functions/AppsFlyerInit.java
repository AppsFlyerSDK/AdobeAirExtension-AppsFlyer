package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class AppsFlyerInit implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String devKey = "";
        try {
            devKey = freObjects[0].getAsString();
        } catch (Exception e) {
            e.printStackTrace();
        }

        AppsFlyerLib.getInstance().startTracking(freContext.getActivity().getApplication(), devKey);

        return null;
    }

}
