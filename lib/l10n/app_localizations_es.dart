// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Jotta';

  @override
  String get appDescription => 'Optimizador de Sistema';

  @override
  String get homeTitle => 'Jotta';

  @override
  String get optimizationActive => 'Optimización Activa';

  @override
  String get optimizationInactive => 'Optimización Inactiva';

  @override
  String get pingsLabel => 'Pings: ';

  @override
  String get packetsLabel => ' | Paquetes: ';

  @override
  String everyMins(int mins) {
    return 'cada ${mins}m';
  }

  @override
  String everyHours(int hours) {
    return 'cada ${hours}h';
  }

  @override
  String get disabled => 'Desact.';

  @override
  String get lastOptimization => 'Última optimización:';

  @override
  String get never => 'Nunca';

  @override
  String get tapToOptimize => 'Toca para optimizar ahora';

  @override
  String get optimizeBtn => 'Optimizar';

  @override
  String get vaultTitle => 'Registro de Diagnóstico';

  @override
  String get vaultSubtitle => 'Ver historial de mantenimiento y caché';

  @override
  String get contactsTitle => 'Filtro de Entidades';

  @override
  String contactsSubtitle(int count) {
    return '$count entidades con reglas activas';
  }

  @override
  String get scheduleTitle => 'Programación de Mantenimiento';

  @override
  String get scheduleSubtitle => 'Configurar rutinas de optimización';

  @override
  String get permissionRequired => 'Permiso Requerido';

  @override
  String get smsPermissionDesc =>
      'Para borrar los mensajes privados, Jotta necesita ser configurada temporalmente como la app de SMS predeterminada. Después de la limpieza, se restaurará tu aplicación original.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get setAndClean => 'Definir y Limpiar';

  @override
  String get optimizingSystemLogs => 'Optimizando registros del sistema...';

  @override
  String get optimizationComplete => 'Optimización completada con éxito.';

  @override
  String get restoreSmsAppTitle => 'Restaurar App de Mensajes';

  @override
  String get restoreSmsAppDesc =>
      'La optimización ha terminado. ¿Deseas reabrir tu aplicación de mensajes original para establecerla nuevamente como predeterminada?';

  @override
  String get later => 'Más Tarde';

  @override
  String get reopen => 'Reabrir';

  @override
  String get clearVaultTitle => '¿Limpiar el Registro?';

  @override
  String get clearVaultDesc =>
      '¿Estás seguro de que deseas eliminar permanentemente todos los registros? Esta acción no se puede deshacer.';

  @override
  String get deleteGroupTitle => 'Eliminar Grupo';

  @override
  String deleteGroupDesc(String contactName, String phoneNumber) {
    return '¿Estás seguro de que deseas eliminar permanentemente todos los registros de $contactName ($phoneNumber)?';
  }

  @override
  String get deleteAll => 'Eliminar Todo';

  @override
  String get delete => 'Eliminar';

  @override
  String get logIsClean => 'El registro está limpio.';

  @override
  String get logIsCleanDesc =>
      'Los registros y datos de las entidades optimizadas aparecerán aquí para verificación técnica.';

  @override
  String get unknown => 'Desconocido';

  @override
  String retainedLogs(int count) {
    return '$count registros retenidos';
  }

  @override
  String get callLog => 'Registro de Llamada';

  @override
  String get textPacket => 'Paquete de Texto';

  @override
  String get callBlockedSource => 'Llamada Bloqueada en Origen';

  @override
  String get noRulesConfigured => 'No hay reglas configuradas.';

  @override
  String entitiesInGroup(int count) {
    return '$count entidades en el grupo';
  }

  @override
  String get unblockGroup => 'Desbloquear Grupo';

  @override
  String get blockEntireGroup => 'Bloquear Todo el Grupo';

  @override
  String get unblockCalls => 'Desbloquear Llamadas';

  @override
  String get rejectCallsImm => 'Rechazar Llamadas Inmediatamente';

  @override
  String get call => 'Llamar';

  @override
  String get setGroup => 'Definir Grupo';

  @override
  String get groupNameHint => 'Nombre del Grupo (ej: Trabajo, Familia)';

  @override
  String get ok => 'OK';

  @override
  String get contactsPermDenied => 'Permiso de contactos denegado.';

  @override
  String get addContactManual => 'Añadir Contacto Manualmente';

  @override
  String get nameOptional => 'Nombre (Opcional)';

  @override
  String get number => 'Número';

  @override
  String get selectExistingGroup => 'Seleccionar Grupo Existente:';

  @override
  String get orCreateNewGroup => 'O crea un nuevo grupo';

  @override
  String get save => 'Guardar';

  @override
  String get callLogPermDenied => 'Permiso de registro de llamadas denegado.';

  @override
  String get noCallLogsFound => 'No se encontraron registros de llamadas.';

  @override
  String get recentCalls => 'Llamadas Recientes';

  @override
  String get addContact => 'Añadir Contacto';

  @override
  String get fromCallLog => 'Del Registro de Llamadas';

  @override
  String get fromContactList => 'De la Lista de Contactos';

  @override
  String get enterManually => 'Introducir Manualmente';

  @override
  String get general => 'General';

  @override
  String get pingOptTitle => 'Optimización de Pings (Llamadas)';

  @override
  String get pingOptDesc => 'Silencioso y continuo';

  @override
  String get packetOptTitle => 'Optimización de Paquetes (SMS)';

  @override
  String get packetOptDesc => 'Seguro (requiere notificación)';

  @override
  String everyTime(String time) {
    return 'Cada $time';
  }

  @override
  String get delayAlerts => 'Alertas de Retraso';

  @override
  String get delayAlertsDesc => 'Emite sonido si no limpia tras 30m';

  @override
  String get diagnosticRetention => 'Retención de Diagnóstico';

  @override
  String get doNotSave => 'No Guardar (Eliminar directo)';

  @override
  String get oneDay => '1 Día';

  @override
  String get sevenDays => '7 Días (Recomendado)';

  @override
  String get thirtyDays => '30 Días';

  @override
  String get systemResilience => 'Resiliencia del Sistema';

  @override
  String get survivalMode => 'Modo de Supervivencia';

  @override
  String get survivalModeDesc =>
      'Evita el cierre de la app mostrando una notificación de protección continua en pantalla.';

  @override
  String get permissions => 'Permisos';

  @override
  String get permissionsDesc =>
      'Para que Jotta pueda borrar información de forma automática, debes conceder los siguientes accesos:';

  @override
  String get callLogPerm => 'Registro de Llamadas';

  @override
  String get callLogPermDesc => 'Necesario para optimizar pings de red.';

  @override
  String get accessGranted => 'Acceso Concedido';

  @override
  String get grant => 'Conceder';

  @override
  String get contactsPerm => 'Contactos';

  @override
  String get contactsPermDesc => 'Añadir números de la lista.';

  @override
  String get smsManagement => 'Gestión de SMS';

  @override
  String get defaultSet => 'Predeterminado Establecido';

  @override
  String get smsManagementDesc => 'Permiso para optimización de paquetes.';

  @override
  String get set => 'Definir';

  @override
  String get notificationsPerm => 'Notificaciones';

  @override
  String get notificationsPermDesc => 'Alertas para optimización de paquetes.';

  @override
  String get interceptFilter => 'Filtro de Intercepción';

  @override
  String get shieldActive => 'Escudo Activo';

  @override
  String get interceptFilterDesc => 'Rechazar llamadas no deseadas.';

  @override
  String get activate => 'Activar';

  @override
  String get continuousExecution => 'Ejecución Continua';

  @override
  String get exemptionGranted => 'Exención Concedida';

  @override
  String get continuousExecutionDesc =>
      'Ignorar límite de batería para no suspender.';

  @override
  String get exempt => 'Eximir';

  @override
  String get smsNote =>
      'Nota sobre SMS: Continuarás recibiendo notificaciones de mensajes normalmente. Puedes revertir esta configuración en los ajustes del teléfono en cualquier momento.';

  @override
  String get healthCenterTitle => 'Centro de Salud del Sistema';

  @override
  String get healthCenterDesc =>
      'Si la limpieza automática no funciona en segundo plano, revisa las opciones a continuación para evitar que Android congele la aplicación.';

  @override
  String get autoStartTitle => '1. Inicio Automático (Auto-Start)';

  @override
  String get autoStartDesc =>
      'Fabricantes como Xiaomi, Oppo y Vivo bloquean el inicio automático por seguridad. Debes activar este permiso.';

  @override
  String get openAutoStartSettings => 'Abrir Ajustes de Inicio Automático';

  @override
  String get batteryRestrictionsTitle => '2. Restricciones de Batería';

  @override
  String get batteryRestrictionsDesc =>
      'Android \'duerme\' aplicaciones para ahorrar batería (Deep Doze). Asegúrate de tener la exención activa.';

  @override
  String get ignoreBatteryLimits => 'Ignorar Límites de Batería';

  @override
  String get exemptionActive => '¡Exención Activa!';

  @override
  String get permRevocationTitle => '3. Revocación de Permisos';

  @override
  String get permRevocationDesc =>
      'En Android 11+, el sistema elimina permisos a aplicaciones \'no usadas\'. Ve a los ajustes normales de la app Jotta y desactiva \'Eliminar permisos si la app no se usa\'.';

  @override
  String get forceStopTitle => '4. El Peligro de \'Forzar Detención\'';

  @override
  String get forceStopDesc =>
      'Deslizar la app para cerrarla en las ventanas recientes es seguro. Sin embargo, ir a ajustes y pulsar \'Forzar Detención\' asesina permanentemente el motor en segundo plano hasta que vuelvas a tocar el icono de Jotta.';
}
