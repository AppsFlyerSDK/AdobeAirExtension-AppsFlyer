package com.appsflyer.adobeair.lib;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.util.Log;
import com.appsflyer.AppsFlyerLib;

import java.util.List;

/**
 * Created by IntelliJ IDEA.
 * User: gil
 * Date: 6/10/12
 * Time: 2:57 PM
 * To change this template use File | Settings | File Templates.
 */
public class MultipleInstallBroadcastReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        Log.i(AppsFlyerLib.LOG_TAG,"MultipleInstallBroadcastReceiver called");
        List<ResolveInfo> receivers = context.getPackageManager().queryBroadcastReceivers(new Intent("com.android.vending.INSTALL_REFERRER"), 0);
        for (ResolveInfo resolveInfo : receivers){
            String action = intent.getAction();
            if(resolveInfo.activityInfo.packageName.equals(context.getPackageName())
                    &&  "com.android.vending.INSTALL_REFERRER".equals(action)
                    && !this.getClass().getName().equals(resolveInfo.activityInfo.name)){
                Log.i(AppsFlyerLib.LOG_TAG,"trigger onReceive: class: "+resolveInfo.activityInfo.name);
                try {
                    BroadcastReceiver broadcastReceiver = (BroadcastReceiver) Class.forName(resolveInfo.activityInfo.name).newInstance();
                    broadcastReceiver.onReceive(context,intent);
                } catch (Throwable e) {
                    Log.e(AppsFlyerLib.LOG_TAG,"error in BroadcastReceiver "+resolveInfo.activityInfo.name,e);
                }
            }
        }
        new AppsFlyerLib().onReceive(context,intent);
    }
}
