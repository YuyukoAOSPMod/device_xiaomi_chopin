package org.lineageos.mediatek.incallservice;

import android.content.Intent;
import android.content.Context;
import android.content.BroadcastReceiver;

import android.media.AudioManager;
import android.media.AudioSystem;
import android.media.AudioDeviceInfo;

import android.telephony.TelephonyManager;

import android.util.Log;

public class PhoneStateChangeReceiver extends BroadcastReceiver {
    public static final String LOG_TAG = "MtkInCallService";

    private AudioManager mAudioManager;

    public PhoneStateChangeReceiver(Context context) {
        mAudioManager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        String callStatus = intent.getStringExtra(TelephonyManager.EXTRA_STATE);
        if (callStatus.equals(TelephonyManager.EXTRA_STATE_OFFHOOK)) {
            AudioDeviceInfo callDevice = mAudioManager.getCommunicationDevice();
            if (callDevice.getInternalType() != AudioDeviceInfo.TYPE_BUILTIN_EARPIECE) {
                // Device is not the built in earpiece, we don't need to do anything.
                return;
            }

            // Start building parameters
            String parameters = "volumeDevice=" + (callDevice.getId() - 1) + ";";
            parameters += "volumeIndex=7;";
            parameters += "volumeStreamType=" + AudioManager.STREAM_VOICE_CALL;

            // Set gain parameters
            Log.d(LOG_TAG, "Setting audio parameters: " + parameters);
            AudioSystem.setParameters(parameters);
        }
    }
}
