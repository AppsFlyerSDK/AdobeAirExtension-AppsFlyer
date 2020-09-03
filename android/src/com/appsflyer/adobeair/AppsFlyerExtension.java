package com.appsflyer.adobeair;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.appsflyer.AppsFlyerLib;

public class AppsFlyerExtension implements FREExtension {

    public final static String LOG_TAG = "AppsFyer";

    @Override
    public FREContext createContext(String arg0) {
        return new AppsFlyerContext();
    }

    @Override
    public void dispose() {
    }

    @Override
    public void initialize() {
        AppsFlyerLib.getInstance().setExtension("adobe_air");
    }

}
