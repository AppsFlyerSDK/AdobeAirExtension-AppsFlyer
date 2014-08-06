package com.appsflyer.adobeair;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetAppUserId implements FREFunction {

    @Override
    public FREObject call(FREContext arg0, FREObject[] arg1) {

        String appUserId = "";
        try {
            appUserId = arg1[0].getAsString();
        } catch (Exception e) {
            // log an error if there is no developer key
            return null;
        }
        AppsFlyerLib.setAppUserId(appUserId);

        return null;

    }

}
