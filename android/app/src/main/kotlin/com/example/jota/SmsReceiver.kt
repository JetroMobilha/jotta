package com.example.jota

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.util.Log

class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Telephony.Sms.Intents.SMS_DELIVER_ACTION) {
            // Log for debugging
            Log.d("SmsReceiver", "SMS received. As default app, you'd usually parse it here.")
            
            // Note: Since this app's primary purpose is NOT to be a full SMS client,
            // we do minimal processing here. If the user wants to see their SMS,
            // they should use a real SMS app. We are just holding the role to delete.
            
            // In a real, fully transparent SMS app, you'd need to write the incoming 
            // message to the Telephony provider and trigger a notification.
            // For simplicity in this privacy tool, we assume they only set it as 
            // default temporarily for cleanup, OR we accept they won't get rich notifications.
        }
    }
}
