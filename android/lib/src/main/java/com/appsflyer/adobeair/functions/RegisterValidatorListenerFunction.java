package com.appsflyer.adobeair.functions;

import android.content.Context;
import android.util.Log;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerConversionListener;
import com.appsflyer.AppsFlyerInAppPurchaseValidatorListener;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.AppsFlyerContext;
import com.appsflyer.adobeair.Utils;
import org.json.simple.JSONValue;

import java.io.IOException;
import java.io.StringWriter;
import java.util.Map;

public class RegisterValidatorListenerFunction implements FREFunction {

    private final static String TAG = "AppsFlyer";

    @Override
    public FREObject call(final FREContext freContext, FREObject[] freObjects) {


        try {

            final AppsFlyerContext cnt = (AppsFlyerContext) freContext;
            Context context = freContext.getActivity().getApplicationContext();

            AppsFlyerLib.getInstance().registerValidatorListener(context, new AppsFlyerInAppPurchaseValidatorListener() {

                @Override
                public void onValidateInApp() {
                    Log.i(TAG, "Purchase validated successfully");
                    freContext.dispatchStatusEventAsync("validateInApp", "");
                }

                @Override
                public void onValidateInAppFailure(String error) {
                    Log.i(TAG, "onValidateInAppFailure called: " + error);
                    freContext.dispatchStatusEventAsync("validateInAppFailure", error);
                }

            });
        } catch (Exception e) {
            Log.e("AppsFlyer: ", "Exception RegisterConversionListener: " + e);
        }
        return null;
    }

}
