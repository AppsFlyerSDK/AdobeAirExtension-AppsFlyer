package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetCollectIMEI implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        Boolean collectIMEI = false;
        try {
            collectIMEI = freObjects[0].getAsBool();
            AppsFlyerLib.getInstance().setCollectIMEI(collectIMEI);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
