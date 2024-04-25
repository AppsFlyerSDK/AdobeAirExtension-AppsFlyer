package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerConsent;
import com.appsflyer.AppsFlyerLib;

public class SetConsentForNonGDPRUser implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        try {
            AppsFlyerConsent consent = AppsFlyerConsent.forNonGDPRUser();
            AppsFlyerLib.getInstance().setConsentData(consent);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
