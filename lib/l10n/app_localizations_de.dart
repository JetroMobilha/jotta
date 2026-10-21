// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Jotta';

  @override
  String get appDescription => 'Systemoptimierer';

  @override
  String get homeTitle => 'Jotta';

  @override
  String get optimizationActive => 'Optimierung Aktiv';

  @override
  String get optimizationInactive => 'Optimierung Inaktiv';

  @override
  String get pingsLabel => 'Pings: ';

  @override
  String get packetsLabel => ' | Pakete: ';

  @override
  String everyMins(int mins) {
    return 'alle ${mins}m';
  }

  @override
  String everyHours(int hours) {
    return 'alle ${hours}h';
  }

  @override
  String get disabled => 'Aus';

  @override
  String get lastOptimization => 'Letzte Optimierung:';

  @override
  String get never => 'Niemals';

  @override
  String get tapToOptimize => 'Tippen zum Optimieren';

  @override
  String get optimizeBtn => 'Optimieren';

  @override
  String get vaultTitle => 'Diagnoseprotokoll';

  @override
  String get vaultSubtitle => 'Wartungsverlauf und Cache anzeigen';

  @override
  String get contactsTitle => 'Entitätsfilter';

  @override
  String contactsSubtitle(int count) {
    return '$count Entitäten mit aktiven Regeln';
  }

  @override
  String get scheduleTitle => 'Wartungsplan';

  @override
  String get scheduleSubtitle => 'Optimierungsroutinen konfigurieren';

  @override
  String get permissionRequired => 'Erlaubnis Erforderlich';

  @override
  String get smsPermissionDesc =>
      'Um private Nachrichten zu löschen, muss Jotta vorübergehend als Standard-SMS-App festgelegt werden. Nach der Bereinigung wird Ihre ursprüngliche App wiederhergestellt.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get setAndClean => 'Festlegen & Bereinigen';

  @override
  String get optimizingSystemLogs => 'Systemprotokolle werden optimiert...';

  @override
  String get optimizationComplete => 'Optimierung erfolgreich abgeschlossen.';

  @override
  String get restoreSmsAppTitle => 'Nachrichten-App Wiederherstellen';

  @override
  String get restoreSmsAppDesc =>
      'Die Optimierung ist abgeschlossen. Möchten Sie Ihre ursprüngliche Nachrichten-App wieder öffnen, um sie wieder als Standard festzulegen?';

  @override
  String get later => 'Später';

  @override
  String get reopen => 'Wieder öffnen';

  @override
  String get clearVaultTitle => 'Protokoll Löschen?';

  @override
  String get clearVaultDesc =>
      'Möchten Sie wirklich alle Protokolle dauerhaft löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteGroupTitle => 'Gruppe Löschen';

  @override
  String deleteGroupDesc(String contactName, String phoneNumber) {
    return 'Möchten Sie wirklich alle Protokolle von $contactName ($phoneNumber) dauerhaft löschen?';
  }

  @override
  String get deleteAll => 'Alles Löschen';

  @override
  String get delete => 'Löschen';

  @override
  String get logIsClean => 'Das Protokoll ist sauber.';

  @override
  String get logIsCleanDesc =>
      'Protokolle und Daten der optimierten Entitäten werden hier zur technischen Überprüfung angezeigt.';

  @override
  String get unknown => 'Unbekannt';

  @override
  String retainedLogs(int count) {
    return '$count gespeicherte Protokolle';
  }

  @override
  String get callLog => 'Anrufprotokoll';

  @override
  String get textPacket => 'Textpaket';

  @override
  String get callBlockedSource => 'Anruf an der Quelle blockiert';

  @override
  String get noRulesConfigured => 'Keine Regeln konfiguriert.';

  @override
  String entitiesInGroup(int count) {
    return '$count Entitäten in der Gruppe';
  }

  @override
  String get unblockGroup => 'Gruppe Entsperren';

  @override
  String get blockEntireGroup => 'Ganze Gruppe Sperren';

  @override
  String get unblockCalls => 'Anrufe Entsperren';

  @override
  String get rejectCallsImm => 'Anrufe Sofort Abweisen';

  @override
  String get call => 'Anrufen';

  @override
  String get setGroup => 'Gruppe Festlegen';

  @override
  String get groupNameHint => 'Gruppenname (z.B. Arbeit, Familie)';

  @override
  String get ok => 'OK';

  @override
  String get contactsPermDenied => 'Kontaktberechtigung verweigert.';

  @override
  String get addContactManual => 'Kontakt Manuell Hinzufügen';

  @override
  String get nameOptional => 'Name (Optional)';

  @override
  String get number => 'Nummer';

  @override
  String get selectExistingGroup => 'Bestehende Gruppe Auswählen:';

  @override
  String get orCreateNewGroup => 'Oder eine neue Gruppe erstellen';

  @override
  String get save => 'Speichern';

  @override
  String get callLogPermDenied => 'Berechtigung für Anrufprotokoll verweigert.';

  @override
  String get noCallLogsFound => 'Keine Anrufprotokolle gefunden.';

  @override
  String get recentCalls => 'Letzte Anrufe';

  @override
  String get addContact => 'Kontakt Hinzufügen';

  @override
  String get fromCallLog => 'Aus dem Anrufprotokoll';

  @override
  String get fromContactList => 'Aus der Kontaktliste';

  @override
  String get enterManually => 'Manuell Eingeben';

  @override
  String get general => 'Allgemein';

  @override
  String get pingOptTitle => 'Ping-Optimierung (Anrufe)';

  @override
  String get pingOptDesc => 'Lautlos und kontinuierlich';

  @override
  String get packetOptTitle => 'Paket-Optimierung (SMS)';

  @override
  String get packetOptDesc => 'Sicher (erfordert Benachrichtigung)';

  @override
  String everyTime(String time) {
    return 'Alle $time';
  }

  @override
  String get delayAlerts => 'Verzögerungswarnungen';

  @override
  String get delayAlertsDesc => 'Gibt nach 30 Min. Ton aus';

  @override
  String get diagnosticRetention => 'Diagnose-Speicherung';

  @override
  String get doNotSave => 'Nicht Speichern (Direkt löschen)';

  @override
  String get oneDay => '1 Tag';

  @override
  String get sevenDays => '7 Tage (Empfohlen)';

  @override
  String get thirtyDays => '30 Tage';

  @override
  String get systemResilience => 'Systemresilienz';

  @override
  String get survivalMode => 'Überlebensmodus';

  @override
  String get survivalModeDesc =>
      'Verhindert das Schließen der App durch eine kontinuierliche Schutzbenachrichtigung auf dem Bildschirm.';

  @override
  String get permissions => 'Berechtigungen';

  @override
  String get permissionsDesc =>
      'Damit Jotta automatisch Informationen löschen kann, müssen Sie folgende Zugriffe gewähren:';

  @override
  String get callLogPerm => 'Anrufprotokoll';

  @override
  String get callLogPermDesc =>
      'Erforderlich zur Optimierung von Netzwerk-Pings.';

  @override
  String get accessGranted => 'Zugriff Gewährt';

  @override
  String get grant => 'Gewähren';

  @override
  String get contactsPerm => 'Kontakte';

  @override
  String get contactsPermDesc => 'Nummern aus der Liste hinzufügen.';

  @override
  String get smsManagement => 'SMS-Verwaltung';

  @override
  String get defaultSet => 'Standard Festgelegt';

  @override
  String get smsManagementDesc => 'Berechtigung zur Paket-Optimierung.';

  @override
  String get set => 'Festlegen';

  @override
  String get notificationsPerm => 'Benachrichtigungen';

  @override
  String get notificationsPermDesc => 'Warnungen zur Paket-Optimierung.';

  @override
  String get interceptFilter => 'Abfangfilter';

  @override
  String get shieldActive => 'Schild Aktiv';

  @override
  String get interceptFilterDesc => 'Unerwünschte Anrufe abweisen.';

  @override
  String get activate => 'Aktivieren';

  @override
  String get continuousExecution => 'Kontinuierliche Ausführung';

  @override
  String get exemptionGranted => 'Ausnahme Gewährt';

  @override
  String get continuousExecutionDesc =>
      'Batterielimit ignorieren, um Schlafmodus zu verhindern.';

  @override
  String get exempt => 'Ausnehmen';

  @override
  String get smsNote =>
      'Hinweis zu SMS: Sie erhalten weiterhin normal Nachrichtenbenachrichtigungen. Sie können diese Einstellung jederzeit in den Telefoneinstellungen rückgängig machen.';

  @override
  String get healthCenterTitle => 'System-Gesundheitszentrum';

  @override
  String get healthCenterDesc =>
      'Wenn die automatische Bereinigung im Hintergrund nicht funktioniert, überprüfen Sie die unten stehenden Optionen, um zu verhindern, dass Android die Anwendung einfriert.';

  @override
  String get autoStartTitle => '1. Automatischer Start (Auto-Start)';

  @override
  String get autoStartDesc =>
      'Hersteller wie Xiaomi, Oppo und Vivo blockieren den Autostart aus Sicherheitsgründen. Sie müssen diese Berechtigung aktivieren.';

  @override
  String get openAutoStartSettings => 'Auto-Start Einstellungen Öffnen';

  @override
  String get batteryRestrictionsTitle => '2. Batteriebeschränkungen';

  @override
  String get batteryRestrictionsDesc =>
      'Android versetzt Apps in den \'Schlafmodus\' (Deep Doze). Stellen Sie sicher, dass die Ausnahme aktiv ist.';

  @override
  String get ignoreBatteryLimits => 'Batteriegrenzen Ignorieren';

  @override
  String get exemptionActive => 'Ausnahme Aktiv!';

  @override
  String get permRevocationTitle => '3. Berechtigungswiderruf';

  @override
  String get permRevocationDesc =>
      'Ab Android 11 entfernt das System Berechtigungen von \'unbenutzten\' Apps. Gehen Sie zu den normalen Jotta-Einstellungen und deaktivieren Sie \'Berechtigungen entfernen, wenn App unbenutzt\'.';

  @override
  String get forceStopTitle => '4. Die Gefahr von \'Stopp Erzwingen\'';

  @override
  String get forceStopDesc =>
      'Die App in den letzten Fenstern nach oben zu wischen, ist sicher. Wenn Sie jedoch in den Einstellungen auf \'Stopp erzwingen\' klicken, wird die Hintergrund-Engine dauerhaft beendet, bis Sie erneut auf das Jotta-Symbol tippen.';
}
