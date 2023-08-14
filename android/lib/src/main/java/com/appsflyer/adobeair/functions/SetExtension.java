package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.AppsFlyerContext;

public class SetExtension implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String type = AppsFlyerContext.EXTENSION_TYPE;
        try {
            type = freObjects[0].getAsString();
        } catch (Exception e) {
            e.printStackTrace();
        }

        AppsFlyerLib.getInstance().setExtension(type);

        return null;
    }
}
