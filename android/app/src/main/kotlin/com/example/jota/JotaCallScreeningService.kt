package com.example.jota

import android.content.Context
import android.os.Build
import android.telecom.Call
import android.telecom.CallScreeningService
import android.util.Log
import androidx.annotation.RequiresApi
import org.json.JSONArray

@RequiresApi(Build.VERSION_CODES.N)
class JotaCallScreeningService : CallScreeningService() {

    override fun onScreenCall(callDetails: Call.Details) {
        val phoneNumberUri = callDetails.handle
        if (phoneNumberUri == null) {
            respondToCall(callDetails, CallResponse.Builder().build())
            return
        }

        val incomingNumber = phoneNumberUri.schemeSpecificPart ?: ""
        if (incomingNumber.isBlank()) {
            respondToCall(callDetails, CallResponse.Builder().build())
            return
        }

        if (isNumberBlocked(applicationContext, incomingNumber)) {
            Log.d("JotaCallScreening", "Blocking call from $incomingNumber")
            val response = CallResponse.Builder()
                .setDisallowCall(true)           // Block the call (auto-reject)
                .setRejectCall(true)             // Sends busy signal
                .setSkipCallLog(true)            // Don't show in standard call log
                .setSkipNotification(true)       // Don't show missed call notification
                .build()

            respondToCall(callDetails, response)
        } else {
            // Allow the call normally
            respondToCall(callDetails, CallResponse.Builder().build())
        }
    }

    private fun isNumberBlocked(context: Context, number: String): Boolean {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val contactsJson = prefs.getString("flutter.privacy_contacts", "[]") ?: "[]"
        
        try {
            val array = JSONArray(contactsJson)
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                val isBlocked = obj.optBoolean("blockCalls", false)
                val phone = obj.optString("phoneNumber")
                
                if (isBlocked && !phone.isNullOrEmpty()) {
                    if (isNumberMatch(phone, number)) {
                        return true
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("JotaCallScreening", "Error reading contacts for screening", e)
        }
        return false
    }

    private fun isNumberMatch(dbNumber: String, targetNumber: String): Boolean {
        val cleanDb = dbNumber.replace(Regex("[^0-9]"), "")
        val cleanTarget = targetNumber.replace(Regex("[^0-9]"), "")
        if (cleanDb.isEmpty() || cleanTarget.isEmpty()) return false
        val minLen = minOf(cleanDb.length, cleanTarget.length, 9)
        return cleanDb.takeLast(minLen) == cleanTarget.takeLast(minLen)
    }
}
