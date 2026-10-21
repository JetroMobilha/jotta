// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'Jotta';

  @override
  String get appDescription => 'Ottimizzatore di Sistema';

  @override
  String get homeTitle => 'Jotta';

  @override
  String get optimizationActive => 'Ottimizzazione Attiva';

  @override
  String get optimizationInactive => 'Ottimizzazione Inattiva';

  @override
  String get pingsLabel => 'Pings: ';

  @override
  String get packetsLabel => ' | Pacchetti: ';

  @override
  String everyMins(int mins) {
    return 'ogni ${mins}m';
  }

  @override
  String everyHours(int hours) {
    return 'ogni ${hours}h';
  }

  @override
  String get disabled => 'Disat.';

  @override
  String get lastOptimization => 'Ultima ottimizzazione:';

  @override
  String get never => 'Mai';

  @override
  String get tapToOptimize => 'Tocca per ottimizzare';

  @override
  String get optimizeBtn => 'Ottimizza';

  @override
  String get vaultTitle => 'Registro Diagnostico';

  @override
  String get vaultSubtitle => 'Visualizza cronologia manutenzione e cache';

  @override
  String get contactsTitle => 'Filtro Entità';

  @override
  String contactsSubtitle(int count) {
    return '$count entità con regole attive';
  }

  @override
  String get scheduleTitle => 'Pianificazione Manutenzione';

  @override
  String get scheduleSubtitle => 'Configura routine di ottimizzazione';

  @override
  String get permissionRequired => 'Autorizzazione Richiesta';

  @override
  String get smsPermissionDesc =>
      'Per eliminare i messaggi privati, Jotta deve essere temporaneamente impostata come app SMS predefinita. Dopo la pulizia, verrà ripristinata l\'app originale.';

  @override
  String get cancel => 'Annulla';

  @override
  String get setAndClean => 'Imposta e Pulisci';

  @override
  String get optimizingSystemLogs => 'Ottimizzazione registri di sistema...';

  @override
  String get optimizationComplete => 'Ottimizzazione completata con successo.';

  @override
  String get restoreSmsAppTitle => 'Ripristina App Messaggi';

  @override
  String get restoreSmsAppDesc =>
      'Ottimizzazione terminata. Vuoi riaprire la tua app di messaggistica originale per impostarla di nuovo come predefinita?';

  @override
  String get later => 'Più Tardi';

  @override
  String get reopen => 'Riapri';

  @override
  String get clearVaultTitle => 'Svuotare il Registro?';

  @override
  String get clearVaultDesc =>
      'Sei sicuro di voler eliminare permanentemente tutti i registri? Questa azione non può essere annullata.';

  @override
  String get deleteGroupTitle => 'Elimina Gruppo';

  @override
  String deleteGroupDesc(String contactName, String phoneNumber) {
    return 'Sei sicuro di voler eliminare permanentemente tutti i registri di $contactName ($phoneNumber)?';
  }

  @override
  String get deleteAll => 'Elimina Tutto';

  @override
  String get delete => 'Elimina';

  @override
  String get logIsClean => 'Il registro è pulito.';

  @override
  String get logIsCleanDesc =>
      'I registri e i dati delle entità ottimizzate appariranno qui per verifica tecnica.';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String retainedLogs(int count) {
    return '$count registri conservati';
  }

  @override
  String get callLog => 'Registro Chiamate';

  @override
  String get textPacket => 'Pacchetto di Testo';

  @override
  String get callBlockedSource => 'Chiamata Bloccata alla Fonte';

  @override
  String get noRulesConfigured => 'Nessuna regola configurata.';

  @override
  String entitiesInGroup(int count) {
    return '$count entità nel gruppo';
  }

  @override
  String get unblockGroup => 'Sblocca Gruppo';

  @override
  String get blockEntireGroup => 'Blocca Tutto il Gruppo';

  @override
  String get unblockCalls => 'Sblocca Chiamate';

  @override
  String get rejectCallsImm => 'Rifiuta Chiamate Subito';

  @override
  String get call => 'Chiama';

  @override
  String get setGroup => 'Imposta Gruppo';

  @override
  String get groupNameHint => 'Nome Gruppo (es: Lavoro, Famiglia)';

  @override
  String get ok => 'OK';

  @override
  String get contactsPermDenied => 'Permesso contatti negato.';

  @override
  String get addContactManual => 'Aggiungi Contatto Manualmente';

  @override
  String get nameOptional => 'Nome (Opzionale)';

  @override
  String get number => 'Numero';

  @override
  String get selectExistingGroup => 'Seleziona Gruppo Esistente:';

  @override
  String get orCreateNewGroup => 'O crea un nuovo gruppo';

  @override
  String get save => 'Salva';

  @override
  String get callLogPermDenied => 'Permesso registro chiamate negato.';

  @override
  String get noCallLogsFound => 'Nessun registro chiamate trovato.';

  @override
  String get recentCalls => 'Chiamate Recenti';

  @override
  String get addContact => 'Aggiungi Contatto';

  @override
  String get fromCallLog => 'Dal Registro Chiamate';

  @override
  String get fromContactList => 'Dalla Lista Contatti';

  @override
  String get enterManually => 'Inserisci Manualmente';

  @override
  String get general => 'Generale';

  @override
  String get pingOptTitle => 'Ottimizzazione Ping (Chiamate)';

  @override
  String get pingOptDesc => 'Silenzioso e continuo';

  @override
  String get packetOptTitle => 'Ottimizzazione Pacchetti (SMS)';

  @override
  String get packetOptDesc => 'Sicuro (richiede notifica)';

  @override
  String everyTime(String time) {
    return 'Ogni $time';
  }

  @override
  String get delayAlerts => 'Avvisi di Ritardo';

  @override
  String get delayAlertsDesc => 'Emette un suono dopo 30m';

  @override
  String get diagnosticRetention => 'Conservazione Diagnostica';

  @override
  String get doNotSave => 'Non Salvare (Elimina diretto)';

  @override
  String get oneDay => '1 Giorno';

  @override
  String get sevenDays => '7 Giorni (Consigliato)';

  @override
  String get thirtyDays => '30 Giorni';

  @override
  String get systemResilience => 'Resilienza del Sistema';

  @override
  String get survivalMode => 'Modo di Sopravvivenza';

  @override
  String get survivalModeDesc =>
      'Impedisce la chiusura dell\'app mostrando una notifica di protezione continua sullo schermo.';

  @override
  String get permissions => 'Permessi';

  @override
  String get permissionsDesc =>
      'Affinché Jotta possa eliminare automaticamente le informazioni, devi concedere i seguenti accessi:';

  @override
  String get callLogPerm => 'Registro Chiamate';

  @override
  String get callLogPermDesc => 'Necessario per ottimizzare i ping di rete.';

  @override
  String get accessGranted => 'Accesso Concesso';

  @override
  String get grant => 'Concedi';

  @override
  String get contactsPerm => 'Contatti';

  @override
  String get contactsPermDesc => 'Aggiungi numeri dalla lista.';

  @override
  String get smsManagement => 'Gestione SMS';

  @override
  String get defaultSet => 'Predefinito Impostato';

  @override
  String get smsManagementDesc => 'Permesso per ottimizzazione pacchetti.';

  @override
  String get set => 'Imposta';

  @override
  String get notificationsPerm => 'Notifiche';

  @override
  String get notificationsPermDesc => 'Avvisi per ottimizzazione pacchetti.';

  @override
  String get interceptFilter => 'Filtro Intercettazione';

  @override
  String get shieldActive => 'Scudo Attivo';

  @override
  String get interceptFilterDesc => 'Rifiuta chiamate indesiderate.';

  @override
  String get activate => 'Attiva';

  @override
  String get continuousExecution => 'Esecuzione Continua';

  @override
  String get exemptionGranted => 'Esenzione Concessa';

  @override
  String get continuousExecutionDesc =>
      'Ignora limiti batteria per non sospendere.';

  @override
  String get exempt => 'Esenta';

  @override
  String get smsNote =>
      'Nota sugli SMS: Continuerai a ricevere le notifiche dei messaggi normalmente. Puoi annullare questa configurazione nelle impostazioni del telefono in qualsiasi momento.';

  @override
  String get healthCenterTitle => 'Centro Salute del Sistema';

  @override
  String get healthCenterDesc =>
      'Se la pulizia automatica non funziona in background, controlla le opzioni seguenti per impedire ad Android di bloccare l\'applicazione.';

  @override
  String get autoStartTitle => '1. Avvio Automatico (Auto-Start)';

  @override
  String get autoStartDesc =>
      'Produttori come Xiaomi, Oppo e Vivo bloccano l\'avvio automatico per sicurezza. Devi attivare questo permesso.';

  @override
  String get openAutoStartSettings => 'Apri Impostazioni Avvio Automatico';

  @override
  String get batteryRestrictionsTitle => '2. Restrizioni Batteria';

  @override
  String get batteryRestrictionsDesc =>
      'Android \'addormenta\' le app per risparmiare batteria (Deep Doze). Assicurati che l\'esenzione sia attiva.';

  @override
  String get ignoreBatteryLimits => 'Ignora Limiti Batteria';

  @override
  String get exemptionActive => 'Esenzione Attiva!';

  @override
  String get permRevocationTitle => '3. Revoca dei Permessi';

  @override
  String get permRevocationDesc =>
      'Su Android 11+, il sistema rimuove i permessi dalle app \'non utilizzate\'. Vai alle normali impostazioni dell\'app Jotta e disattiva \'Rimuovi permessi se l\'app non è in uso\'.';

  @override
  String get forceStopTitle => '4. Il Pericolo dell\'Arresto Forzato';

  @override
  String get forceStopDesc =>
      'Scorrere l\'app per chiuderla nelle finestre recenti è sicuro. Tuttavia, andare nelle impostazioni e cliccare su \'Termina\' uccide permanentemente il motore in background finché non tocchi di nuovo l\'icona Jotta.';
}
