package com.appsflyer.adobeair;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

/**
 * Created by maksym on 22.07.2014.
 */
public class SetCollectAndroidID implements FREFunction {


    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        Boolean collectAndroidID = false;
        try {
            collectAndroidID = freObjects[0].getAsBool();
            AppsFlyerLib.setCollectAndroidID(collectAndroidID);
        } catch (Exception e) {
        }

        return null;
    }
}
