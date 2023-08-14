package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetDisableAdvertisingIdentifiers implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        Boolean disable = false;
        try {
            disable = freObjects[0].getAsBool();
        } catch (Exception e) {
            e.printStackTrace();
        }
        AppsFlyerLib.getInstance().setDisableAdvertisingIdentifiers(disable);
        return null;
    }
}