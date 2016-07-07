package com.appsflyer.adobeair.functions;

import android.content.Context;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetGCMProjectNumber implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        String gcmProjectId = "";
        try {
            gcmProjectId = freObjects[0].getAsString();
            AppsFlyerLib.getInstance().setGCMProjectNumber(gcmProjectId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
