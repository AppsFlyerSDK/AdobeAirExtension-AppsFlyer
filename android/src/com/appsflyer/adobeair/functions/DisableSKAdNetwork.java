package com.appsflyer.adobeair.functions;

import static com.appsflyer.adobeair.AppsFlyerContext.LOG;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class DisableSKAdNetwork implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        Log.d(LOG, "disableSKAdNetwork method is not supported on Android");
        return null;
    }
}
