package com.appsflyer.adobeair.functions;

import static com.appsflyer.adobeair.AppsFlyerContext.LOG;

import android.content.Context;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerInAppPurchaseValidatorListener;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.AppsFlyerContext;

public class RegisterValidatorListenerFunction implements FREFunction {
    @Override
    public FREObject call(final FREContext freContext, FREObject[] freObjects) {


        try {

            final AppsFlyerContext cnt = (AppsFlyerContext) freContext;
            Context context = freContext.getActivity().getApplicationContext();

            AppsFlyerLib.getInstance().registerValidatorListener(context, new AppsFlyerInAppPurchaseValidatorListener() {

                @Override
                public void onValidateInApp() {
                    Log.i(LOG, "Purchase validated successfully");
                    freContext.dispatchStatusEventAsync("validateInApp", "");
                }

                @Override
                public void onValidateInAppFailure(String error) {
                    Log.i(LOG, "onValidateInAppFailure called: " + error);
                    freContext.dispatchStatusEventAsync("validateInAppFailure", error);
                }

            });
        } catch (Exception e) {
            Log.e("AppsFlyer: ", "Exception RegisterConversionListener: " + e);
        }
        return null;
    }

}
