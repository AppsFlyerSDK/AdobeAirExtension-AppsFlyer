package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetAndroidIdData implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String androidId = "";
        try {
            androidId = freObjects[0].getAsString();
            AppsFlyerLib.getInstance().setAndroidIdData(androidId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;

    }

}
