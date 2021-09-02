package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerLib;

public class SetDebug implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        Boolean debugLog = false;
        try {
            debugLog = freObjects[0].getAsBool();
        } catch (Exception e) {
            e.printStackTrace();
        }

        AppsFlyerLib.getInstance().setLogLevel(debugLog ? AFLogger.LogLevel.VERBOSE : AFLogger.LogLevel.INFO);
        return null;
    }
}
