package com.appsflyer.adobeair.functions;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetUserEmails implements FREFunction {

        @Override
        public FREObject call(FREContext freContext, FREObject[] freObjects) {

            try {
                FREArray array = (FREArray) freObjects[0];

                String[] emails = new String[(int) array.getLength()];
                for (int i = 0; i < array.getLength(); i++) {
                    emails[i] = array.getObjectAt(i).getAsString();
                }

                AppsFlyerLib.getInstance().setUserEmails(emails);
            } catch (Exception e) {
                e.printStackTrace();
            }

            return null;
        }
}

