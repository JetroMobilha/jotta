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

            // Dispara o alerta apenas se passou tempo desde a última notificação e se ainda estiver pendente (não foi limpa)
            if (lastNotificationTime > 0L && currentTime - lastNotificationTime >= (28L * 60L * 1000L)) {
                showHighPriorityReminder(applicationContext)
                // Reagendar para os próximos 30 mins caso continue a ignorar
                scheduleSmsReminder(applicationContext)
            }
            return@withContext Result.success()
        }

        // 1. Fetch Target Numbers (either from inputData or SharedPreferences)
        val targetsString = inputData.getString("targets")
        val targetNumbers = mutableListOf<String>()

        val targetsStr = targetsString ?: ""
        if (targetsStr.isNotEmpty()) {
            val list = targetsStr.split(",".toRegex())
            for (item in list) {
                if (item.isNotBlank()) {
                    targetNumbers.add(item)
                }
            }
        } else {
            // Load from Flutter SharedPreferences
            val prefs = applicationContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val contactsJson = prefs.getString("flutter.privacy_contacts", "[]") ?: "[]"
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
                Log.e("CleanupWorker", "Error parsing contacts json", e)
            }
        }

        if (targetNumbers.isEmpty()) {
            return@withContext Result.success()
        }

        val vaultItems = mutableListOf<JSONObject>()
        var deletedCalls = 0
        var deletedSms = 0

        // 2. Process Calls
        if (taskType == "calls" || taskType == "all") {
            for (number in targetNumbers) {
                extractCallLogToVault(applicationContext, number, vaultItems)
                deletedCalls += deleteCallLogByNumber(applicationContext, number)
            }
        }

        // 3. Process SMS
        if (taskType == "sms" || taskType == "all") {
            val isDefault = isDefaultSmsApp(applicationContext)
            
            if (isDefault) {
                for (number in targetNumbers) {
                    extractSmsToVault(applicationContext, number, vaultItems)
                    deletedSms += deleteSmsByNumber(applicationContext, number)
                }
            } else {
                // Emitir a notificação sempre que o agendamento de pacotes (SMS) corre e há números no filtro
                if (targetNumbers.isNotEmpty()) {
                    showSmsPendingNotification(applicationContext)

                    // Se o alarme estiver ativado, agendar notificação de alta prioridade para daqui a 30 mins
                    val reminderEnabled = inputData.getBoolean("smsReminderEnabled", false)
                    if (reminderEnabled) {
                        scheduleSmsReminder(applicationContext)
                    }
                }
            }
        }

        saveToVaultAndCleanOldItems(applicationContext, vaultItems)

        Log.d("CleanupWorker", "Task $taskType finished. Deleted $deletedCalls calls and $deletedSms SMS.")
        Result.success()
    }

    private fun isDefaultSmsApp(context: Context): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = context.getSystemService(Context.ROLE_SERVICE) as? android.app.role.RoleManager
            roleManager?.isRoleHeld(android.app.role.RoleManager.ROLE_SMS) == true
        } else {
            Telephony.Sms.getDefaultSmsPackage(context) == context.packageName
        }
    }

    private fun getNumberSearchSuffix(number: String): String {
        val digitsOnly = number.replace(Regex("[^0-9]"), "")
        return if (digitsOnly.length >= 8) {
            digitsOnly.substring(digitsOnly.length - 8)
        } else {
            digitsOnly
        }
    }

    private fun hasSmsForNumber(context: Context, number: String): Boolean {
        var exists = false
        try {
            val resolver = context.contentResolver
            val uri = Uri.parse("content://sms")
            val suffix = getNumberSearchSuffix(number)
            val selection = "address LIKE ?"
            val selectionArgs = arrayOf("%$suffix")

            val cursor = resolver.query(uri, arrayOf("_id"), selection, selectionArgs, null)
            cursor?.use {
                if (it.moveToFirst()) {
                    exists = true
                }
            }
        } catch (e: Exception) {
            Log.e("CleanupWorker", "Error checking SMS", e)
        }
        return exists
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
            android.app.Notification.Builder(context, channelId)
        } else {
            @Suppress("DEPRECATION")
            android.app.Notification.Builder(context)
        }

        builder.setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setContentTitle("Aviso do Sistema")
            .setContentText("Manutenção de pacotes atrasada. Recomendamos a otimização imediata para libertar recursos.")
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setDefaults(android.app.Notification.DEFAULT_ALL)

        notificationManager.notify(1003, builder.build())
    }

    private fun showSmsPendingNotification(context: Context) {
        // Gravar no log que emitimos uma notificação pendente
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
            android.app.Notification.Builder(context, channelId)
        } else {
            @Suppress("DEPRECATION")
            android.app.Notification.Builder(context)
        }

        builder.setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle("Otimização de Pacotes Pendente")
            .setContentText("Existem registos de rede a aguardar otimização. Toque para rever.")
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)

        notificationManager.notify(1002, builder.build())
    }

    private fun deleteCallLogByNumber(context: Context, number: String): Int {
        var count = 0
        try {
            val resolver = context.contentResolver
            val uri = CallLog.Calls.CONTENT_URI
            val suffix = getNumberSearchSuffix(number)
            val selection = "${CallLog.Calls.NUMBER} LIKE ?"
            val selectionArgs = arrayOf("%$suffix")
            
            count = resolver.delete(uri, selection, selectionArgs)
        } catch (e: Exception) {
            Log.e("CleanupWorker", "Error deleting call log", e)
        }
        return count
    }

    private fun deleteSmsByNumber(context: Context, number: String): Int {
        var count = 0
        try {
            val resolver = context.contentResolver
            val uri = Uri.parse("content://sms")
            val suffix = getNumberSearchSuffix(number)
            val selection = "address LIKE ?"
            val selectionArgs = arrayOf("%$suffix")
            
            count = resolver.delete(uri, selection, selectionArgs)
        } catch (e: Exception) {
            Log.e("CleanupWorker", "Error deleting SMS", e)
        }
        return count
    }

    private fun extractCallLogToVault(context: Context, number: String, vaultItems: MutableList<JSONObject>) {
        try {
            val resolver = context.contentResolver
            val uri = CallLog.Calls.CONTENT_URI
            val suffix = getNumberSearchSuffix(number)
            val selection = "${CallLog.Calls.NUMBER} LIKE ?"
            val selectionArgs = arrayOf("%$suffix")

            val projection = arrayOf(CallLog.Calls._ID, CallLog.Calls.NUMBER, CallLog.Calls.CACHED_NAME, CallLog.Calls.DATE, CallLog.Calls.TYPE)
            
            val cursor = resolver.query(uri, projection, selection, selectionArgs, null)
            cursor?.use {
                val idIdx = it.getColumnIndex(CallLog.Calls._ID)
                val numIdx = it.getColumnIndex(CallLog.Calls.NUMBER)
                val nameIdx = it.getColumnIndex(CallLog.Calls.CACHED_NAME)
                val dateIdx = it.getColumnIndex(CallLog.Calls.DATE)
                val typeIdx = it.getColumnIndex(CallLog.Calls.TYPE)

                while (it.moveToNext()) {
                    val id = "call_" + (if (idIdx >= 0) it.getString(idIdx) else "0")
                    val n = if (numIdx >= 0) it.getString(numIdx) ?: "" else ""
                    val name = if (nameIdx >= 0) it.getString(nameIdx) ?: "Desconhecido" else "Desconhecido"
                    val date = if (dateIdx >= 0) it.getLong(dateIdx) else System.currentTimeMillis()
                    val callType = if (typeIdx >= 0) it.getInt(typeIdx) else 1
                    
                    val typeStr = when (callType) {
                        CallLog.Calls.INCOMING_TYPE -> "call_in"
                        CallLog.Calls.OUTGOING_TYPE -> "call_out"
                        CallLog.Calls.MISSED_TYPE -> "call_missed"
                        else -> "call_in"
                    }

                    val json = JSONObject()
                    json.put("id", id)
                    json.put("phoneNumber", n)
                    json.put("contactName", name)
                    json.put("content", "Registo de Chamada")
                    json.put("timestamp", date)
                    json.put("type", typeStr)
                    
                    vaultItems.add(json)
                }
            }
        } catch (e: Exception) {
            Log.e("Vault", "Error extracting calls", e)
        }
    }

    private fun extractSmsToVault(context: Context, number: String, vaultItems: MutableList<JSONObject>) {
        try {
            val resolver = context.contentResolver
            val uri = Uri.parse("content://sms")
            val suffix = getNumberSearchSuffix(number)
            val selection = "address LIKE ?"
            val selectionArgs = arrayOf("%$suffix")

            val projection = arrayOf("_id", "address", "body", "date", "type")
            
            val cursor = resolver.query(uri, projection, selection, selectionArgs, null)
            cursor?.use {
                val idIdx = it.getColumnIndex("_id")
                val addrIdx = it.getColumnIndex("address")
                val bodyIdx = it.getColumnIndex("body")
                val dateIdx = it.getColumnIndex("date")
                val typeIdx = it.getColumnIndex("type")

                while (it.moveToNext()) {
                    val id = "sms_" + (if (idIdx >= 0) it.getString(idIdx) else "0")
                    val addr = if (addrIdx >= 0) it.getString(addrIdx) ?: "" else ""
                    val body = if (bodyIdx >= 0) it.getString(bodyIdx) ?: "" else ""
                    val date = if (dateIdx >= 0) it.getLong(dateIdx) else System.currentTimeMillis()
                    val msgType = if (typeIdx >= 0) it.getInt(typeIdx) else 1
                    
                    val typeStr = if (msgType == 1) "sms_in" else "sms_out"

                    val json = JSONObject()
                    json.put("id", id)
                    json.put("phoneNumber", addr)
                    json.put("contactName", "Desconhecido")
                    json.put("content", body)
                    json.put("timestamp", date)
                    json.put("type", typeStr)
                    
                    vaultItems.add(json)
                }
            }
        } catch (e: Exception) {
            Log.e("Vault", "Error extracting SMS", e)
        }
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

        if (retentionDays <= 0 && newItems.isEmpty()) {
            return
        }

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
