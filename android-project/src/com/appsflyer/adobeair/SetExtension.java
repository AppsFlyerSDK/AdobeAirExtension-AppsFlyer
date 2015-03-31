package com.appsflyer.adobeair;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetExtension implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String type = AppsFlyerContext.EXTENSION_TYPE;
        try {
            type = freObjects[0].getAsString();
        } catch (Exception e) {

        }

        AppsFlyerLib.setExtension(type);

        return null;
    }
}
