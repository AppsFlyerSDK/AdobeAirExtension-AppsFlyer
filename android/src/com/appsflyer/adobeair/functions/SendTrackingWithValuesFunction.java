package com.appsflyer.adobeair.functions;

import android.content.Context;
import com.adobe.fre.*;
import com.appsflyer.AppsFlyerLib;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.*;

public class SendTrackingWithValuesFunction implements FREFunction {

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
            eventValues = jsonToMap(json);
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
                //AppsFlyerLib.getInstance().sendTrackingWithEvent(context, null, null);
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

    public static Map jsonToMap(JSONObject json) throws JSONException {
        Map<String, Object> retMap = new HashMap<String, Object>();

        if(json != JSONObject.NULL) {
            retMap = toMap(json);
        }
        return retMap;
    }

    public static Map toMap(JSONObject object) throws JSONException {
        Map<String, Object> map = new HashMap<String, Object>();

        Iterator<String> keysItr = object.keys();
        while(keysItr.hasNext()) {
            String key = keysItr.next();
            Object value = object.get(key);

            if(value instanceof JSONArray) {
                value = toList((JSONArray) value);
            }

            else if(value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            map.put(key, value);
        }
        return map;
    }

    public static List toList(JSONArray array) throws JSONException {
        List<Object> list = new ArrayList<Object>();
        for(int i = 0; i < array.length(); i++) {
            Object value = array.get(i);
            if(value instanceof JSONArray) {
                value = toList((JSONArray) value);
            }

            else if(value instanceof JSONObject) {
                value = toMap((JSONObject) value);
            }
            list.add(value);
        }
        return list;
    }

}
