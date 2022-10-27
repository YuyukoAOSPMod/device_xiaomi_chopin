package org.lineageos.mediatek.incallservice;

import android.os.SystemProperties;
import android.media.AudioSystem;
import android.util.Log;

public class GainUtils {
    public static final String LOG_TAG = "MtkInCallService";

    public static void setGainLevel(int audioDevice, int gainIndex, int streamType) {
        int maxStep = SystemProperties.getInt("ro.config.vc_call_vol_steps", 7);
        String parameters = String.format("volumeDevice=%d;volumeIndex=%d;volumeStreamType=%d",
                                          audioDevice, 
                                          Math.round(
                                            (15.0 / Math.log(maxStep + 1.0))
                                            * Math.log(Math.min(maxStep, gainIndex) + 1.0)),
                                          streamType);
        Log.d(LOG_TAG, "Setting audio parameters to: " + parameters);
        AudioSystem.setParameters(parameters);
    }
}