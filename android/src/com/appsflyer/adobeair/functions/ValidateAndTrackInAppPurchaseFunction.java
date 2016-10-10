package com.appsflyer.adobeair.functions;

import android.content.Context;
import android.util.Log;
import com.adobe.fre.*;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.Utils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.*;

public class ValidateAndTrackInAppPurchaseFunction implements FREFunction {

    private final static String LOG = "AppsFlyer";

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        Context context = freContext.getActivity().getApplicationContext();

        try {
            String publicKey = freObjects[0].getAsString();
            String signature = freObjects[1].getAsString();
            String purchaseData = freObjects[2].getAsString();
            String price = freObjects[3].getAsString();
            String currency = freObjects[4].getAsString();
            String additionalParameters = freObjects[5].getAsString();

            JSONObject json = new JSONObject(additionalParameters);
            HashMap<String,String> params = new HashMap<String,String>();
            for (Map.Entry<String, Object> entry : Utils.jsonToMap(json).entrySet()) {
                params.put(entry.getKey(), entry.getValue().toString());
            }

            AppsFlyerLib.getInstance().validateAndTrackInAppPurchase(context, publicKey, signature, purchaseData, price, currency, params);

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
