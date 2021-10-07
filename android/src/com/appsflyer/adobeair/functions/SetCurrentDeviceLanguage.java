package com.appsflyer.adobeair.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import static com.appsflyer.adobeair.AppsFlyerContext.LOG_TAG;

public class SetCurrentDeviceLanguage implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        Log.d(LOG_TAG, "setCurrentDeviceLanguage method is not supported on Android");
        return null;
    }
}