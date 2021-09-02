package com.appsflyer.adobeair.functions;

import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREInvalidObjectException;
import com.adobe.fre.FREObject;
import com.adobe.fre.FRETypeMismatchException;
import com.adobe.fre.FREWrongThreadException;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.Utils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class ValidateAndLogInAppPurchaseFunction implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        Context context = freContext.getActivity().getApplicationContext();

        try {
            String publicKey = freObjects[0].getAsString();
            String signature = freObjects[1].getAsString();
            String purchaseData = freObjects[2].getAsString();
            String price = freObjects[3].getAsString();
            String currency = freObjects[4].getAsString();
            HashMap<String, String> params = new HashMap<String, String>();
            if (freObjects.length > 5) {
                String additionalParameters = freObjects[5] != null ? freObjects[5].getAsString() : null;
                if (additionalParameters != null && !additionalParameters.isEmpty()) {
                    try {
                        JSONObject json = new JSONObject(additionalParameters);
                        for (Map.Entry<String, Object> entry : Utils.jsonToMap(json).entrySet()) {
                            params.put(entry.getKey(), entry.getValue().toString());
                        }
                    } catch (JSONException ex) {
                        ex.printStackTrace();
                    }
                }
            }
            AppsFlyerLib.getInstance().validateAndLogInAppPurchase(context, publicKey, signature, purchaseData, price, currency, params);
        } catch (IllegalStateException e) {
            e.printStackTrace();
        } catch (FRETypeMismatchException e) {
            e.printStackTrace();
        } catch (FREInvalidObjectException e) {
            e.printStackTrace();
        } catch (FREWrongThreadException e) {
            e.printStackTrace();
        } catch (NullPointerException npe) {
            npe.printStackTrace();
        } catch (Throwable t) {
            t.printStackTrace();
        }

        return null;
    }


}
