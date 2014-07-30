package com.appsflyer.adobeair.lib;

import java.util.Map;

/**
 * Created by IntelliJ IDEA.
 * User: gilmeroz
 * Date: 6/13/13
 * Time: 10:03 AM
 * To change this template use File | Settings | File Templates.
 */
public interface ReferrerListener {
    void onReferrerReceived(Map<String,String> conversionData);
    void onReferrerNotFound();

}
