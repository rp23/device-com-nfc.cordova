//
//  Copyright 2018 IoTize SAS Inc.  Licensed under the MIT license. 
//
//  JSONBuilder.java
//  device-com-ble.cordova BLE Cordova Plugin
//
package com.chariotsolutions.nfc.plugin;

import android.util.Log;

import com.iotize.android.device.device.impl.IoTizeDevice;

import org.json.JSONException;
import org.json.JSONObject;

import io.reactivex.annotations.NonNull;
import io.reactivex.annotations.Nullable;

public class JSONBuilder {

    private static final String TAG = "JSONBuilder";

    @NonNull
    public static JSONObject toJSONObject(NfcPluginError error) {
        try {
            JSONObject json = new JSONObject();

            json.put("code", error.getCode());
            json.put("message", error.getMessage());

            return json;
        } catch (JSONException e) {
            Log.e(TAG, "Internal error", e);
            throw new Error("INTERNAL ERROR: " + e.getMessage(), e);
        }
    }

    @Nullable
    public static JSONObject toJSONObject(@Nullable IoTizeDevice tap) {
        if (tap != null) {
            try {
//                byte[] sessionKey = tap.getSessionKey();
                byte[] initializationVector = null; // TODO
                JSONObject json = new JSONObject();

//                json.put("sessionKey", sessionKey);
                json.put("initializationVector", initializationVector);
                json.put("name", "TODO");
                json.put("nfcPairingDone", true);

                return json;
            } catch (JSONException e) {
                Log.e(TAG, "Internal error", e);
                throw new Error("INTERNAL ERROR: " + e.getMessage(), e);
            }
        } else {
            return null;
        }
    }
}
