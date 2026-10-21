// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Jotta';

  @override
  String get appDescription => 'Optimiseur de Système';

  @override
  String get homeTitle => 'Jotta';

  @override
  String get optimizationActive => 'Optimisation Active';

  @override
  String get optimizationInactive => 'Optimisation Inactive';

  @override
  String get pingsLabel => 'Pings: ';

  @override
  String get packetsLabel => ' | Paquets: ';

  @override
  String everyMins(int mins) {
    return 'chaque ${mins}m';
  }

  @override
  String everyHours(int hours) {
    return 'chaque ${hours}h';
  }

  @override
  String get disabled => 'Désac.';

  @override
  String get lastOptimization => 'Dernière optimisation:';

  @override
  String get never => 'Jamais';

  @override
  String get tapToOptimize => 'Appuyez pour optimiser';

  @override
  String get optimizeBtn => 'Optimiser';

  @override
  String get vaultTitle => 'Journal de Diagnostic';

  @override
  String get vaultSubtitle => 'Voir l\'historique de maintenance et le cache';

  @override
  String get contactsTitle => 'Filtre d\'Entités';

  @override
  String contactsSubtitle(int count) {
    return '$count entités avec règles actives';
  }

  @override
  String get scheduleTitle => 'Planification de Maintenance';

  @override
  String get scheduleSubtitle => 'Configurer les routines d\'optimisation';

  @override
  String get permissionRequired => 'Autorisation Requise';

  @override
  String get smsPermissionDesc =>
      'Pour effacer les messages privés, Jotta doit être temporairement définie comme l\'application SMS par défaut. Après le nettoyage, votre application d\'origine sera restaurée.';

  @override
  String get cancel => 'Annuler';

  @override
  String get setAndClean => 'Définir et Nettoyer';

  @override
  String get optimizingSystemLogs => 'Optimisation des journaux système...';

  @override
  String get optimizationComplete => 'Optimisation terminée avec succès.';

  @override
  String get restoreSmsAppTitle => 'Restaurer l\'App de Messages';

  @override
  String get restoreSmsAppDesc =>
      'L\'optimisation est terminée. Voulez-vous rouvrir votre application de messagerie d\'origine pour la définir à nouveau comme application par défaut ?';

  @override
  String get later => 'Plus Tard';

  @override
  String get reopen => 'Rouvrir';

  @override
  String get clearVaultTitle => 'Effacer le Journal ?';

  @override
  String get clearVaultDesc =>
      'Êtes-vous sûr de vouloir supprimer définitivement tous les journaux ? Cette action ne peut pas être annulée.';

  @override
  String get deleteGroupTitle => 'Supprimer le Groupe';

  @override
  String deleteGroupDesc(String contactName, String phoneNumber) {
    return 'Êtes-vous sûr de vouloir supprimer définitivement tous les journaux de $contactName ($phoneNumber) ?';
  }

  @override
  String get deleteAll => 'Tout Supprimer';

  @override
  String get delete => 'Supprimer';

  @override
  String get logIsClean => 'Le journal est propre.';

  @override
  String get logIsCleanDesc =>
      'Les journaux et données des entités optimisées apparaîtront ici pour vérification technique.';

  @override
  String get unknown => 'Inconnu';

  @override
  String retainedLogs(int count) {
    return '$count journaux conservés';
  }

  @override
  String get callLog => 'Journal d\'Appels';

  @override
  String get textPacket => 'Paquet de Texte';

  @override
  String get callBlockedSource => 'Appel Bloqué à la Source';

  @override
  String get noRulesConfigured => 'Aucune règle configurée.';

  @override
  String entitiesInGroup(int count) {
    return '$count entités dans le groupe';
  }

  @override
  String get unblockGroup => 'Débloquer le Groupe';

  @override
  String get blockEntireGroup => 'Bloquer Tout le Groupe';

  @override
  String get unblockCalls => 'Débloquer les Appels';

  @override
  String get rejectCallsImm => 'Rejeter les Appels Immédiatement';

  @override
  String get call => 'Appeler';

  @override
  String get setGroup => 'Définir le Groupe';

  @override
  String get groupNameHint => 'Nom du Groupe (ex: Travail, Famille)';

  @override
  String get ok => 'OK';

  @override
  String get contactsPermDenied => 'Autorisation des contacts refusée.';

  @override
  String get addContactManual => 'Ajouter un Contact Manuellement';

  @override
  String get nameOptional => 'Nom (Optionnel)';

  @override
  String get number => 'Numéro';

  @override
  String get selectExistingGroup => 'Sélectionner un Groupe Existant :';

  @override
  String get orCreateNewGroup => 'Ou créer un nouveau groupe';

  @override
  String get save => 'Enregistrer';

  @override
  String get callLogPermDenied => 'Autorisation du journal d\'appels refusée.';

  @override
  String get noCallLogsFound => 'Aucun journal d\'appels trouvé.';

  @override
  String get recentCalls => 'Appels Récents';

  @override
  String get addContact => 'Ajouter un Contact';

  @override
  String get fromCallLog => 'Depuis le Journal d\'Appels';

  @override
  String get fromContactList => 'Depuis la Liste de Contacts';

  @override
  String get enterManually => 'Entrer Manuellement';

  @override
  String get general => 'Général';

  @override
  String get pingOptTitle => 'Optimisation des Pings (Appels)';

  @override
  String get pingOptDesc => 'Silencieux et continu';

  @override
  String get packetOptTitle => 'Optimisation des Paquets (SMS)';

  @override
  String get packetOptDesc => 'Sécurisé (nécessite une notification)';

  @override
  String everyTime(String time) {
    return 'Chaque $time';
  }

  @override
  String get delayAlerts => 'Alertes de Retard';

  @override
  String get delayAlertsDesc => 'Émet un son si non nettoyé après 30m';

  @override
  String get diagnosticRetention => 'Rétention de Diagnostic';

  @override
  String get doNotSave => 'Ne Pas Sauvegarder (Supprimer direct)';

  @override
  String get oneDay => '1 Jour';

  @override
  String get sevenDays => '7 Jours (Recommandé)';

  @override
  String get thirtyDays => '30 Jours';

  @override
  String get systemResilience => 'Résilience du Système';

  @override
  String get survivalMode => 'Mode de Survie';

  @override
  String get survivalModeDesc =>
      'Empêche la fermeture de l\'application en affichant une notification de protection continue.';

  @override
  String get permissions => 'Autorisations';

  @override
  String get permissionsDesc =>
      'Pour que Jotta puisse effacer automatiquement les informations, vous devez accorder les accès suivants :';

  @override
  String get callLogPerm => 'Journal d\'Appels';

  @override
  String get callLogPermDesc => 'Nécessaire pour optimiser les pings réseau.';

  @override
  String get accessGranted => 'Accès Accordé';

  @override
  String get grant => 'Accorder';

  @override
  String get contactsPerm => 'Contacts';

  @override
  String get contactsPermDesc => 'Ajouter des numéros de la liste.';

  @override
  String get smsManagement => 'Gestion des SMS';

  @override
  String get defaultSet => 'Défaut Défini';

  @override
  String get smsManagementDesc =>
      'Autorisation pour l\'optimisation des paquets.';

  @override
  String get set => 'Définir';

  @override
  String get notificationsPerm => 'Notifications';

  @override
  String get notificationsPermDesc =>
      'Alertes pour l\'optimisation des paquets.';

  @override
  String get interceptFilter => 'Filtre d\'Interception';

  @override
  String get shieldActive => 'Bouclier Actif';

  @override
  String get interceptFilterDesc => 'Rejeter les appels indésirables.';

  @override
  String get activate => 'Activer';

  @override
  String get continuousExecution => 'Exécution Continue';

  @override
  String get exemptionGranted => 'Exemption Accordée';

  @override
  String get continuousExecutionDesc =>
      'Ignorer la limite de batterie pour ne pas suspendre.';

  @override
  String get exempt => 'Exempter';

  @override
  String get smsNote =>
      'Note sur les SMS : Vous continuerez à recevoir des notifications de messages normalement. Vous pouvez annuler cette configuration dans les paramètres du téléphone à tout moment.';

  @override
  String get healthCenterTitle => 'Centre de Santé du Système';

  @override
  String get healthCenterDesc =>
      'Si le nettoyage automatique ne fonctionne pas en arrière-plan, vérifiez les options ci-dessous pour empêcher Android de geler l\'application.';

  @override
  String get autoStartTitle => '1. Démarrage Automatique (Auto-Start)';

  @override
  String get autoStartDesc =>
      'Des fabricants comme Xiaomi, Oppo et Vivo bloquent le démarrage automatique par sécurité. Vous devez activer cette permission.';

  @override
  String get openAutoStartSettings => 'Ouvrir les Paramètres Auto-Start';

  @override
  String get batteryRestrictionsTitle => '2. Restrictions de Batterie';

  @override
  String get batteryRestrictionsDesc =>
      'Android \'endort\' les applications pour économiser la batterie (Deep Doze). Assurez-vous que l\'exemption est active.';

  @override
  String get ignoreBatteryLimits => 'Ignorer les Limites de Batterie';

  @override
  String get exemptionActive => 'Exemption Active !';

  @override
  String get permRevocationTitle => '3. Révocation des Permissions';

  @override
  String get permRevocationDesc =>
      'Sur Android 11+, le système supprime les permissions des applications \'non utilisées\'. Allez dans les paramètres normaux de Jotta et désactivez \'Supprimer les autorisations si l\'application n\'est pas utilisée\'.';

  @override
  String get forceStopTitle => '4. Le Danger de \'Forcer l\'Arrêt\'';

  @override
  String get forceStopDesc =>
      'Glisser l\'application pour la fermer dans les fenêtres récentes est sûr. Cependant, aller dans les paramètres et appuyer sur \'Forcer l\'Arrêt\' tue définitivement le moteur en arrière-plan jusqu\'à ce que vous touchiez à nouveau l\'icône de Jotta.';
}
