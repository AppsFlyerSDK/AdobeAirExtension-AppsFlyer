package com.appsflyer.adobeair.functions;

import android.content.Context;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetGCMProjectID implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        String gcmProjectId = "";
        try {
            gcmProjectId = freObjects[0].getAsString();
            Context context = freContext.getActivity().getApplicationContext();
            AppsFlyerLib.getInstance().setGCMProjectID(context, gcmProjectId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
