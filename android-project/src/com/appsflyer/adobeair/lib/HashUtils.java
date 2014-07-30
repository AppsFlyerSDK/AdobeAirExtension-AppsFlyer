package com.appsflyer.adobeair.lib;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Formatter;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: gilmeroz
 * Date: 2/25/14
 * Time: 3:00 PM
 * To change this template use File | Settings | File Templates.
 */
public class HashUtils {

    static {
  //      System.loadLibrary("appsflyer");
    }

    public native String getNativeCode(String afDevKey, String timestamp, String uid);

    public String getHashCode(Map<String,String> params) {
        String afDevKey = params.get(ServerParameters.AF_DEV_KEY);
        String timestamp = params.get(ServerParameters.TIMESTAMP);
        String uid = params.get(ServerParameters.AF_USER_ID);
        String nativeSha1 = null;//getNativeCode(afDevKey,timestamp,uid);
     /* for checking the SHA1 algorithm */
        try {
            MessageDigest crypt = MessageDigest.getInstance("SHA-1");
            crypt.reset();
//            crypt.update(nativeCode.getBytes("UTF-8"));
            crypt.update((afDevKey.substring(0,7)+uid.substring(0,7)+timestamp.substring(timestamp.length()-7)).getBytes("UTF-8"));
            nativeSha1 = byteToHex(crypt.digest());
        } catch(NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        catch(UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        return nativeSha1;
    }

    private static String byteToHex(final byte[] hash) {
        Formatter formatter = new Formatter();
        for (byte b : hash) {
            formatter.format("%02x", b);
        }
        String result = formatter.toString();
        formatter.close();
        return result;
    }
}
