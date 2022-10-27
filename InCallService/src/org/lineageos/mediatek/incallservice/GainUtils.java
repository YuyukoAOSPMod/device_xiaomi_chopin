package org.lineageos.mediatek.incallservice;

import android.media.AudioSystem;

import android.util.Log;

public class GainUtils {
    public static final String LOG_TAG = "MtkInCallService";

    public static void setGainLevel(int audioDevice, int gainIndex, int streamType) {
        String parameters = String.format("volumeDevice=%d;volumeIndex=%d;volumeStreamType=%d",
                                          audioDevice, Math.min(7, gainIndex), streamType);
        Log.d(LOG_TAG, "Setting audio parameters to: " + parameters);
        AudioSystem.setParameters(parameters);
    }
}