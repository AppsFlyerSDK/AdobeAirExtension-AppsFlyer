package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class EnableTCFDataCollection implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        Boolean enableTCFDataCollection = false;
        try {
            enableTCFDataCollection = freObjects[0].getAsBool();
            AppsFlyerLib.getInstance().enableTCFDataCollection(enableTCFDataCollection);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
