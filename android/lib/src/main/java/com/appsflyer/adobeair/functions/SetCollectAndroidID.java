package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetCollectAndroidID implements FREFunction {


    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        Boolean collectAndroidID = false;
        try {
            collectAndroidID = freObjects[0].getAsBool();
            AppsFlyerLib.getInstance().setCollectAndroidID(collectAndroidID);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
