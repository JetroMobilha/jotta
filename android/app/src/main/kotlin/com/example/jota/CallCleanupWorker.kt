package com.example.jota

import android.content.Context
import android.provider.CallLog
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import androidx.work.ListenableWorker.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject

class CallCleanupWorker(
    appContext: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(appContext, workerParams) {

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        val prefs = applicationContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val contactsJson = prefs.getString("flutter.privacy_contacts", "[]") ?: "[]"
        val targetNumbers = mutableListOf<String>()

        try {
            val array = JSONArray(contactsJson)
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                val phone = obj.optString("phoneNumber")
                if (!phone.isNullOrEmpty()) {
                    targetNumbers.add(phone)
                }
            }
        } catch (e: Exception) {
            Log.e("CallCleanupWorker", "Error parsing contacts json", e)
        }

        if (targetNumbers.isEmpty()) {
            return@withContext Result.success()
        }

        val vaultItems = mutableListOf<JSONObject>()
        val deletedCalls = processCallLog(applicationContext, targetNumbers, vaultItems)
        saveToVaultAndCleanOldItems(applicationContext, vaultItems)

        Log.d("CallCleanupWorker", "Call cleanup finished. Deleted $deletedCalls calls.")
        Result.success()
    }

    private fun isNumberMatch(dbNumber: String, targetNumber: String): Boolean {
        val cleanDb = dbNumber.replace(Regex("[^0-9]"), "")
        val cleanTarget = targetNumber.replace(Regex("[^0-9]"), "")
        if (cleanDb.isEmpty() || cleanTarget.isEmpty()) return false
        val minLen = minOf(cleanDb.length, cleanTarget.length, 9)
        return cleanDb.takeLast(minLen) == cleanTarget.takeLast(minLen)
    }

    private fun getContactNameFromPrefs(context: Context, number: String): String? {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val contactsJson = prefs.getString("flutter.privacy_contacts", "[]") ?: "[]"
        try {
            val array = JSONArray(contactsJson)
            for (i in 0 until array.length()) {
                val obj = array.getJSONObject(i)
                val phone = obj.optString("phoneNumber")
                val name = obj.optString("name", "")
                
                if (!phone.isNullOrEmpty() && name.isNotBlank() && name != "Desconhecido") {
                    val cleanDb = phone.replace(Regex("[^0-9]"), "")
                    val cleanTarget = number.replace(Regex("[^0-9]"), "")
                    if (cleanDb.isNotEmpty() && cleanTarget.isNotEmpty()) {
                        val minLen = minOf(cleanDb.length, cleanTarget.length, 9)
                        if (cleanDb.takeLast(minLen) == cleanTarget.takeLast(minLen)) {
                            return name
                        }
                    }
                }
            }
        } catch (e: Exception) {
            // Ignore
        }
        return null
    }

    private fun processCallLog(context: Context, targets: List<String>, vaultItems: MutableList<JSONObject>): Int {
        var deletedCount = 0
        try {
            val resolver = context.contentResolver
            val uri = CallLog.Calls.CONTENT_URI
            val projection = arrayOf(CallLog.Calls._ID, CallLog.Calls.NUMBER, CallLog.Calls.CACHED_NAME, CallLog.Calls.DATE, CallLog.Calls.TYPE)

            resolver.query(uri, projection, null, null, null)?.use { cursor ->
                val idIdx = cursor.getColumnIndex(CallLog.Calls._ID)
                val numIdx = cursor.getColumnIndex(CallLog.Calls.NUMBER)
                val nameIdx = cursor.getColumnIndex(CallLog.Calls.CACHED_NAME)
                val dateIdx = cursor.getColumnIndex(CallLog.Calls.DATE)
                val typeIdx = cursor.getColumnIndex(CallLog.Calls.TYPE)

                while (cursor.moveToNext()) {
                    val number = if (numIdx >= 0) cursor.getString(numIdx) ?: "" else ""
                    
                    if (targets.any { isNumberMatch(number, it) }) {
                        val id = if (idIdx >= 0) cursor.getString(idIdx) else ""
                        val name = if (nameIdx >= 0) cursor.getString(nameIdx) ?: "Desconhecido" else "Desconhecido"
                        
                        val customName = getContactNameFromPrefs(context, number)
                        val finalName = if (!customName.isNullOrBlank()) {
                            customName
                        } else if (name.isBlank() || name == "null") {
                            "Desconhecido"
                        } else {
                            name
                        }
                        
                        val date = if (dateIdx >= 0) cursor.getLong(dateIdx) else System.currentTimeMillis()
                        val callType = if (typeIdx >= 0) cursor.getInt(typeIdx) else 1

                        val typeStr = when (callType) {
                            CallLog.Calls.INCOMING_TYPE -> "call_in"
                            CallLog.Calls.OUTGOING_TYPE -> "call_out"
                            CallLog.Calls.MISSED_TYPE -> "call_missed"
                            else -> "call_in"
                        }

                        val json = JSONObject()
                        json.put("id", "call_$id")
                        json.put("phoneNumber", if (number.isBlank()) "Desconhecido" else number)
                        json.put("contactName", finalName)
                        json.put("content", "Registo de Chamada")
                        json.put("timestamp", date)
                        json.put("type", typeStr)
                        vaultItems.add(json)

                        if (id.isNotEmpty()) {
                            deletedCount += resolver.delete(uri, "${CallLog.Calls._ID} = ?", arrayOf(id))
                        }
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("CallCleanupWorker", "Error processing calls", e)
        }
        return deletedCount
    }

    private fun saveToVaultAndCleanOldItems(context: Context, newItems: List<JSONObject>) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val vaultData = prefs.getString("flutter.privacy_vault", "[]") ?: "[]"
        val scheduleData = prefs.getString("flutter.privacy_schedule", "{}") ?: "{}"
        
        var retentionDays = 7
        try {
            val scheduleJson = JSONObject(scheduleData)
            if (scheduleJson.has("vaultRetentionDays")) {
                retentionDays = scheduleJson.getInt("vaultRetentionDays")
            }
        } catch (e: Exception) {}

        if (retentionDays <= 0 && newItems.isEmpty()) return

        try {
            val existingArray = JSONArray(vaultData)
            val updatedArray = JSONArray()
            val cutoffTime = System.currentTimeMillis() - (retentionDays * 24L * 60L * 60L * 1000L)

            if (retentionDays > 0) {
                for (i in 0 until existingArray.length()) {
                    val item = existingArray.getJSONObject(i)
                    val timestamp = item.optLong("timestamp", 0)
                    if (timestamp >= cutoffTime) {
                        updatedArray.put(item)
                    }
                }
            }
            
            if (retentionDays > 0) {
                for (item in newItems) {
                    updatedArray.put(item)
                }
            }

            prefs.edit().putString("flutter.privacy_vault", updatedArray.toString()).apply()

        } catch (e: Exception) {
            Log.e("CallCleanupWorker", "Error saving vault", e)
        }
    }
}
