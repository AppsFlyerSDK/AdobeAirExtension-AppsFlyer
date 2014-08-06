package com.appsflyer.adobeair;

import android.content.Context;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SendTrackingFunction implements FREFunction {

    @Override
    public FREObject call(FREContext arg0, FREObject[] arg1) {
        Context context = arg0.getActivity().getApplicationContext();
        AppsFlyerLib.sendTracking(context);
        return null;
    }

}
