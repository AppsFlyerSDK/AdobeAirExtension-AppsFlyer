package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SendDeepLinkData implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {
        AppsFlyerLib.getInstance().sendDeepLinkData(freContext.getActivity());
        return null;
    }

}
