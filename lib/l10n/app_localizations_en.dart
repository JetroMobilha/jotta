// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Jotta';

  @override
  String get appDescription => 'System Optimizer';

  @override
  String get homeTitle => 'Jotta';

  @override
  String get optimizationActive => 'Optimization Active';

  @override
  String get optimizationInactive => 'Optimization Inactive';

  @override
  String get pingsLabel => 'Pings: ';

  @override
  String get packetsLabel => ' | Packets: ';

  @override
  String everyMins(int mins) {
    return 'every ${mins}m';
  }

  @override
  String everyHours(int hours) {
    return 'every ${hours}h';
  }

  @override
  String get disabled => 'Off';

  @override
  String get lastOptimization => 'Last optimization:';

  @override
  String get never => 'Never';

  @override
  String get tapToOptimize => 'Tap to optimize now';

  @override
  String get optimizeBtn => 'Optimize';

  @override
  String get vaultTitle => 'Diagnostic Log';

  @override
  String get vaultSubtitle => 'View maintenance history and cache';

  @override
  String get contactsTitle => 'Entity Filter';

  @override
  String contactsSubtitle(int count) {
    return '$count entities with active rules';
  }

  @override
  String get scheduleTitle => 'Maintenance Schedule';

  @override
  String get scheduleSubtitle => 'Configure optimization routines';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get smsPermissionDesc =>
      'To erase private messages, Jotta needs to be temporarily set as the default SMS app. After cleaning, your original app will be restored.';

  @override
  String get cancel => 'Cancel';

  @override
  String get setAndClean => 'Set & Clean';

  @override
  String get optimizingSystemLogs => 'Optimizing system logs...';

  @override
  String get optimizationComplete => 'Optimization completed successfully.';

  @override
  String get restoreSmsAppTitle => 'Restore Messaging App';

  @override
  String get restoreSmsAppDesc =>
      'Optimization finished. Do you want to reopen your original messaging app to set it as default again?';

  @override
  String get later => 'Later';

  @override
  String get reopen => 'Reopen';

  @override
  String get clearVaultTitle => 'Clear Log?';

  @override
  String get clearVaultDesc =>
      'Are you sure you want to permanently delete all logs? This action cannot be undone.';

  @override
  String get deleteGroupTitle => 'Delete Group';

  @override
  String deleteGroupDesc(String contactName, String phoneNumber) {
    return 'Are you sure you want to permanently delete all logs from $contactName ($phoneNumber)?';
  }

  @override
  String get deleteAll => 'Delete All';

  @override
  String get delete => 'Delete';

  @override
  String get logIsClean => 'The Log is clean.';

  @override
  String get logIsCleanDesc =>
      'Logs and data of optimized entities will appear here for technical verification.';

  @override
  String get unknown => 'Unknown';

  @override
  String retainedLogs(int count) {
    return '$count retained logs';
  }

  @override
  String get callLog => 'Call Log';

  @override
  String get textPacket => 'Text Packet';

  @override
  String get callBlockedSource => 'Call Blocked at Source';

  @override
  String get noRulesConfigured => 'No rules configured.';

  @override
  String entitiesInGroup(int count) {
    return '$count entities in group';
  }

  @override
  String get unblockGroup => 'Unblock Group';

  @override
  String get blockEntireGroup => 'Block Entire Group';

  @override
  String get unblockCalls => 'Unblock Calls';

  @override
  String get rejectCallsImm => 'Reject Calls Immediately';

  @override
  String get call => 'Call';

  @override
  String get setGroup => 'Set Group';

  @override
  String get groupNameHint => 'Group Name (e.g., Work, Family)';

  @override
  String get ok => 'OK';

  @override
  String get contactsPermDenied => 'Contacts permission denied.';

  @override
  String get addContactManual => 'Add Contact Manually';

  @override
  String get nameOptional => 'Name (Optional)';

  @override
  String get number => 'Number';

  @override
  String get selectExistingGroup => 'Select Existing Group:';

  @override
  String get orCreateNewGroup => 'Or create a new group';

  @override
  String get save => 'Save';

  @override
  String get callLogPermDenied => 'Call log permission denied.';

  @override
  String get noCallLogsFound => 'No call logs found.';

  @override
  String get recentCalls => 'Recent Calls';

  @override
  String get addContact => 'Add Contact';

  @override
  String get fromCallLog => 'From Call Log';

  @override
  String get fromContactList => 'From Contact List';

  @override
  String get enterManually => 'Enter Manually';

  @override
  String get general => 'General';

  @override
  String get pingOptTitle => 'Ping Optimization (Calls)';

  @override
  String get pingOptDesc => 'Silent and continuous';

  @override
  String get packetOptTitle => 'Packet Optimization (SMS)';

  @override
  String get packetOptDesc => 'Secure (requires notification)';

  @override
  String everyTime(String time) {
    return 'Every $time';
  }

  @override
  String get delayAlerts => 'Delay Alerts';

  @override
  String get delayAlertsDesc => 'Emits sound if not cleaned after 30m';

  @override
  String get diagnosticRetention => 'Diagnostic Retention';

  @override
  String get doNotSave => 'Do Not Save (Delete directly)';

  @override
  String get oneDay => '1 Day';

  @override
  String get sevenDays => '7 Days (Recommended)';

  @override
  String get thirtyDays => '30 Days';

  @override
  String get systemResilience => 'System Resilience';

  @override
  String get survivalMode => 'Survival Mode';

  @override
  String get survivalModeDesc =>
      'Prevents app closure by displaying a continuous protection notification on screen.';

  @override
  String get permissions => 'Permissions';

  @override
  String get permissionsDesc =>
      'For Jotta to automatically delete information, you must grant the following accesses:';

  @override
  String get callLogPerm => 'Call Log';

  @override
  String get callLogPermDesc => 'Required to optimize network pings.';

  @override
  String get accessGranted => 'Access Granted';

  @override
  String get grant => 'Grant';

  @override
  String get contactsPerm => 'Contacts';

  @override
  String get contactsPermDesc => 'Add numbers from list.';

  @override
  String get smsManagement => 'SMS Management';

  @override
  String get defaultSet => 'Default Set';

  @override
  String get smsManagementDesc => 'Permission for packet optimization.';

  @override
  String get set => 'Set';

  @override
  String get notificationsPerm => 'Notifications';

  @override
  String get notificationsPermDesc => 'Alerts for packet optimization.';

  @override
  String get interceptFilter => 'Interception Filter';

  @override
  String get shieldActive => 'Shield Active';

  @override
  String get interceptFilterDesc => 'Reject unwanted calls.';

  @override
  String get activate => 'Activate';

  @override
  String get continuousExecution => 'Continuous Execution';

  @override
  String get exemptionGranted => 'Exemption Granted';

  @override
  String get continuousExecutionDesc =>
      'Ignore battery limits to prevent sleeping.';

  @override
  String get exempt => 'Exempt';

  @override
  String get smsNote =>
      'SMS Note: You will continue to receive normal message notifications. You can revert this setting in your phone settings at any time.';

  @override
  String get healthCenterTitle => 'System Health Center';

  @override
  String get healthCenterDesc =>
      'If automatic cleaning isn\'t working in the background, check the options below to prevent Android from freezing the app.';

  @override
  String get autoStartTitle => '1. Auto-Start';

  @override
  String get autoStartDesc =>
      'Manufacturers like Xiaomi, Oppo, and Vivo block auto-start for security. You must enable this permission.';

  @override
  String get openAutoStartSettings => 'Open Auto-Start Settings';

  @override
  String get batteryRestrictionsTitle => '2. Battery Restrictions';

  @override
  String get batteryRestrictionsDesc =>
      'Android \'sleeps\' apps to save battery (Deep Doze). Ensure exemption is active.';

  @override
  String get ignoreBatteryLimits => 'Ignore Battery Limits';

  @override
  String get exemptionActive => 'Exemption Active!';

  @override
  String get permRevocationTitle => '3. Permission Revocation';

  @override
  String get permRevocationDesc =>
      'On Android 11+, the system removes permissions from \'unused\' apps. Go to Jotta\'s standard settings and disable \'Remove permissions if app is unused\'.';

  @override
  String get forceStopTitle => '4. The Danger of \'Force Stop\'';

  @override
  String get forceStopDesc =>
      'Swiping the app closed in recent windows is perfectly safe. However, going to settings and clicking \'Force Stop\' permanently kills the background engine until you click the Jotta icon again to resurrect it.';
}
