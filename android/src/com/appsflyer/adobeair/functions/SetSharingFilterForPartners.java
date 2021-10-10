package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetSharingFilterForPartners implements com.adobe.fre.FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        try {
            FREArray array = (FREArray) freObjects[0];
            String[] filters = new String[(int) array.getLength()];
            for (int i = 0; i < array.getLength(); i++) {
                filters[i] = array.getObjectAt(i).getAsString();
            }
            AppsFlyerLib.getInstance().setSharingFilterForPartners(filters);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
