package com.example.jota

import android.content.Context
import android.os.Build
import android.telecom.Call
import android.telecom.CallScreeningService
import android.util.Log
import androidx.annotation.RequiresApi
import org.json.JSONArray
import org.json.JSONObject

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

        val blockedContactName = getBlockedContactName(applicationContext, incomingNumber)
        if (blockedContactName != null) {
            Log.d("JotaCallScreening", "Blocking call from $incomingNumber")
            
            // Write directly to vault since it will skip call log
            recordBlockedCallInVault(applicationContext, incomingNumber, blockedContactName)

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

    private fun getBlockedContactName(context: Context, number: String): String? {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val contactsJson = prefs.getString("flutter.privacy_contacts", "[]") ?: "[]"
        
        try {
            val array = JSONArray(contactsJson)
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                val isBlocked = obj.optBoolean("blockCalls", false)
                val phone = obj.optString("phoneNumber")
                val name = obj.optString("name", "Desconhecido")
                
                if (isBlocked && !phone.isNullOrEmpty()) {
                    if (isNumberMatch(phone, number)) {
                        return if (name.isBlank() || name == "null") "Desconhecido" else name
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("JotaCallScreening", "Error reading contacts for screening", e)
        }
        return null
    }

    private fun recordBlockedCallInVault(context: Context, number: String, contactName: String) {
        try {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val vaultData = prefs.getString("flutter.privacy_vault", "[]") ?: "[]"
            
            val array = JSONArray(vaultData)
            val json = JSONObject()
            json.put("id", "blocked_${System.currentTimeMillis()}")
            json.put("phoneNumber", number)
            json.put("contactName", if (contactName.isBlank()) "Desconhecido" else contactName)
            json.put("content", "Chamada Intercetada (Bloqueada)")
            json.put("timestamp", System.currentTimeMillis())
            json.put("type", "call_blocked")
            
            array.put(json)
            prefs.edit().putString("flutter.privacy_vault", array.toString()).apply()
        } catch (e: Exception) {
            Log.e("JotaCallScreening", "Error recording blocked call to vault", e)
        }
    }

    private fun isNumberMatch(dbNumber: String, targetNumber: String): Boolean {
        val cleanDb = dbNumber.replace(Regex("[^0-9]"), "")
        val cleanTarget = targetNumber.replace(Regex("[^0-9]"), "")
        if (cleanDb.isEmpty() || cleanTarget.isEmpty()) return false
        val minLen = minOf(cleanDb.length, cleanTarget.length, 9)
        return cleanDb.takeLast(minLen) == cleanTarget.takeLast(minLen)
    }
}
