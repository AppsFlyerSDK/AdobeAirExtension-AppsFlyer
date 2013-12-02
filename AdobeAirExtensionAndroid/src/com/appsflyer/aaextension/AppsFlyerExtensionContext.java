package com.appsflyer.aaextension;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class AppsFlyerExtensionContext extends FREContext {

	@Override
	public void dispose() {
		// TODO Auto-generated method stub

	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		
		Map<String, FREFunction> functions = new HashMap<String, FREFunction>();
		
		functions.put("setDeveloperKey", new SetDevelopmentKey());
		functions.put("sendTracking", new SendTracking());
		
		return functions;

	}

}
