package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetImeiData implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String imei = "";
        try {
            imei = freObjects[0].getAsString();
            AppsFlyerLib.getInstance().setImeiData(imei);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;

    }

}
