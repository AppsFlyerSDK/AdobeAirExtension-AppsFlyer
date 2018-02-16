package com.appsflyer.adobeair.functions;

import android.content.Context;
import com.adobe.fre.*;
import com.appsflyer.AppsFlyerLib;
import com.appsflyer.adobeair.Utils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.*;

public class TrackEventFunction implements FREFunction {

    @Override
    public FREObject call(FREContext freContext, FREObject[] freObjects) {

        Context context = freContext.getActivity().getApplicationContext();

        String eventName = null;
        String value = null;
        Map<String,Object> eventValues = new HashMap<String, Object>();

        if (freObjects[0] == null) {
            AppsFlyerLib.getInstance().trackEvent(context, eventName, eventValues);
            return null;
        }

        try {
            eventName = freObjects[0].getAsString();
            value = freObjects[1].getAsString();
            JSONObject json = new JSONObject(value);
            eventValues = Utils.jsonToMap(json);
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

        if (eventValues.isEmpty()) {
            if (eventName == null || eventName.isEmpty()) {
                AppsFlyerLib.getInstance().trackEvent(context, null, null);
            } else {
                AppsFlyerLib.getInstance().trackEvent(context, eventName, null);
            }
        } else {
            if (eventName == null || eventName.isEmpty()) {
                AppsFlyerLib.getInstance().trackEvent(context, null, null);
            } else {
                AppsFlyerLib.getInstance().trackEvent(context, eventName, eventValues);
            }
        }
        return null;
    }

}
