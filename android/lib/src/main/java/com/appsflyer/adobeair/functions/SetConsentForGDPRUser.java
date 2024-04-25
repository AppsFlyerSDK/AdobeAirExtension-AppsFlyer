package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerConsent;
import com.appsflyer.AppsFlyerLib;

public class SetConsentForGDPRUser implements FREFunction {
    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        Boolean hasConsentForDataUsage = false;
        Boolean hasConsentForAdsPersonalization = false;
        try {
            hasConsentForDataUsage = freObjects[0].getAsBool();
            hasConsentForAdsPersonalization = freObjects[1].getAsBool();
            AppsFlyerConsent consent = AppsFlyerConsent.forGDPRUser(hasConsentForDataUsage, hasConsentForAdsPersonalization);
            AppsFlyerLib.getInstance().setConsentData(consent);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
