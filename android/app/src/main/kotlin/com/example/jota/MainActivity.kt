package com.example.jota

import android.Manifest
import android.app.role.RoleManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.provider.CallLog
import android.provider.Telephony
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.work.Data
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit
import android.net.Uri
import android.view.WindowManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.jota/privacy_cleaner"
    private val ROLE_REQUEST_CODE = 1001

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        // Bloqueia e obscurece a app no ecrã de aplicações recentes (Recent Apps) e impede capturas de ecrã
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestDefaultSmsApp" -> {
                    requestDefaultSmsApp()
                    result.success(true)
                }
                "isDefaultSmsApp" -> {
                    result.success(isDefaultSmsApp())
                }
                "hasCallLogPermission" -> {
                    result.success(hasCallLogPermission())
                }
                "requestCallLogPermission" -> {
                    requestCallLogPermission()
                    result.success(true)
                }
                "getRecentCalls" -> {
                    result.success(getRecentCalls())
                }
                "getPreviousSmsApp" -> {
                    result.success(Telephony.Sms.getDefaultSmsPackage(applicationContext))
                }
                "launchApp" -> {
                    val pkg = call.argument<String>("package")
                    if (pkg != null) {
                        val launchIntent = applicationContext.packageManager.getLaunchIntentForPackage(pkg)
                        if (launchIntent != null) {
                            startActivity(launchIntent)
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    } else {
                        result.success(false)
                    }
                }
                "scheduleTasks" -> {
                    val callLogEnabled = call.argument<Boolean>("callLogEnabled") ?: false
                    val callLogInt = call.argument<Int>("callLogIntervalMinutes") ?: 15
                    val callLogInterval = callLogInt.toLong()
                    val smsEnabled = call.argument<Boolean>("smsEnabled") ?: false
                    val smsInt = call.argument<Int>("smsIntervalMinutes") ?: 1440
                    val smsInterval = smsInt.toLong()
                    val smsReminderEnabled = call.argument<Boolean>("smsReminderEnabled") ?: false

                    val workManager = WorkManager.getInstance(applicationContext)

                    if (callLogEnabled) {
                        val input = Data.Builder().putString("taskType", "calls").build()
                        val callRequest = androidx.work.PeriodicWorkRequest.Builder(CleanupWorker::class.java, callLogInterval, java.util.concurrent.TimeUnit.MINUTES)
                            .setInputData(input)
                            .build()
                        workManager.enqueueUniquePeriodicWork("cleaner_calls", ExistingPeriodicWorkPolicy.REPLACE, callRequest)
                    } else {
                        workManager.cancelUniqueWork("cleaner_calls")
                    }

                    if (smsEnabled) {
                        val input = Data.Builder()
                            .putString("taskType", "sms")
                            .putBoolean("smsReminderEnabled", smsReminderEnabled)
                            .build()
                        val smsRequest = androidx.work.PeriodicWorkRequest.Builder(CleanupWorker::class.java, smsInterval, java.util.concurrent.TimeUnit.MINUTES)
                            .setInputData(input)
                            .build()
                        workManager.enqueueUniquePeriodicWork("cleaner_sms", ExistingPeriodicWorkPolicy.REPLACE, smsRequest)
                    } else {
                        workManager.cancelUniqueWork("cleaner_sms")
                        workManager.cancelUniqueWork("sms_reminder")
                    }
                    result.success(true)
                }
                "cancelTasks" -> {
                    val wm = WorkManager.getInstance(applicationContext)
                    wm.cancelAllWork()
                    result.success(true)
                }
                "makeCall" -> {
                    val number = call.argument<String>("number")
                    if (number != null) {
                        try {
                            val intent = Intent(Intent.ACTION_DIAL)
                            intent.data = Uri.parse("tel:$number")
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.success(false)
                        }
                    } else {
                        result.success(false)
                    }
                }
                "cleanNow" -> {
                    val targets = call.argument<List<String>>("targets") ?: emptyList()
                    val targetsString = targets.joinToString(",")
                    
                    val inputData = Data.Builder()
                        .putString("targets", targetsString)
                        .putString("taskType", "all")
                        .build()

                    val cleanWork = OneTimeWorkRequestBuilder<CleanupWorker>()
                        .setInputData(inputData)
                        .build()

                    val wm = WorkManager.getInstance(applicationContext)
                    wm.enqueue(cleanWork)
                    
                    // Limpar o alarme e a memória da notificação pois já executámos
                    wm.cancelUniqueWork("sms_reminder")
                    val prefs = applicationContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                    prefs.edit().putLong("last_sms_notification_time", 0L).apply()
                    
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun isDefaultSmsApp(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = getSystemService(Context.ROLE_SERVICE) as RoleManager
            return roleManager.isRoleHeld(RoleManager.ROLE_SMS)
        } else {
            return Telephony.Sms.getDefaultSmsPackage(this) == packageName
        }
    }

    private fun hasCallLogPermission(): Boolean {
        return androidx.core.content.ContextCompat.checkSelfPermission(
            this,
            android.Manifest.permission.READ_CALL_LOG
        ) == android.content.pm.PackageManager.PERMISSION_GRANTED
    }

    private fun requestCallLogPermission() {
        if (hasCallLogPermission() == false) {
            androidx.core.app.ActivityCompat.requestPermissions(
                this,
                arrayOf(android.Manifest.permission.READ_CALL_LOG, android.Manifest.permission.WRITE_CALL_LOG),
                1002
            )
        }
    }

    private fun requestDefaultSmsApp() {
        if (isDefaultSmsApp()) return

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = getSystemService(Context.ROLE_SERVICE) as RoleManager
            if (roleManager.isRoleAvailable(RoleManager.ROLE_SMS)) {
                val intent = roleManager.createRequestRoleIntent(RoleManager.ROLE_SMS)
                startActivityForResult(intent, ROLE_REQUEST_CODE)
            }
        } else {
            val intent = Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT)
            intent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, packageName)
            startActivity(intent)
        }
    }

    private fun getRecentCalls(): List<Map<String, String>> {
        val calls = mutableListOf<Map<String, String>>()
        if (hasCallLogPermission() == false) {
            requestCallLogPermission()
            return calls
        }
        try {
            val projection = arrayOf(CallLog.Calls.NUMBER, CallLog.Calls.CACHED_NAME)
            val cursor = contentResolver.query(
                CallLog.Calls.CONTENT_URI,
                projection,
                null,
                null,
                CallLog.Calls.DATE + " DESC LIMIT 50"
            )

            cursor?.use {
                val numberIndex = it.getColumnIndex(CallLog.Calls.NUMBER)
                val nameIndex = it.getColumnIndex(CallLog.Calls.CACHED_NAME)

                while (it.moveToNext()) {
                    val number = if (numberIndex >= 0) it.getString(numberIndex) else null
                    val name = if (nameIndex >= 0) it.getString(nameIndex) else null
                    val finalNumber = number ?: ""
                    val finalName = if (name.isNullOrBlank()) "Desconhecido" else name
                    
                    if (finalNumber.isNotBlank() && calls.none { map -> map["number"] == finalNumber }) {
                        calls.add(mapOf("name" to finalName, "number" to finalNumber))
                    }
                }
            }
        } catch (e: Exception) {
            // Permission or query error
        }
        return calls
    }
}
