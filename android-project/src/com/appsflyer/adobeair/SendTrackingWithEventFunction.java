package com.appsflyer.adobeair;

import android.content.Context;
import com.adobe.fre.*;
import com.appsflyer.AppsFlyerLib;

public class SendTrackingWithEventFunction implements FREFunction {

    @Override
    public FREObject call(FREContext arg0, FREObject[] arg1) {

        Context context = arg0.getActivity().getApplicationContext();

        String eventName = null;
        String eventValue = null;

        if (arg1[0] == null) {
            AppsFlyerLib.sendTrackingWithEvent(context, eventName, eventValue);
            return null;
        }

        try {
            eventName = arg1[0].getAsString();
            eventValue = arg1[1].getAsString();
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
        }

        if (eventValue == null || eventValue.isEmpty()) {
            if (eventName == null || eventName.isEmpty()) {
                AppsFlyerLib.sendTrackingWithEvent(context, null, null);
            } else {
                AppsFlyerLib.sendTrackingWithEvent(context, eventName, null);
            }
        } else {
            if (eventName == null || eventName.isEmpty()) {
                AppsFlyerLib.sendTrackingWithEvent(context, null, null);
            } else {
                AppsFlyerLib.sendTrackingWithEvent(context, eventName, eventValue);
            }
        }
        return null;
    }

}
