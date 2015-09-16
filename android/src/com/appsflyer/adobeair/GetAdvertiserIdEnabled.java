package com.appsflyer.adobeair;

import android.content.Context;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.AppsFlyerProperties;
import com.appsflyer.ServerParameters;

/**
 * Created by maksym on 22.07.2014.
 */
public class GetAdvertiserIdEnabled implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        FREObject result = null;
        try {
            result = FREObject.newObject(AppsFlyerProperties.getInstance().getString(ServerParameters.ADVERTISING_ID_ENABLED_PARAM));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return result;
    }
}
