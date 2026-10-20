package com.example.jota

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class MmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("MmsReceiver", "MMS received.")
        // Similar to SmsReceiver, minimally implemented to satisfy Default SMS App requirements.
    }
}
