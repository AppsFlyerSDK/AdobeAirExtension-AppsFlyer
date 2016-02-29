package com.appsflyer.adobeair;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class AppsFlyerExtension implements FREExtension {

    @Override
    public FREContext createContext(String arg0) {
        return new AppsFlyerContext();
    }

    @Override
    public void dispose() {
    }

    @Override
    public void initialize() {
    }

}
