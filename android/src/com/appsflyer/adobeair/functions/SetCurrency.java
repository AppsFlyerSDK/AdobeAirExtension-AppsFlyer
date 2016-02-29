package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetCurrency implements FREFunction {

    @Override
    public FREObject call(FREContext arg0, FREObject[] arg1) {

        String currencyCode = "USD";
        try {
            currencyCode = arg1[0].getAsString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        AppsFlyerLib.getInstance().setCurrencyCode(currencyCode);

        return null;
    }

}
