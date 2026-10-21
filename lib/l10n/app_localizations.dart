import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Jotta'**
  String get appName;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'System Optimizer'**
  String get appDescription;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Jotta'**
  String get homeTitle;

  /// No description provided for @optimizationActive.
  ///
  /// In en, this message translates to:
  /// **'Optimization Active'**
  String get optimizationActive;

  /// No description provided for @optimizationInactive.
  ///
  /// In en, this message translates to:
  /// **'Optimization Inactive'**
  String get optimizationInactive;

  /// No description provided for @pingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pings: '**
  String get pingsLabel;

  /// No description provided for @packetsLabel.
  ///
  /// In en, this message translates to:
  /// **' | Packets: '**
  String get packetsLabel;

  /// No description provided for @everyMins.
  ///
  /// In en, this message translates to:
  /// **'every {mins}m'**
  String everyMins(int mins);

  /// No description provided for @everyHours.
  ///
  /// In en, this message translates to:
  /// **'every {hours}h'**
  String everyHours(int hours);

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get disabled;

  /// No description provided for @lastOptimization.
  ///
  /// In en, this message translates to:
  /// **'Last optimization:'**
  String get lastOptimization;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @tapToOptimize.
  ///
  /// In en, this message translates to:
  /// **'Tap to optimize now'**
  String get tapToOptimize;

  /// No description provided for @optimizeBtn.
  ///
  /// In en, this message translates to:
  /// **'Optimize'**
  String get optimizeBtn;

  /// No description provided for @vaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic Log'**
  String get vaultTitle;

  /// No description provided for @vaultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View maintenance history and cache'**
  String get vaultSubtitle;

  /// No description provided for @contactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Entity Filter'**
  String get contactsTitle;

  /// No description provided for @contactsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} entities with active rules'**
  String contactsSubtitle(int count);

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Schedule'**
  String get scheduleTitle;

  /// No description provided for @scheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure optimization routines'**
  String get scheduleSubtitle;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// No description provided for @smsPermissionDesc.
  ///
  /// In en, this message translates to:
  /// **'To erase private messages, Jotta needs to be temporarily set as the default SMS app. After cleaning, your original app will be restored.'**
  String get smsPermissionDesc;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @setAndClean.
  ///
  /// In en, this message translates to:
  /// **'Set & Clean'**
  String get setAndClean;

  /// No description provided for @optimizingSystemLogs.
  ///
  /// In en, this message translates to:
  /// **'Optimizing system logs...'**
  String get optimizingSystemLogs;

  /// No description provided for @optimizationComplete.
  ///
  /// In en, this message translates to:
  /// **'Optimization completed successfully.'**
  String get optimizationComplete;

  /// No description provided for @restoreSmsAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Messaging App'**
  String get restoreSmsAppTitle;

  /// No description provided for @restoreSmsAppDesc.
  ///
  /// In en, this message translates to:
  /// **'Optimization finished. Do you want to reopen your original messaging app to set it as default again?'**
  String get restoreSmsAppDesc;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @reopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get reopen;

  /// No description provided for @clearVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear Log?'**
  String get clearVaultTitle;

  /// No description provided for @clearVaultDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete all logs? This action cannot be undone.'**
  String get clearVaultDesc;

  /// No description provided for @deleteGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get deleteGroupTitle;

  /// No description provided for @deleteGroupDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete all logs from {contactName} ({phoneNumber})?'**
  String deleteGroupDesc(String contactName, String phoneNumber);

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @logIsClean.
  ///
  /// In en, this message translates to:
  /// **'The Log is clean.'**
  String get logIsClean;

  /// No description provided for @logIsCleanDesc.
  ///
  /// In en, this message translates to:
  /// **'Logs and data of optimized entities will appear here for technical verification.'**
  String get logIsCleanDesc;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @retainedLogs.
  ///
  /// In en, this message translates to:
  /// **'{count} retained logs'**
  String retainedLogs(int count);

  /// No description provided for @callLog.
  ///
  /// In en, this message translates to:
  /// **'Call Log'**
  String get callLog;

  /// No description provided for @textPacket.
  ///
  /// In en, this message translates to:
  /// **'Text Packet'**
  String get textPacket;

  /// No description provided for @callBlockedSource.
  ///
  /// In en, this message translates to:
  /// **'Call Blocked at Source'**
  String get callBlockedSource;

  /// No description provided for @noRulesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No rules configured.'**
  String get noRulesConfigured;

  /// No description provided for @entitiesInGroup.
  ///
  /// In en, this message translates to:
  /// **'{count} entities in group'**
  String entitiesInGroup(int count);

  /// No description provided for @unblockGroup.
  ///
  /// In en, this message translates to:
  /// **'Unblock Group'**
  String get unblockGroup;

  /// No description provided for @blockEntireGroup.
  ///
  /// In en, this message translates to:
  /// **'Block Entire Group'**
  String get blockEntireGroup;

  /// No description provided for @unblockCalls.
  ///
  /// In en, this message translates to:
  /// **'Unblock Calls'**
  String get unblockCalls;

  /// No description provided for @rejectCallsImm.
  ///
  /// In en, this message translates to:
  /// **'Reject Calls Immediately'**
  String get rejectCallsImm;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @setGroup.
  ///
  /// In en, this message translates to:
  /// **'Set Group'**
  String get setGroup;

  /// No description provided for @groupNameHint.
  ///
  /// In en, this message translates to:
  /// **'Group Name (e.g., Work, Family)'**
  String get groupNameHint;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @contactsPermDenied.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission denied.'**
  String get contactsPermDenied;

  /// No description provided for @addContactManual.
  ///
  /// In en, this message translates to:
  /// **'Add Contact Manually'**
  String get addContactManual;

  /// No description provided for @nameOptional.
  ///
  /// In en, this message translates to:
  /// **'Name (Optional)'**
  String get nameOptional;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @selectExistingGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Existing Group:'**
  String get selectExistingGroup;

  /// No description provided for @orCreateNewGroup.
  ///
  /// In en, this message translates to:
  /// **'Or create a new group'**
  String get orCreateNewGroup;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @callLogPermDenied.
  ///
  /// In en, this message translates to:
  /// **'Call log permission denied.'**
  String get callLogPermDenied;

  /// No description provided for @noCallLogsFound.
  ///
  /// In en, this message translates to:
  /// **'No call logs found.'**
  String get noCallLogsFound;

  /// No description provided for @recentCalls.
  ///
  /// In en, this message translates to:
  /// **'Recent Calls'**
  String get recentCalls;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @fromCallLog.
  ///
  /// In en, this message translates to:
  /// **'From Call Log'**
  String get fromCallLog;

  /// No description provided for @fromContactList.
  ///
  /// In en, this message translates to:
  /// **'From Contact List'**
  String get fromContactList;

  /// No description provided for @enterManually.
  ///
  /// In en, this message translates to:
  /// **'Enter Manually'**
  String get enterManually;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @pingOptTitle.
  ///
  /// In en, this message translates to:
  /// **'Ping Optimization (Calls)'**
  String get pingOptTitle;

  /// No description provided for @pingOptDesc.
  ///
  /// In en, this message translates to:
  /// **'Silent and continuous'**
  String get pingOptDesc;

  /// No description provided for @packetOptTitle.
  ///
  /// In en, this message translates to:
  /// **'Packet Optimization (SMS)'**
  String get packetOptTitle;

  /// No description provided for @packetOptDesc.
  ///
  /// In en, this message translates to:
  /// **'Secure (requires notification)'**
  String get packetOptDesc;

  /// No description provided for @everyTime.
  ///
  /// In en, this message translates to:
  /// **'Every {time}'**
  String everyTime(String time);

  /// No description provided for @delayAlerts.
  ///
  /// In en, this message translates to:
  /// **'Delay Alerts'**
  String get delayAlerts;

  /// No description provided for @delayAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Emits sound if not cleaned after 30m'**
  String get delayAlertsDesc;

  /// No description provided for @diagnosticRetention.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic Retention'**
  String get diagnosticRetention;

  /// No description provided for @doNotSave.
  ///
  /// In en, this message translates to:
  /// **'Do Not Save (Delete directly)'**
  String get doNotSave;

  /// No description provided for @oneDay.
  ///
  /// In en, this message translates to:
  /// **'1 Day'**
  String get oneDay;

  /// No description provided for @sevenDays.
  ///
  /// In en, this message translates to:
  /// **'7 Days (Recommended)'**
  String get sevenDays;

  /// No description provided for @thirtyDays.
  ///
  /// In en, this message translates to:
  /// **'30 Days'**
  String get thirtyDays;

  /// No description provided for @systemResilience.
  ///
  /// In en, this message translates to:
  /// **'System Resilience'**
  String get systemResilience;

  /// No description provided for @survivalMode.
  ///
  /// In en, this message translates to:
  /// **'Survival Mode'**
  String get survivalMode;

  /// No description provided for @survivalModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Prevents app closure by displaying a continuous protection notification on screen.'**
  String get survivalModeDesc;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @permissionsDesc.
  ///
  /// In en, this message translates to:
  /// **'For Jotta to automatically delete information, you must grant the following accesses:'**
  String get permissionsDesc;

  /// No description provided for @callLogPerm.
  ///
  /// In en, this message translates to:
  /// **'Call Log'**
  String get callLogPerm;

  /// No description provided for @callLogPermDesc.
  ///
  /// In en, this message translates to:
  /// **'Required to optimize network pings.'**
  String get callLogPermDesc;

  /// No description provided for @accessGranted.
  ///
  /// In en, this message translates to:
  /// **'Access Granted'**
  String get accessGranted;

  /// No description provided for @grant.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get grant;

  /// No description provided for @contactsPerm.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contactsPerm;

  /// No description provided for @contactsPermDesc.
  ///
  /// In en, this message translates to:
  /// **'Add numbers from list.'**
  String get contactsPermDesc;

  /// No description provided for @smsManagement.
  ///
  /// In en, this message translates to:
  /// **'SMS Management'**
  String get smsManagement;

  /// No description provided for @defaultSet.
  ///
  /// In en, this message translates to:
  /// **'Default Set'**
  String get defaultSet;

  /// No description provided for @smsManagementDesc.
  ///
  /// In en, this message translates to:
  /// **'Permission for packet optimization.'**
  String get smsManagementDesc;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @notificationsPerm.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsPerm;

  /// No description provided for @notificationsPermDesc.
  ///
  /// In en, this message translates to:
  /// **'Alerts for packet optimization.'**
  String get notificationsPermDesc;

  /// No description provided for @interceptFilter.
  ///
  /// In en, this message translates to:
  /// **'Interception Filter'**
  String get interceptFilter;

  /// No description provided for @shieldActive.
  ///
  /// In en, this message translates to:
  /// **'Shield Active'**
  String get shieldActive;

  /// No description provided for @interceptFilterDesc.
  ///
  /// In en, this message translates to:
  /// **'Reject unwanted calls.'**
  String get interceptFilterDesc;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @continuousExecution.
  ///
  /// In en, this message translates to:
  /// **'Continuous Execution'**
  String get continuousExecution;

  /// No description provided for @exemptionGranted.
  ///
  /// In en, this message translates to:
  /// **'Exemption Granted'**
  String get exemptionGranted;

  /// No description provided for @continuousExecutionDesc.
  ///
  /// In en, this message translates to:
  /// **'Ignore battery limits to prevent sleeping.'**
  String get continuousExecutionDesc;

  /// No description provided for @exempt.
  ///
  /// In en, this message translates to:
  /// **'Exempt'**
  String get exempt;

  /// No description provided for @smsNote.
  ///
  /// In en, this message translates to:
  /// **'SMS Note: You will continue to receive normal message notifications. You can revert this setting in your phone settings at any time.'**
  String get smsNote;

  /// No description provided for @healthCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'System Health Center'**
  String get healthCenterTitle;

  /// No description provided for @healthCenterDesc.
  ///
  /// In en, this message translates to:
  /// **'If automatic cleaning isn\'t working in the background, check the options below to prevent Android from freezing the app.'**
  String get healthCenterDesc;

  /// No description provided for @autoStartTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Auto-Start'**
  String get autoStartTitle;

  /// No description provided for @autoStartDesc.
  ///
  /// In en, this message translates to:
  /// **'Manufacturers like Xiaomi, Oppo, and Vivo block auto-start for security. You must enable this permission.'**
  String get autoStartDesc;

  /// No description provided for @openAutoStartSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Auto-Start Settings'**
  String get openAutoStartSettings;

  /// No description provided for @batteryRestrictionsTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Battery Restrictions'**
  String get batteryRestrictionsTitle;

  /// No description provided for @batteryRestrictionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Android \'sleeps\' apps to save battery (Deep Doze). Ensure exemption is active.'**
  String get batteryRestrictionsDesc;

  /// No description provided for @ignoreBatteryLimits.
  ///
  /// In en, this message translates to:
  /// **'Ignore Battery Limits'**
  String get ignoreBatteryLimits;

  /// No description provided for @exemptionActive.
  ///
  /// In en, this message translates to:
  /// **'Exemption Active!'**
  String get exemptionActive;

  /// No description provided for @permRevocationTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Permission Revocation'**
  String get permRevocationTitle;

  /// No description provided for @permRevocationDesc.
  ///
  /// In en, this message translates to:
  /// **'On Android 11+, the system removes permissions from \'unused\' apps. Go to Jotta\'s standard settings and disable \'Remove permissions if app is unused\'.'**
  String get permRevocationDesc;

  /// No description provided for @forceStopTitle.
  ///
  /// In en, this message translates to:
  /// **'4. The Danger of \'Force Stop\''**
  String get forceStopTitle;

  /// No description provided for @forceStopDesc.
  ///
  /// In en, this message translates to:
  /// **'Swiping the app closed in recent windows is perfectly safe. However, going to settings and clicking \'Force Stop\' permanently kills the background engine until you click the Jotta icon again to resurrect it.'**
  String get forceStopDesc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
