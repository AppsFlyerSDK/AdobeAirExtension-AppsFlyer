package com.appsflyer.adobeair;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.appsflyer.AppsFlyerLib;

public class SetDeveloperKeyFuncation implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		
		String devKey = "";
		try
		{
			 devKey = arg1[0].getAsString();
		}
		catch(Exception e)
		{
			// log an error if there is no developer key
		}
		
		AppsFlyerLib.setAppsFlyerKey(devKey);
		
		return null;
	}

}
