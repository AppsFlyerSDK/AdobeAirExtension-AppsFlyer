package com.appsflyer.adobeair.functions;

import android.net.Uri;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

import java.net.URI;

public class PerformOnAppAttribution implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] arg1) {

        try {
            String uri = arg1[0].getAsString();
            AppsFlyerLib.getInstance().performOnAppAttribution(freContext.getActivity(), new URI(uri));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

        return null;
    }

}
