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
import android.provider.Settings
import android.os.PowerManager
import android.content.ComponentName

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.jota/privacy_cleaner"
    private val ROLE_REQUEST_CODE = 1001
    private val CALL_SCREENING_ROLE_REQUEST_CODE = 1002

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
                "hasCallScreeningRole" -> {
                    result.success(hasCallScreeningRole())
                }
                "requestCallScreeningRole" -> {
                    requestCallScreeningRole()
                    result.success(true)
                }
                "hasCallLogPermission" -> {
                    result.success(hasCallLogPermission())
                }
                "requestCallLogPermission" -> {
                    requestCallLogPermission()
                    result.success(true)
                }
                "requestBatteryExemption" -> {
                    requestBatteryExemption()
                    result.success(true)
                }
                "isIgnoringBatteryOptimizations" -> {
                    result.success(isIgnoringBatteryOptimizations())
                }
                "startMonitorService" -> {
                    startMonitorService()
                    result.success(true)
                }
                "stopMonitorService" -> {
                    stopMonitorService()
                    result.success(true)
                }
                "openAutoStartSettings" -> {
                    openAutoStartSettings()
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
                        val callRequest = androidx.work.PeriodicWorkRequest.Builder(CallCleanupWorker::class.java, callLogInterval, java.util.concurrent.TimeUnit.MINUTES)
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
                        val smsRequest = androidx.work.PeriodicWorkRequest.Builder(SmsCleanupWorker::class.java, smsInterval, java.util.concurrent.TimeUnit.MINUTES)
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

    private fun hasCallScreeningRole(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = getSystemService(Context.ROLE_SERVICE) as? RoleManager
            return roleManager?.isRoleHeld(RoleManager.ROLE_CALL_SCREENING) == true
        }
        return false // Only supported on Q+
    }

    private fun requestCallScreeningRole() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val roleManager = getSystemService(Context.ROLE_SERVICE) as RoleManager
            if (!roleManager.isRoleHeld(RoleManager.ROLE_CALL_SCREENING)) {
                val intent = roleManager.createRequestRoleIntent(RoleManager.ROLE_CALL_SCREENING)
                startActivityForResult(intent, CALL_SCREENING_ROLE_REQUEST_CODE)
            }
        }
    }

    private fun requestBatteryExemption() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
            intent.data = Uri.parse("package:$packageName")
            try {
                startActivity(intent)
            } catch (e: Exception) {
                // Settings activity not found
            }
        }
    }

    private fun isIgnoringBatteryOptimizations(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
            return pm.isIgnoringBatteryOptimizations(packageName)
        }
        return true
    }

    private fun startMonitorService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(this, Intent(this, JottaMonitorService::class.java))
        } else {
            startService(Intent(this, JottaMonitorService::class.java))
        }
    }

    private fun stopMonitorService() {
        stopService(Intent(this, JottaMonitorService::class.java))
    }

    private fun openAutoStartSettings() {
        try {
            val intents = arrayOf(
                Intent().setComponent(ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")),
                Intent().setComponent(ComponentName("com.letv.android.letvsafe", "com.letv.android.letvsafe.AutobootManageActivity")),
                Intent().setComponent(ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity")),
                Intent().setComponent(ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity")),
                Intent().setComponent(ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity")),
                Intent().setComponent(ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity")),
                Intent().setComponent(ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity")),
                Intent().setComponent(ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity")),
                Intent().setComponent(ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager")),
                Intent().setComponent(ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.BgStartUpManagerActivity")),
                Intent().setComponent(ComponentName("com.asus.mobilemanager", "com.asus.mobilemanager.entry.FunctionActivity")),
                Intent().setComponent(ComponentName("com.samsung.android.lool", "com.samsung.android.sm.ui.battery.BatteryActivity"))
            )
            var intentFound = false
            for (intent in intents) {
                if (packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY) != null) {
                    startActivity(intent)
                    intentFound = true
                    break
                }
            }
            if (!intentFound) {
                // Se não encontrar nenhuma, atira para as definições normais da app
                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                intent.data = Uri.parse("package:$packageName")
                startActivity(intent)
            }
        } catch (e: Exception) {
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            intent.data = Uri.parse("package:$packageName")
            startActivity(intent)
        }
    }

    private fun getContactNameFromPrefs(number: String): String? {
        val prefs = applicationContext.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val contactsJson = prefs.getString("flutter.privacy_contacts", "[]") ?: "[]"
        try {
            val array = org.json.JSONArray(contactsJson)
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
                    
                    val customName = getContactNameFromPrefs(finalNumber)
                    val finalName = if (!customName.isNullOrBlank()) {
                        customName
                    } else if (name.isNullOrBlank()) {
                        "Desconhecido"
                    } else {
                        name
                    }
                    
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
