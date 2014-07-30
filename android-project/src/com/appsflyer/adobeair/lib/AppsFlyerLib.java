package com.appsflyer.adobeair.lib;

import java.io.*;
import java.lang.ref.WeakReference;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import android.content.*;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.ConnectivityManager;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.telephony.TelephonyManager;
import android.util.Log;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import org.json.JSONException;
import org.json.JSONObject;

public class AppsFlyerLib extends BroadcastReceiver
{

    public static final String SERVER_BUILD_NUMBER = "2.3";
    public static final String SDK_BUILD_NUMBER = "1.3";
    public static final String LOG_TAG = "AppsFlyer_"+SDK_BUILD_NUMBER;
    public static final String APPS_TRACKING_URL = "https://track.appsflyer.com/api/v"+SERVER_BUILD_NUMBER+"/androidevent?buildnumber="+SDK_BUILD_NUMBER+"&app_id=";

    private static final String INSTALL_UPDATE_DATE_FORMAT = "yyyy-MM-dd_hhmmZ";

    protected static final String AF_SHARED_PREF = "appsflyer-data";
    static final String SENT_SUCCESSFULLY_PREF = "sentSuccessfully";
    static final String AF_COUNTER_PREF = "appsFlyerCount";
    static final String FIRST_INSTALL_PREF = "appsFlyerFirstInstall";
    protected static final String REFERRER_PREF = "referrer";
    static final String ATTRIBUTION_ID_PREF = "attributionId";
    private static final String ON_RECIEVE_CALLED = "onRecieve called. refferer=";
    private static final String PREPARE_DATA_ACTION = "collect data for server";
    private static final String CALL_SERVER_ACTION = "call server.";
    private static final String SERVER_RESPONDED_ACTION = "response from server. status=";

    public static final Uri ATTRIBUTION_ID_CONTENT_URI = Uri.parse("content://com.facebook.katana.provider.AttributionIdProvider");

    public static final String ATTRIBUTION_ID_COLUMN_NAME = "aid";

    private static final String WARNING_PREFIX = "WARNING:";
    private static final String ERROR_PREFIX = "ERROR:";
    private static final String CACHED_CHANNEL_PREF = "CACHED_CHANNEL";

    private static ConversionDataListener conversionDataListener = null;
    private static String extension;

    public static void setExtension(String extension) {
        AppsFlyerLib.extension = extension;
    }

    public static String getExtension() {
        return extension;
    }

    @Override
    public void onReceive(Context context, Intent intent) {


        Log.i(LOG_TAG, "****** onReceive called *******");
        debugAction("******* onReceive: ","",context);

        AppsFlyerProperties.getInstance().setOnReceiveCalled();

        String referrer = intent.getStringExtra("referrer");
        Log.i(LOG_TAG, "referrer=" + referrer);
        if(referrer != null) {
            debugAction("BroadcastReceiver got referrer: ",referrer,context);
            debugAction(ON_RECIEVE_CALLED,referrer,context);
            SharedPreferences sharedPreferences = context.getSharedPreferences(AF_SHARED_PREF, 0);
            android.content.SharedPreferences.Editor editor = sharedPreferences.edit();
            editor.putString(REFERRER_PREF, referrer);
            editor.commit();
            // set in memory value in case the shared pref will not be sync on time
            AppsFlyerProperties.getInstance().setReferrer(referrer);

            if  (AppsFlyerProperties.getInstance().isLaunchCalled()){ // send to server only if it's after the onCreate call
                sendTrackingWithEvent(context, "", null, null, referrer);
            }
        }
    }

    private static void debugAction(String actionMsg, String parameter,Context context) {
        if (context != null && "com.appsflyer".equals(context.getPackageName())){
            DebugLogQueue.getInstance().push(actionMsg+parameter);
        }
    }


    public static void setProperty(String key,String value){
        AppsFlyerProperties.getInstance().set(key,value);
    }

    public static String getProperty(String key){
        return AppsFlyerProperties.getInstance().get(key);
    }

    public static void setAppUserId(String id){
        setProperty(AppsFlyerProperties.APP_USER_ID, id);
    }

    public static void setUseHTTPFalback(boolean isUseHttp){
        setProperty(AppsFlyerProperties.USE_HTTP_FALLBACK, Boolean.toString(isUseHttp));
    }

    public static void setCollectAndroidID(boolean isCollect){
        setProperty(AppsFlyerProperties.COLLECT_ANDROID_ID, Boolean.toString(isCollect));
    }

    public static void setCollectMACAddress(boolean isCollect){
        setProperty(AppsFlyerProperties.COLLECT_MAC, Boolean.toString(isCollect));
    }

    public static void setCollectIMEI(boolean isCollect){
        setProperty(AppsFlyerProperties.COLLECT_IMEI, Boolean.toString(isCollect));
    }

    public static void setAppsFlyerKey(String key){
        setProperty(AppsFlyerProperties.AF_KEY, key);
    }

    public static String getAppUserId(){
        return getProperty(AppsFlyerProperties.APP_USER_ID);
    }

    public static void setAppId(String id) {
        setProperty(AppsFlyerProperties.APP_ID, id);
    }

    public static String getAppId() {
        return getProperty(AppsFlyerProperties.APP_ID);
    }

    public static void setIsUpdate(boolean isUpdate) {
        AppsFlyerProperties.getInstance().set(AppsFlyerProperties.IS_UPDATE, isUpdate);
    }

    public static void setCurrencyCode(String currencyCode){
        AppsFlyerProperties.getInstance().set(AppsFlyerProperties.CURRENCY_CODE, currencyCode);
    }

    public static void sendTracking(Context context) {
        sendTracking(context, null);
        AppsFlyerProperties.getInstance().setLaunchCalled();
    }

    public static void setDeviceTrackingDisabled(boolean isDisabled){
        AppsFlyerProperties.getInstance().set(AppsFlyerProperties.DEVICE_TRACKING_DISABLED, isDisabled);
    }

    @Deprecated
    public static void sendTracking(Context context,String appsFlyerKey) {
        sendTrackingWithEvent(context, appsFlyerKey, null, null);
    }

    public static void sendTrackingWithEvent(Context context,String eventName,String eventValue) {
        sendTrackingWithEvent(context,null,eventName,eventValue);
    }

    /*
     If referrer exist it is returned. Otherwise, return the cached attribution data
     */
    public static Map<String,String> getConversionData(Context context) throws AttributionIDNotReady {
        SharedPreferences sharedPreferences = context.getSharedPreferences(AF_SHARED_PREF, 0);
        String referrer = AppsFlyerProperties.getInstance().getReferrer(context);
        if (referrer != null && referrer.length() > 0 && referrer.contains("af_tranid")){
            return referrerStringToMap(referrer);
        }
        String attributionString = sharedPreferences.getString(ATTRIBUTION_ID_PREF,null);

        if (attributionString != null && attributionString.length() > 0){
            return attributionStringToMap(attributionString);
        } else {
            throw new AttributionIDNotReady();
        }
    }

    public static void getConversionData(Context context, ConversionDataListener conversionDataListener) {
        if (conversionDataListener == null){
            return;
        }
        try {
            Map<String,String> conversionData = getConversionData(context);
            try {
                conversionDataListener.onConversionDataLoaded(conversionData);
            } catch (Exception e){
                Log.e(LOG_TAG,"error in onConversionDataLoaded",e);
            }
        } catch (AttributionIDNotReady attributionIDNotReady) {
            AppsFlyerLib.conversionDataListener = conversionDataListener;
        }
    }

    private static Map<String, String> referrerStringToMap(String referrer) {
        Map<String,String>  conversionData = new HashMap<String,String>();
        int separator = referrer.indexOf('&');
        if (separator >= 0 && referrer.length() > separator+1){
            String[] params = referrer.split("\\&");
            for (String param : params) {
                String[] keyAndValue = param.split("=");
                String name = keyAndValue[0];
                String value = keyAndValue.length > 1 ? keyAndValue[1] : "";
                conversionData.put(name, value);
            }
        }
        return conversionData;
    }

    private static Map<String,String> attributionStringToMap(String inputString){
        Map<String,String> conversionData = new HashMap<String, String>();

        try {
            JSONObject jsonObject = new JSONObject(inputString);
            Iterator iterator = jsonObject.keys();
            while (iterator.hasNext()){
                String key = (String) iterator.next();
                conversionData.put(key,jsonObject.getString(key));
            }
        } catch(JSONException e) {
            Log.w(LOG_TAG,e);
            return null;
        }

        return conversionData;
    }

    public static void sendTrackingWithEvent(Context context,String appsFlyerKey,String eventName,String eventValue) {
        String referrer = AppsFlyerProperties.getInstance().getReferrer(context);
        runInBackground(context, appsFlyerKey, eventName, eventValue, referrer == null ? "" : referrer);
    }

    private static void runInBackground(Context context,String appsFlyerKey,String eventName,String eventValue,String referrer){
        ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
        scheduler.schedule(new DataCollector(context,appsFlyerKey,eventName,eventValue,referrer),5, TimeUnit.MILLISECONDS);

    }

    private static void sendTrackingWithEvent(Context context,String appsFlyerKey,String eventName,String eventValue,String referrer) {
        try{
            Log.i(LOG_TAG, LogMessages.START_LOG_MESSAGE+context.getPackageName());
            debugAction(PREPARE_DATA_ACTION,"",context);

            Log.i(LOG_TAG,"******* sendTrackingWithEvent: ");
            debugAction("********* sendTrackingWithEvent: ",eventName,context);

            try {
                // permissions
                PackageInfo packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), PackageManager.GET_PERMISSIONS);
                List<String> requestedPermissions = Arrays.asList(packageInfo.requestedPermissions);
                if (!requestedPermissions.contains("android.permission.INTERNET")){
                    Log.w(LOG_TAG,"Permission android.permission.INTERNET is missing in the AndroidManifest.xml");
                }
                if (!requestedPermissions.contains("android.permission.ACCESS_NETWORK_STATE")){
                    Log.w(LOG_TAG,"Permission android.permission.ACCESS_NETWORK_STATE is missing in the AndroidManifest.xml");
                }
                if (!requestedPermissions.contains("android.permission.ACCESS_WIFI_STATE")){
                    Log.w(LOG_TAG,"Permission android.permission.ACCESS_WIFI_STATE is missing in the AndroidManifest.xml");
                }
            } catch (Exception e){
                //ignore
            }

            StringBuilder urlString = new StringBuilder();
            urlString.append(APPS_TRACKING_URL).append(context.getPackageName());

            Map<String,String> params = new HashMap<String, String>();
            params.put("brand",android.os.Build.BRAND);
            params.put("device",android.os.Build.DEVICE);
            params.put("product",android.os.Build.PRODUCT); // key was brand
            params.put("sdk",Integer.toString(android.os.Build.VERSION.SDK_INT));
            params.put("model",Build.MODEL);
            params.put("deviceType",Build.TYPE);

            String currentChannel = getConfiguredChannel(context);

            String originalChannel = getCachedChannel(context,currentChannel);
            if (originalChannel != null){
                params.put(ServerParameters.CHANNEL_SERVER_PARAM,originalChannel);
            }

            if (originalChannel != null && !originalChannel.equals(currentChannel)
                    || originalChannel == null && currentChannel != null){
                params.put(ServerParameters.LATEST_CHANNEL_SERVER_PARAM,currentChannel);
            }

            String afKEy = appsFlyerKey;
            if (afKEy == null){
                afKEy = getProperty(AppsFlyerProperties.AF_KEY);
            }
            if (afKEy != null){
                params.put(ServerParameters.AF_DEV_KEY,afKEy);
                if (afKEy.length() > 8){
                    params.put("dkh",afKEy.substring(0,8));
                }
            } else {
                Log.e(LOG_TAG,"AppsFlyer dev key is missing!!! Please use  AppsFlyerLib.setAppsFlyerKey(...) to set it. ");
                Log.e(LOG_TAG,"AppsFlyer will not track this event.");
                return;
            }

            String appUserId = getAppUserId();
            if (appUserId != null){
                params.put("appUserId",appUserId);
            }

            if (eventName != null && eventValue != null){
                params.put("eventName",eventName);
                params.put("eventValue",eventValue);
            }

            if(getProperty(AppsFlyerProperties.APP_ID) != null) {
                params.put("appid", getProperty(AppsFlyerProperties.APP_ID));
            }
            String currencyCode = getProperty(AppsFlyerProperties.CURRENCY_CODE);
            if(currencyCode != null) {
                if(currencyCode.length() != 3)  {
                    Log.w(LOG_TAG, (new StringBuilder()).append(WARNING_PREFIX + "currency code should be 3 characters!!! '").append(currencyCode).append("' is not a legal value.").toString());
                }
                params.put("currency", currencyCode);
            }

            String isUpdate = getProperty(AppsFlyerProperties.IS_UPDATE);
            if(isUpdate != null) {
                params.put("isUpdate", isUpdate);
            }
            boolean isPreInstall = isPreInstalledApp(context);
            params.put("af_preinstalled",Boolean.toString(isPreInstall));

            String facebookAttributeId = getAttributionId(context.getContentResolver());
            if (facebookAttributeId != null){
                params.put("fb",facebookAttributeId);
            }

            boolean deviceTrackingDisabled = AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.DEVICE_TRACKING_DISABLED,false);

            if (deviceTrackingDisabled){
                params.put("deviceTrackingDisabled","true");
            }

            boolean collectIMEI = AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.COLLECT_IMEI,true);
            if (collectIMEI){
                try {
                    TelephonyManager manager = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
                    String imei = manager.getDeviceId();
                    if(imei != null) {
                        params.put("imei", imei);
                    }
                } catch(Exception e) {
                    //  ignore
                    Log.w(LOG_TAG,WARNING_PREFIX+"READ_PHONE_STATE is missing");
                }
            }

            boolean collectAndroidId = AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.COLLECT_ANDROID_ID,true);
            if (collectAndroidId){
                try
                {
                    String androidId = Settings.Secure.getString(context.getContentResolver(),Settings.Secure.ANDROID_ID);
                    if(androidId != null) {
                        params.put("android_id", androidId);
                    }
                } catch(Exception e) {
                    // ignore
                }
            }
            try {
                String uid = Installation.id(context);
                if(uid != null)
                    params.put(ServerParameters.AF_USER_ID, uid);
            }
            catch(Exception e){
                Log.i(LOG_TAG, (new StringBuilder()).append(ERROR_PREFIX).append(ERROR_PREFIX).append("could not get uid ").append(e.getMessage()).toString());
            }

            try {
                params.put("lang", Locale.getDefault().getDisplayLanguage());
            } catch(Exception e) {
                // ignore
            }
            try {
                TelephonyManager manager = (TelephonyManager) context.getSystemService("phone");
                params.put("operator",manager.getSimOperatorName());
                params.put("carrier",manager.getNetworkOperatorName());
            } catch (Exception e){
                // ignore
            }

            try {
                params.put("network",getNetwork(context));
            } catch (Exception e){
                Log.i(LOG_TAG,"checking network error "+e.getMessage());
            }

            boolean collectMAC = AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.COLLECT_MAC,true);
            if (collectMAC){
                try {
                    WifiManager wifiMan = (WifiManager) context.getSystemService(Context.WIFI_SERVICE);
                    WifiInfo wifiInf = wifiMan.getConnectionInfo();
                    String macAddress = wifiInf.getMacAddress();
                    if (macAddress != null){
                        params.put("mac",macAddress);
                    }
                } catch (Exception e){
                    // ignore
                }
            }

            addAdvertiserIDData(context,params);

            SimpleDateFormat dateFormat = new SimpleDateFormat(INSTALL_UPDATE_DATE_FORMAT);
            if (android.os.Build.VERSION.SDK_INT >= 9 ){
                try {
                    long installed = context.getPackageManager().getPackageInfo(context.getPackageName(), 0).firstInstallTime;
                    params.put("installDate",dateFormat.format(new Date(installed)));
                } catch (Exception e){
                    // ignore
                }
            }

            try {
                PackageInfo packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
                params.put("app_version_code",Integer.toString(packageInfo.versionCode));
                params.put("app_version_name", packageInfo.versionName);

                // ***Note this will work only on android 9 and above!!!!!!!!!!!!!!!!!!!!!!!!
                long firstInstallTime = packageInfo.firstInstallTime;
                long lastUpdateTime = packageInfo.lastUpdateTime;
                params.put("date1",dateFormat.format(new Date(firstInstallTime)));
                params.put("date2",dateFormat.format(new Date(lastUpdateTime)));
                String firstInstallDate = getFirstInstallDate(dateFormat,context);
                params.put("firstLaunchDate",firstInstallDate);
            } catch(android.content.pm.PackageManager.NameNotFoundException e) {
                // ignore
            } catch (NoSuchFieldError e){
                // ignore
            }

            if (referrer.length() > 0){
                params.put("referrer",referrer);
            }

            SharedPreferences sharedPreferences = context.getSharedPreferences(AF_SHARED_PREF, 0);
            String attributionString = sharedPreferences.getString(ATTRIBUTION_ID_PREF,null);
            if (attributionString != null && attributionString.length() > 0){
                params.put("installAttribution",attributionString);
            }
            ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
            scheduler.schedule(new SendToServerRunnable(urlString.toString(),params,context.getApplicationContext()),100, TimeUnit.MILLISECONDS);

        }catch (Throwable e) {
            Log.e(LOG_TAG,"",e);
        }
    }

    private static String getConfiguredChannel(Context context) {

        String channel = AppsFlyerProperties.getInstance().get(AppsFlyerProperties.CHANNEL);
        if (channel == null){
            try {
                ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
                Bundle bundle = applicationInfo.metaData;
                if (bundle != null){
                    Object channelObj = bundle.get("CHANNEL");
                    if (channelObj != null){
                        channel =  channelObj instanceof String ? (String)channelObj : channelObj.toString();
                    }
                }
            } catch (Exception e){
                Log.e(LOG_TAG,"Could not load CHANNEL value",e);
            }
        }
        return channel;
    }

    public static boolean isPreInstalledApp(Context context) {

        try {
            ApplicationInfo applicationInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(), 0);
            // FLAG_SYSTEM is only set to system applications,
            // this will work even if application is installed in external storage

            // Check if package is system app
            if ((applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) != 0) {
                return true;
            }
        } catch (PackageManager.NameNotFoundException e) {
            Log.e(LOG_TAG,"Could not check if app is pre installed",e);
        }
        return false;
    }

    private static String getCachedChannel(Context context,String currentChannel) throws PackageManager.NameNotFoundException {
        SharedPreferences sharedPreferences = context.getSharedPreferences(AF_SHARED_PREF, 0);
        if (sharedPreferences.contains(CACHED_CHANNEL_PREF)) {
            return sharedPreferences.getString(CACHED_CHANNEL_PREF,null);
        } else {
            SharedPreferences.Editor editor = sharedPreferences.edit();
            editor.putString(CACHED_CHANNEL_PREF,currentChannel);
            editor.commit();
            return currentChannel;
        }
    }

    private static String getFirstInstallDate(SimpleDateFormat dateFormat,Context context) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(AF_SHARED_PREF, 0);
        String firstLaunchDate = sharedPreferences.getString(FIRST_INSTALL_PREF,null);
        if (firstLaunchDate == null) {
            int counter = sharedPreferences.getInt(AF_COUNTER_PREF,1);
            if (counter < 2){
                Log.d(LOG_TAG,"AppsFlyer: first launch detected");
                firstLaunchDate = dateFormat.format(new Date());
            } else {
                firstLaunchDate = ""; // unkown
            }
            SharedPreferences.Editor editor = sharedPreferences.edit();
            editor.putString(FIRST_INSTALL_PREF,firstLaunchDate);
            editor.commit();
        }
        Log.i(LOG_TAG,"AppsFlyer: first launch date: "+firstLaunchDate);

        return firstLaunchDate;
    }

    private static void addAdvertiserIDData(Context context, Map<String, String> params) {
        try {
            Class.forName("com.google.android.gms.ads.identifier.AdvertisingIdClient");
            AdvertisingIdClient.Info adInfo = AdvertisingIdClient.getAdvertisingIdInfo(context);
            params.put("advertiserId",adInfo.getId());
            params.put("advertiserIdEnabled", Boolean.toString(!adInfo.isLimitAdTrackingEnabled()));
        } catch (ClassNotFoundException e){
            Log.i(LOG_TAG,WARNING_PREFIX+"Google Play services SDK is missing.");
        } catch (Exception e){
            if (e.getLocalizedMessage() != null){
                Log.i(LOG_TAG,e.getLocalizedMessage());
            } else {
                Log.i(LOG_TAG,e.toString());
            }
            //
            debugAction("Could not fetch advertiser id: ", e.getLocalizedMessage(), context);
        }
    }


    public static String getAttributionId(ContentResolver contentResolver) {
         String [] projection = {ATTRIBUTION_ID_COLUMN_NAME};
         Cursor cursor  = contentResolver.query(ATTRIBUTION_ID_CONTENT_URI, projection, null, null, null);
         String attributionId = null;
         if (cursor == null || !cursor.moveToFirst()) {
             return null;
         } else {
             try {
                attributionId = cursor.getString(cursor.getColumnIndex(ATTRIBUTION_ID_COLUMN_NAME));
             } catch (Exception e){
                 Log.w(LOG_TAG,e);
             } finally {
                 try {
                    cursor.close();
                 } catch (Exception e){
                     // nothing we can do
                 }
             }
         }

         return attributionId;
     }

    private static String getNetwork(Context context){
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
//mobile
        final android.net.NetworkInfo wifi = connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
        if (wifi.isConnectedOrConnecting()) {
            return "WIFI";
        }
        final android.net.NetworkInfo mobile = connectivityManager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
        if (mobile.isConnectedOrConnecting()) {
            return "MOBILE";
        }
        return "unkown";
    }

    public static String getAppsFlyerUID(Context context){
        return Installation.id(context);
    }

    private static class DataCollector implements Runnable {

        private Context context;
        private String appsFlyerKey;
        private String eventName;
        private String eventValue;
        private String referrer;

        private DataCollector(Context context, String appsFlyerKey, String eventName, String eventValue, String referrer) {
            this.context = context;
            this.appsFlyerKey = appsFlyerKey;
            this.eventName = eventName;
            this.eventValue = eventValue;
            this.referrer = referrer;
        }

        public void run() {
            sendTrackingWithEvent(context,appsFlyerKey,eventName,eventValue,referrer);
        }
    }

    private static class SendToServerRunnable implements Runnable{

        private String urlString;
        private WeakReference<Context> ctxReference = null;
        Map<String,String> params;


        private SendToServerRunnable(String urlString,
                                     Map<String, String> params, Context ctx) {
            this.urlString = urlString;
            this.params = params;
            this.ctxReference = new WeakReference<Context>(ctx);
        }

        public void run() {
            try {
                Context context = ctxReference.get();
                boolean sentSuccessfully = false;
                if (context != null){
                    String referrer = AppsFlyerProperties.getInstance().getReferrer(context);
                    if (referrer != null && referrer.length() > 0 && params.get("referrer") == null){
                        //referrer exist in storage but not in the URL - we need to add it
                        params.put("referrer",referrer);
                    }
                    SharedPreferences sharedPreferences = context.getSharedPreferences(AF_SHARED_PREF, 0);
                    sentSuccessfully = "true".equals(sharedPreferences.getString(SENT_SUCCESSFULLY_PREF,""));

                    params.put("counter",Integer.toString(sharedPreferences.getInt(AF_COUNTER_PREF,1)));
                }
                params.put("isFirstCall",Boolean.toString(!sentSuccessfully));
                params.put(ServerParameters.TIMESTAMP,Long.toString(new Date().getTime()));

                String afDevKey = params.get(ServerParameters.AF_DEV_KEY);
                if (afDevKey == null || afDevKey.length() == 0){
                    Log.d(LOG_TAG,"Not sending data yet, waiting for dev key");
                    return;
                }
                // for verification against frauds
                String hash = new HashUtils().getHashCode(params);
                params.put("af_v",hash);

                StringBuilder postData = new StringBuilder();
                for (String key : params.keySet()){
                    String value = params.get(key);
                    value = value == null ? "" : URLEncoder.encode(value,"UTF-8");
                    if (postData.length() > 0){
                        postData.append('&');
                    }
                    postData.append(key).append('=').append(value);
                }


                String postDataString = postData.toString();

                URL url = new URL(urlString);
                Log.i(LOG_TAG,"url: "+url.toString());
                debugAction(CALL_SERVER_ACTION,"\n"+url.toString()+"\nPOST:"+postDataString,context);
                Log.i(LOG_TAG,"data: "+postDataString);

                try {
                    callServer(url,postDataString,afDevKey);
                } catch (IOException e){
                //    Log.d(LOG_TAG, "", e);
                    boolean useHttpFallback = AppsFlyerProperties.getInstance().getBoolean(AppsFlyerProperties.USE_HTTP_FALLBACK,true);
                    if (useHttpFallback){
                        debugAction("https failed: "+e.getLocalizedMessage(),"",context);
                        callServer(new URL(urlString.replace("https:","http:")),postDataString,afDevKey);
                    } else {
                        Log.i(LOG_TAG,"failed to send requeset to server. "+e.getLocalizedMessage());
                    }
                }
            } catch (Throwable t){
                Log.e(LOG_TAG,t.getMessage(),t);
            }
        }

        private void callServer(URL url,String postData,String appsFlyerDevKey) throws IOException {
            Context context = ctxReference.get();

            HttpURLConnection connection = null;
            try {
                connection = (HttpURLConnection)url.openConnection();

                connection.setRequestMethod("POST");
                int contentLength = postData.getBytes().length;
                connection.setRequestProperty("Content-Length", contentLength + "");
                connection.setRequestProperty("Connection","close");
                connection.setConnectTimeout(10000);
                connection.setDoOutput(true);
                OutputStreamWriter out = null;
                try {
                    out = new OutputStreamWriter(connection.getOutputStream());
                    out.write(postData);
                } finally {
                    if (out != null){
                        out.close();
                    }
                }
                int statusCode = connection.getResponseCode();
                Log.i(LOG_TAG,"response code: "+statusCode);
                debugAction(SERVER_RESPONDED_ACTION,Integer.toString(statusCode),context);
                SharedPreferences sharedPreferences = context.getSharedPreferences(AF_SHARED_PREF, 0);
                if (statusCode == HttpURLConnection.HTTP_OK) {
                    if (ctxReference.get() != null){
                        // we get it again just to be sure the context still exist.
                        android.content.SharedPreferences.Editor editor = sharedPreferences.edit();
                        editor.putString(SENT_SUCCESSFULLY_PREF,"true");
                        int counter = sharedPreferences.getInt(AF_COUNTER_PREF,1);
                        editor.putInt(AF_COUNTER_PREF,++counter);
                        editor.commit();
                    }
                }
                //  Comment out until the server will support attribution id
                if (sharedPreferences.getString(ATTRIBUTION_ID_PREF,null) == null && appsFlyerDevKey != null){
                    // Out of store
                    ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

                    scheduler.schedule(new AttributionIdFetcher(context.getApplicationContext(),appsFlyerDevKey),10, TimeUnit.MILLISECONDS);// it used to be 5000 but as the server have the delay I canceled it
                } else if (appsFlyerDevKey == null){
                    Log.w(LOG_TAG,"AppsFlyer dev key is missing.");
                }
            } finally {
                if (connection != null){
                    connection.disconnect();
                }
            }
        }


    }

    private static class AttributionIdFetcher implements Runnable {

        private static final String AF_ATTRIBUTION_ID_URI = "https://api.appsflyer.com/install_data/v2/";
//        private static final String AF_ATTRIBUTION_ID_URI = "https://api.appsflyer.com/install_data/v2/";
        private WeakReference<Context> ctxReference = null;
        private String appsFlyerDevKey;

        private static AtomicInteger currentRequestsCounter = new AtomicInteger(0);

        public AttributionIdFetcher(Context context,String appsFlyerDevKey) {
            this.ctxReference = new WeakReference<Context>(context);
            this.appsFlyerDevKey = appsFlyerDevKey;
        }

        public void run() {
            if (appsFlyerDevKey == null || appsFlyerDevKey.length() == 0){
                return;
            }
            currentRequestsCounter.incrementAndGet();
            HttpURLConnection connection = null;
            try {
                Context context = ctxReference.get();
                if (context == null){
                    return;
                }

                String channel = getCachedChannel(context,getConfiguredChannel(context));
                String channelPostfix = "";
                if (channel != null){
                    channelPostfix = "-"+channel;
                }
                StringBuilder urlString = new StringBuilder()
                        .append(AF_ATTRIBUTION_ID_URI)
                        .append(context.getPackageName())
                        .append(channelPostfix)
                        .append("?devkey=").append(appsFlyerDevKey)
                        .append("&device_id=").append(getAppsFlyerUID(context));
                Log.i(LOG_TAG,"Calling server for attribution url: "+urlString.toString());
                connection= (HttpURLConnection)new URL(urlString.toString()).openConnection();

                connection.setRequestMethod("GET");
                connection.setConnectTimeout(10000);
                connection.setRequestProperty("Connection","close");
                connection.connect();

                if (connection.getResponseCode() == HttpURLConnection.HTTP_OK) {
                    // read the output from the server
                    BufferedReader reader = null;
                    StringBuilder stringBuilder = new StringBuilder();
                    InputStreamReader inputStreamReader = null;
                    try {
                        inputStreamReader = new InputStreamReader(connection.getInputStream());
                        reader = new BufferedReader(inputStreamReader);

                        String line = null;
                        while ((line = reader.readLine()) != null) {
                            stringBuilder.append(line).append('\n');
                        }
                    } finally {
                        if (reader != null){
                            reader.close();
                        }
                        if (inputStreamReader != null){
                            inputStreamReader.close();
                        }
                    }
                    Log.i(LOG_TAG,"Attribution data: "+stringBuilder.toString());
                    if (stringBuilder.length() > 0 && context != null){
                        Map<String,String> conversionDataMap = attributionStringToMap(stringBuilder.toString());
                        String isCache = conversionDataMap.get("iscache");

                        // DO NOT cache is the server return iscache=false;
                        if (isCache == null || "true".equals(isCache)){
                            SharedPreferences sharedPreferences = context.getSharedPreferences(AF_SHARED_PREF, 0);
                            // we get it again just to be sure the context still exist.
                            android.content.SharedPreferences.Editor editor = sharedPreferences.edit();
                            editor.putString(ATTRIBUTION_ID_PREF,stringBuilder.toString());
                            editor.commit();
                            Log.d(LOG_TAG,"iscache="+isCache+" caching conversion data");
                        }
                        if (AppsFlyerLib.conversionDataListener != null){
                            if (currentRequestsCounter.intValue() <= 1){ // if we had 2 requests from onReceive and from onCreate we wait for the last one which should be he none organic
                                AppsFlyerLib.conversionDataListener.onConversionDataLoaded(getConversionData(context));
                            }
                        }
                    }

                } else {
                    if (AppsFlyerLib.conversionDataListener != null){
                        AppsFlyerLib.conversionDataListener.onConversionFailure("Error connection to server: "+connection.getResponseCode());
                    }
                    Log.i(LOG_TAG,"AttributionIdFetcher response code: "+connection.getResponseCode()+"  url: "+urlString);
                }
            } catch (Throwable t){
                if (AppsFlyerLib.conversionDataListener != null){
                    AppsFlyerLib.conversionDataListener.onConversionFailure(t.getMessage());
                }
                Log.e(LOG_TAG,t.getMessage(),t);
            } finally {
                currentRequestsCounter.decrementAndGet();
                if (connection != null){
                    connection.disconnect();
                }
            }
        }
    }
}

