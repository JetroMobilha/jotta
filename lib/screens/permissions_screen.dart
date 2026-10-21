import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../l10n/app_localizations.dart';
import '../services/native_cleaner_service.dart';
import '../widgets/soft_container.dart';
import '../widgets/banner_ad_widget.dart';
import '../theme/app_colors.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _hasCallLog = false;
  bool _hasContacts = false;
  bool _isDefaultSms = false;
  bool _hasNotification = false;
  bool _hasCallScreening = false;
  bool _isIgnoringBattery = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final hasCallLog = await NativeCleanerService.hasCallLogPermission();
    final hasContacts = await Permission.contacts.isGranted;
    final isDefaultSms = await NativeCleanerService.isDefaultSmsApp();
    final hasNotif = await Permission.notification.isGranted;
    final hasCallScreen = await NativeCleanerService.hasCallScreeningRole();
    final isIgnBattery = await NativeCleanerService.isIgnoringBatteryOptimizations();

    setState(() {
      _hasCallLog = hasCallLog;
      _hasContacts = hasContacts;
      _isDefaultSms = isDefaultSms;
      _hasNotification = hasNotif;
      _hasCallScreening = hasCallScreen;
      _isIgnoringBattery = isIgnBattery;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.permissions)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.permissionsDesc,
            style: const TextStyle(fontSize: 16, color: AppColors.textWhite, height: 1.4),
          ),
          const SizedBox(height: 25),
          SoftContainer(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.phone, color: _hasCallLog ? AppColors.accentGreen : Colors.redAccent),
              title: Text(l10n.callLogPerm, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              subtitle: Text(_hasCallLog ? l10n.accessGranted : l10n.callLogPermDesc, style: const TextStyle(color: AppColors.textLight)),
              trailing: _hasCallLog
                  ? const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 28)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await NativeCleanerService.requestCallLogPermission();
                        await Future.delayed(const Duration(milliseconds: 1200));
                        _checkPermissions();
                      },
                      child: Text(l10n.grant, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          SoftContainer(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.contacts, color: _hasContacts ? AppColors.accentGreen : Colors.redAccent),
              title: Text(l10n.contactsPerm, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              subtitle: Text(_hasContacts ? l10n.accessGranted : l10n.contactsPermDesc, style: const TextStyle(color: AppColors.textLight)),
              trailing: _hasContacts
                  ? const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 28)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await Permission.contacts.request();
                        _checkPermissions();
                      },
                      child: Text(l10n.grant, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          SoftContainer(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.sms, color: _isDefaultSms ? AppColors.accentGreen : Colors.redAccent),
              title: Text(l10n.smsManagement, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              subtitle: Text(_isDefaultSms ? l10n.defaultSet : l10n.smsManagementDesc, style: const TextStyle(color: AppColors.textLight)),
              trailing: _isDefaultSms
                  ? const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 28)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await NativeCleanerService.requestDefaultSmsApp();
                        Future.delayed(const Duration(seconds: 2), _checkPermissions);
                      },
                      child: Text(l10n.set, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          SoftContainer(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.notifications_active, color: _hasNotification ? AppColors.accentGreen : Colors.redAccent),
              title: Text(l10n.notificationsPerm, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              subtitle: Text(_hasNotification ? l10n.accessGranted : l10n.notificationsPermDesc, style: const TextStyle(color: AppColors.textLight)),
              trailing: _hasNotification
                  ? const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 28)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await Permission.notification.request();
                        _checkPermissions();
                      },
                      child: Text(l10n.grant, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          SoftContainer(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.block, color: _hasCallScreening ? AppColors.accentGreen : Colors.redAccent),
              title: Text(l10n.interceptFilter, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              subtitle: Text(_hasCallScreening ? l10n.shieldActive : l10n.interceptFilterDesc, style: const TextStyle(color: AppColors.textLight)),
              trailing: _hasCallScreening
                  ? const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 28)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await NativeCleanerService.requestCallScreeningRole();
                        await Future.delayed(const Duration(seconds: 2));
                        _checkPermissions();
                      },
                      child: Text(l10n.activate, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          SoftContainer(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.battery_charging_full, color: _isIgnoringBattery ? AppColors.accentGreen : Colors.redAccent),
              title: Text(l10n.continuousExecution, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              subtitle: Text(_isIgnoringBattery ? l10n.exemptionGranted : l10n.continuousExecutionDesc, style: const TextStyle(color: AppColors.textLight)),
              trailing: _isIgnoringBattery
                  ? const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 28)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        await NativeCleanerService.requestBatteryExemption();
                        await Future.delayed(const Duration(seconds: 2));
                        _checkPermissions();
                      },
                      child: Text(l10n.exempt, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ),
          ),
          const SizedBox(height: 30),
          SoftContainer(
            backgroundColor: AppColors.cardBackground,
            child: Text(
              l10n.smsNote,
              style: const TextStyle(color: AppColors.textWhite, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 25),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
