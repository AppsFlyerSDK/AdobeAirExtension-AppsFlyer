package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;


public class StartWithCUID implements FREFunction {

    private final static String LOG = "AppsFlyer";

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        String id = "";
        try {
            id = freObjects[0].getAsString();
        } catch (Exception e) {
            e.printStackTrace();
        }

        AppsFlyerLib.getInstance().setCustomerIdAndLogSession(id, freContext.getActivity().getApplicationContext());

        return null;
    }

}
