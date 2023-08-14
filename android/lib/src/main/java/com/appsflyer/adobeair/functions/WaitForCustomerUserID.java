package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class WaitForCustomerUserID implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        Boolean wait = false;
        try {
            wait = freObjects[0].getAsBool();
        } catch (Exception e) {
            e.printStackTrace();
        }

        AppsFlyerLib.getInstance().waitForCustomerUserId(wait);
        return null;
    }
}
