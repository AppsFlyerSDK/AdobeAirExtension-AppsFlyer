package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.ServerParameters;


public class GetAdvertiserId implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        FREObject result = null;
        try {
            result = FREObject.newObject(AppsFlyerProperties.getInstance().getString(ServerParameters.ADVERTISING_ID_PARAM));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}
