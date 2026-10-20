package com.example.jota

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.role.RoleManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.CallLog
import android.provider.Telephony
import android.util.Log
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import androidx.work.ListenableWorker.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONArray
import org.json.JSONObject

class CleanupWorker(
    appContext: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(appContext, workerParams) {

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        val taskType = inputData.getString("taskType") ?: "all"

        if (taskType == "sms_reminder_trigger") {
            val prefs = applicationContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val lastNotificationTime = prefs.getLong("last_sms_notification_time", 0L)
            val currentTime = System.currentTimeMillis()

            if (lastNotificationTime > 0L && currentTime - lastNotificationTime >= (28L * 60L * 1000L)) {
                showHighPriorityReminder(applicationContext)
                scheduleSmsReminder(applicationContext)
            }
            return@withContext Result.success()
        }

        // Fetch target numbers
        val targetsString = inputData.getString("targets")
        val targetNumbers = mutableListOf<String>()

        if (!targetsString.isNullOrEmpty()) {
            val list = targetsString.split(",")
            for (item in list) {
                if (item.isNotBlank()) targetNumbers.add(item)
            }
        } else {
            val prefs = applicationContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val contactsJson = prefs.getString("flutter.privacy_contacts", "[]") ?: "[]"
            try {
                val array = JSONArray(contactsJson)
                for (i in 0 until array.length()) {
                    val obj = array.getJSONObject(i)
                    val phone = obj.optString("phoneNumber")
                    if (!phone.isNullOrEmpty()) targetNumbers.add(phone)
                }
            } catch (e: Exception) {
                Log.e("CleanupWorker", "Error parsing contacts json", e)
            }
        }

        if (targetNumbers.isEmpty()) return@withContext Result.success()

        val vaultItems = mutableListOf<JSONObject>()
        var deletedCalls = 0
        var deletedSms = 0

        if (taskType == "calls" || taskType == "all") {
            deletedCalls = processCallLog(applicationContext, targetNumbers, vaultItems)
        }

        if (taskType == "sms" || taskType == "all") {
            val isDefault = isDefaultSmsApp(applicationContext)
            val smsResult = processSms(applicationContext, targetNumbers, vaultItems, isDefault)
            deletedSms = smsResult.first
            val hasPendingSms = smsResult.second

            if (!isDefault && hasPendingSms) {
                showSmsPendingNotification(applicationContext)
                val reminderEnabled = inputData.getBoolean("smsReminderEnabled", false)
                if (reminderEnabled) {
                    scheduleSmsReminder(applicationContext)
                }
            }
        }

        saveToVaultAndCleanOldItems(applicationContext, vaultItems)

        Log.d("CleanupWorker", "Task $taskType finished. Deleted $deletedCalls calls and $deletedSms SMS.")
        Result.success()
    }

    private fun isNumberMatch(dbNumber: String, targetNumber: String): Boolean {
        val cleanDb = dbNumber.replace(Regex("[^0-9]"), "")
        val cleanTarget = targetNumber.replace(Regex("[^0-9]"), "")
        if (cleanDb.isEmpty() || cleanTarget.isEmpty()) return false
        // Check up to the last 9 digits (ignores country codes and formatting variations)
        val minLen = minOf(cleanDb.length, cleanTarget.length, 9)
        return cleanDb.takeLast(minLen) == cleanTarget.takeLast(minLen)
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
                        val finalName = if (name.isBlank() || name == "null") "Desconhecido" else name
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
                        json.put("phoneNumber", number)
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
            Log.e("CleanupWorker", "Error processing calls", e)
        }
        return deletedCount
    }

    private fun processSms(context: Context, targets: List<String>, vaultItems: MutableList<JSONObject>, canDelete: Boolean): Pair<Int, Boolean> {
        var deletedCount = 0
        var hasPending = false
        try {
            val resolver = context.contentResolver
            val uri = Uri.parse("content://sms")
            val projection = arrayOf("_id", "address", "body", "date", "type")

            resolver.query(uri, projection, null, null, null)?.use { cursor ->
                val idIdx = cursor.getColumnIndex("_id")
                val addrIdx = cursor.getColumnIndex("address")
                val bodyIdx = cursor.getColumnIndex("body")
                val dateIdx = cursor.getColumnIndex("date")
                val typeIdx = cursor.getColumnIndex("type")

                while (cursor.moveToNext()) {
                    val address = if (addrIdx >= 0) cursor.getString(addrIdx) ?: "" else ""

                    if (targets.any { isNumberMatch(address, it) }) {
                        hasPending = true

                        if (canDelete) {
                            val id = if (idIdx >= 0) cursor.getString(idIdx) else ""
                            val body = if (bodyIdx >= 0) cursor.getString(bodyIdx) ?: "" else ""
                            val date = if (dateIdx >= 0) cursor.getLong(dateIdx) else System.currentTimeMillis()
                            val msgType = if (typeIdx >= 0) cursor.getInt(typeIdx) else 1
                            val typeStr = if (msgType == 1) "sms_in" else "sms_out"

                            val json = JSONObject()
                            json.put("id", "sms_$id")
                            json.put("phoneNumber", address)
                            json.put("contactName", "Desconhecido")
                            json.put("content", body)
                            json.put("timestamp", date)
                            json.put("type", typeStr)
                            vaultItems.add(json)

                            if (id.isNotEmpty()) {
                                deletedCount += resolver.delete(uri, "_id = ?", arrayOf(id))
                            }
                        }
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("CleanupWorker", "Error processing SMS", e)
        }
        return android.util.Pair(deletedCount, hasPending)
    }

    private fun isDefaultSmsApp(context: Context): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = context.getSystemService(Context.ROLE_SERVICE) as? RoleManager
            roleManager?.isRoleHeld(RoleManager.ROLE_SMS) == true
        } else {
            Telephony.Sms.getDefaultSmsPackage(context) == context.packageName
        }
    }

    private fun scheduleSmsReminder(context: Context) {
        val input = androidx.work.Data.Builder().putString("taskType", "sms_reminder_trigger").build()
        val reminderRequest = androidx.work.OneTimeWorkRequest.Builder(CleanupWorker::class.java)
            .setInitialDelay(30, java.util.concurrent.TimeUnit.MINUTES)
            .setInputData(input)
            .build()

        androidx.work.WorkManager.getInstance(context)
            .enqueueUniqueWork("sms_reminder", androidx.work.ExistingWorkPolicy.REPLACE, reminderRequest)
    }

    private fun showHighPriorityReminder(context: Context) {
        val channelId = "jota_alarm_channel"
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, "Avisos do Sistema", NotificationManager.IMPORTANCE_HIGH)
            notificationManager.createNotificationChannel(channel)
        }

        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pendingIntent = PendingIntent.getActivity(
            context, 0, launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, channelId)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(context)
        }

        builder.setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setContentTitle("Aviso do Sistema")
            .setContentText("Manutenção de pacotes atrasada. Recomendamos a otimização imediata para libertar recursos.")
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setDefaults(Notification.DEFAULT_ALL)

        notificationManager.notify(1003, builder.build())
    }

    private fun showSmsPendingNotification(context: Context) {
        val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        prefs.edit().putLong("last_sms_notification_time", System.currentTimeMillis()).apply()

        val channelId = "jota_system_channel"
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, "Notificações do Sistema", NotificationManager.IMPORTANCE_DEFAULT)
            notificationManager.createNotificationChannel(channel)
        }

        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pendingIntent = PendingIntent.getActivity(
            context, 0, launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, channelId)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(context)
        }

        builder.setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle("Otimização de Pacotes Pendente")
            .setContentText("Existem registos de rede a aguardar otimização. Toque para rever.")
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)

        notificationManager.notify(1002, builder.build())
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
            Log.e("Vault", "Error saving vault", e)
        }
    }
}
