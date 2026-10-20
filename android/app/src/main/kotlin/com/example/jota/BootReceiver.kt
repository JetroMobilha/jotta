package com.example.jota

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.work.Data
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequest
import androidx.work.WorkManager
import org.json.JSONObject
import java.util.concurrent.TimeUnit

class BootReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || intent.action == Intent.ACTION_MY_PACKAGE_REPLACED) {
            Log.d("JotaBootReceiver", "Boot or package update detected. Rescheduling background tasks...")

            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val scheduleData = prefs.getString("flutter.privacy_schedule", "{}") ?: "{}"

            try {
                val scheduleJson = JSONObject(scheduleData)
                val callLogEnabled = scheduleJson.optBoolean("callLogEnabled", false)
                val callLogInterval = scheduleJson.optLong("callLogIntervalMinutes", 15L)

                val smsEnabled = scheduleJson.optBoolean("smsEnabled", false)
                val smsInterval = scheduleJson.optLong("smsIntervalMinutes", 1440L)
                val smsReminderEnabled = scheduleJson.optBoolean("smsReminderEnabled", false)

                val workManager = WorkManager.getInstance(context)

                // Reschedule Call Cleanup
                if (callLogEnabled) {
                    val callRequest = PeriodicWorkRequest.Builder(
                        CallCleanupWorker::class.java,
                        callLogInterval,
                        TimeUnit.MINUTES
                    ).build()
                    workManager.enqueueUniquePeriodicWork("cleaner_calls", ExistingPeriodicWorkPolicy.REPLACE, callRequest)
                }

                // Reschedule SMS Cleanup
                if (smsEnabled) {
                    val input = Data.Builder()
                        .putString("taskType", "sms")
                        .putBoolean("smsReminderEnabled", smsReminderEnabled)
                        .build()
                    val smsRequest = PeriodicWorkRequest.Builder(
                        SmsCleanupWorker::class.java,
                        smsInterval,
                        TimeUnit.MINUTES
                    ).setInputData(input).build()
                    workManager.enqueueUniquePeriodicWork("cleaner_sms", ExistingPeriodicWorkPolicy.REPLACE, smsRequest)
                }

            } catch (e: Exception) {
                Log.e("JotaBootReceiver", "Error rescheduling tasks on boot", e)
            }
        }
    }
}
