package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetCustomerUserId implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        try {
            String userId = freObjects[0].getAsString();
            AppsFlyerLib.getInstance().setCustomerUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }


        return null;
    }

}
