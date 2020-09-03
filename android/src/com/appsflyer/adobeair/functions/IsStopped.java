package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class IsStopped implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        FREObject result = null;
        try {
            result = FREObject.newObject(AppsFlyerLib.getInstance().isTrackingStopped());
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}
