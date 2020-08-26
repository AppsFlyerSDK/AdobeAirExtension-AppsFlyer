package com.appsflyer.adobeair.functions;

import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import static com.appsflyer.AppsFlyerLibCore.LOG_TAG;

public class WaitForAdvertisingIdentifier implements FREFunction {


    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        Log.d(LOG_TAG, "WaitForAdvertisingIdentifier method is not supported on Android");
        return null;
    }
}
