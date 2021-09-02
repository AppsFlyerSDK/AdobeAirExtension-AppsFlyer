package com.appsflyer.adobeair.functions;

import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class GetAppsFlyerUID implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        FREObject result = null;
        try {
            Context context = freContext.getActivity().getApplicationContext();
            result = FREObject.newObject(AppsFlyerLib.getInstance().getAppsFlyerUID(context));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}
