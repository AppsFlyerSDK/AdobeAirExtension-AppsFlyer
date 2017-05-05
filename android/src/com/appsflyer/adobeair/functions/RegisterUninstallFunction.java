package com.appsflyer.adobeair.functions;


import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class RegisterUninstallFunction implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        try {
            AppsFlyerLib.getInstance().enableUninstallTracking(freObjects[0].getAsString());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}