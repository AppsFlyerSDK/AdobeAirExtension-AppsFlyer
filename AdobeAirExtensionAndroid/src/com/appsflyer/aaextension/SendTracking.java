package com.appsflyer.aaextension;

import android.content.Context;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.appsflyer.AppsFlyerLib;

public class SendTracking implements FREFunction {

	
	
	
	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		
		Context context = arg0.getActivity().getApplicationContext();
		
		System.out.println(AppsFlyerLib.getAppId());
		AppsFlyerLib.sendTracking(context);
		
		try {
			return FREObject.newObject("kadfhakshdfasdfkadfs");
		} catch (FREWrongThreadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
				
	}

}

