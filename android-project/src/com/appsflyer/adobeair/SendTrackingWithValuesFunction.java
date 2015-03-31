package com.appsflyer.adobeair;

import android.content.Context;
import com.adobe.fre.*;
import com.appsflyer.AppsFlyerLib;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.*;

public class SendTrackingWithValuesFunction implements FREFunction {

    @Override
    public FREObject call(FREContext arg0, FREObject[] arg1) {

        Context context = arg0.getActivity().getApplicationContext();

        String eventName = null;
        String value = null;
        Map<String,Object> eventValues = new HashMap<String, Object>();

        if (arg1[0] == null) {
            AppsFlyerLib.sendTrackingWithEvent(context, eventName, value);
            return null;
        }

        try {
            eventName = arg1[0].getAsString();
            value = arg1[1].getAsString();
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
                AppsFlyerLib.sendTrackingWithEvent(context, null, null);
            } else {
                AppsFlyerLib.sendTrackingWithEvent(context, eventName, null);
            }
        } else {
            if (eventName == null || eventName.isEmpty()) {
                AppsFlyerLib.sendTrackingWithEvent(context, null, null);
            } else {
                AppsFlyerLib.trackEvent(context, eventName, eventValues);
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
