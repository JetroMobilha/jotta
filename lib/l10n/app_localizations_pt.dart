// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Jotta';

  @override
  String get appDescription => 'Otimizador de Sistema';

  @override
  String get homeTitle => 'Jotta';

  @override
  String get optimizationActive => 'Otimização Ativa';

  @override
  String get optimizationInactive => 'Otimização Inativa';

  @override
  String get pingsLabel => 'Pings: ';

  @override
  String get packetsLabel => ' | Pacotes: ';

  @override
  String everyMins(int mins) {
    return 'a cada ${mins}m';
  }

  @override
  String everyHours(int hours) {
    return 'a cada ${hours}h';
  }

  @override
  String get disabled => 'Desl.';

  @override
  String get lastOptimization => 'Última otimização:';

  @override
  String get never => 'Nunca';

  @override
  String get tapToOptimize => 'Toque para otimizar agora';

  @override
  String get optimizeBtn => 'Otimizar';

  @override
  String get vaultTitle => 'Registo de Diagnóstico';

  @override
  String get vaultSubtitle => 'Ver histórico de manutenção e cache';

  @override
  String get contactsTitle => 'Filtro de Entidades';

  @override
  String contactsSubtitle(int count) {
    return '$count entidades com regras ativas';
  }

  @override
  String get scheduleTitle => 'Agendamento de Manutenção';

  @override
  String get scheduleSubtitle => 'Configurar rotinas de otimização';

  @override
  String get permissionRequired => 'Permissão Necessária';

  @override
  String get smsPermissionDesc =>
      'Para apagar as mensagens privadas, o Jotta precisa ser definido temporariamente como a app de SMS padrão. Depois da limpeza, a sua aplicação original será reaberta para restaurar.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get setAndClean => 'Definir e Limpar';

  @override
  String get optimizingSystemLogs => 'A otimizar registos do sistema...';

  @override
  String get optimizationComplete => 'Otimização concluída com sucesso.';

  @override
  String get restoreSmsAppTitle => 'Restaurar App de Mensagens';

  @override
  String get restoreSmsAppDesc =>
      'A otimização terminou. Deseja reabrir a sua aplicação de mensagens original para a definir novamente como padrão?';

  @override
  String get later => 'Mais Tarde';

  @override
  String get reopen => 'Reabrir';

  @override
  String get clearVaultTitle => 'Limpar o Cofre?';

  @override
  String get clearVaultDesc =>
      'Tem a certeza que deseja eliminar permanentemente todos os registos do cofre? Esta ação não pode ser desfeita.';

  @override
  String get deleteGroupTitle => 'Eliminar Grupo';

  @override
  String deleteGroupDesc(String contactName, String phoneNumber) {
    return 'Tem a certeza que deseja eliminar permanentemente todos os registos de $contactName ($phoneNumber)?';
  }

  @override
  String get deleteAll => 'Eliminar Tudo';

  @override
  String get delete => 'Eliminar';

  @override
  String get logIsClean => 'O Registo está limpo.';

  @override
  String get logIsCleanDesc =>
      'Os logs e dados das entidades otimizadas aparecerão aqui para verificação técnica.';

  @override
  String get unknown => 'Desconhecido';

  @override
  String retainedLogs(int count) {
    return '$count registos retidos';
  }

  @override
  String get callLog => 'Registo de Chamada';

  @override
  String get textPacket => 'Pacote de Texto';

  @override
  String get callBlockedSource => 'Chamada Bloqueada na Fonte';

  @override
  String get noRulesConfigured => 'Nenhuma regra configurada.';

  @override
  String entitiesInGroup(int count) {
    return '$count entidades no grupo';
  }

  @override
  String get unblockGroup => 'Desbloquear Grupo';

  @override
  String get blockEntireGroup => 'Bloquear Todo o Grupo';

  @override
  String get unblockCalls => 'Desbloquear Chamadas';

  @override
  String get rejectCallsImm => 'Rejeitar Chamadas Imediatamente';

  @override
  String get call => 'Ligar';

  @override
  String get setGroup => 'Definir Grupo';

  @override
  String get groupNameHint => 'Nome do Grupo (ex: Trabalho, Família)';

  @override
  String get ok => 'OK';

  @override
  String get contactsPermDenied => 'Permissão de contactos negada.';

  @override
  String get addContactManual => 'Adicionar Contacto Manual';

  @override
  String get nameOptional => 'Nome (Opcional)';

  @override
  String get number => 'Número';

  @override
  String get selectExistingGroup => 'Selecionar Grupo Existente:';

  @override
  String get orCreateNewGroup => 'Ou crie um novo grupo';

  @override
  String get save => 'Guardar';

  @override
  String get callLogPermDenied => 'Permissão de chamadas negada.';

  @override
  String get noCallLogsFound => 'Nenhum registo de chamadas encontrado.';

  @override
  String get recentCalls => 'Chamadas Recentes';

  @override
  String get addContact => 'Adicionar Contacto';

  @override
  String get fromCallLog => 'Do Registo de Chamadas';

  @override
  String get fromContactList => 'Da Lista de Contactos';

  @override
  String get enterManually => 'Digitar Manualmente';

  @override
  String get general => 'Geral';

  @override
  String get pingOptTitle => 'Otimização de Pings (Chamadas)';

  @override
  String get pingOptDesc => 'Silencioso e contínuo';

  @override
  String get packetOptTitle => 'Otimização de Pacotes (SMS)';

  @override
  String get packetOptDesc => 'Seguro (requer notificação)';

  @override
  String everyTime(String time) {
    return 'A cada $time';
  }

  @override
  String get delayAlerts => 'Alertas de Atraso';

  @override
  String get delayAlertsDesc => 'Emite som se não limpar ao fim de 30m';

  @override
  String get diagnosticRetention => 'Retenção de Diagnóstico';

  @override
  String get doNotSave => 'Não Guardar (Eliminar direto)';

  @override
  String get oneDay => '1 Dia';

  @override
  String get sevenDays => '7 Dias (Recomendado)';

  @override
  String get thirtyDays => '30 Dias';

  @override
  String get systemResilience => 'Resiliência do Sistema';

  @override
  String get survivalMode => 'Modo de Sobrevivência';

  @override
  String get survivalModeDesc =>
      'Evita o encerramento da app exibindo uma notificação de proteção contínua no ecrã.';

  @override
  String get permissions => 'Permissões';

  @override
  String get permissionsDesc =>
      'Para que o Jotta consiga apagar as informações de forma automática, necessita de conceder os seguintes acessos:';

  @override
  String get callLogPerm => 'Registo de Chamadas';

  @override
  String get callLogPermDesc => 'Necessário para otimizar pings de rede.';

  @override
  String get accessGranted => 'Acesso Concedido';

  @override
  String get grant => 'Conceder';

  @override
  String get contactsPerm => 'Contactos';

  @override
  String get contactsPermDesc => 'Adicionar números da lista.';

  @override
  String get smsManagement => 'Gestão de SMS';

  @override
  String get defaultSet => 'Padrão Definido';

  @override
  String get smsManagementDesc => 'Permissão para otimização de pacotes.';

  @override
  String get set => 'Definir';

  @override
  String get notificationsPerm => 'Notificações';

  @override
  String get notificationsPermDesc => 'Alertas para otimização de pacotes.';

  @override
  String get interceptFilter => 'Filtro de Interceção';

  @override
  String get shieldActive => 'Escudo Ativo';

  @override
  String get interceptFilterDesc => 'Rejeitar chamadas indesejadas.';

  @override
  String get activate => 'Ativar';

  @override
  String get continuousExecution => 'Execução Contínua';

  @override
  String get exemptionGranted => 'Isenção Concedida';

  @override
  String get continuousExecutionDesc =>
      'Ignorar limite de bateria para não adormecer.';

  @override
  String get exempt => 'Isentar';

  @override
  String get smsNote =>
      'Nota sobre SMS: Continuará a receber notificações das mensagens normalmente. Pode reverter esta configuração nas definições do telemóvel a qualquer momento.';

  @override
  String get healthCenterTitle => 'Centro de Saúde do Sistema';

  @override
  String get healthCenterDesc =>
      'Se a limpeza automática não estiver a funcionar em segundo plano, verifique as opções abaixo para impedir que o Android congele a aplicação.';

  @override
  String get autoStartTitle => '1. Início Automático (Auto-Start)';

  @override
  String get autoStartDesc =>
      'Fabricantes como a Xiaomi, Oppo e Vivo bloqueiam o arranque automático de aplicações por segurança. Deve ligar esta permissão.';

  @override
  String get openAutoStartSettings => 'Abrir Definições de Início Automático';

  @override
  String get batteryRestrictionsTitle => '2. Restrições de Bateria';

  @override
  String get batteryRestrictionsDesc =>
      'O Android \"adormece\" aplicações para poupar bateria (Deep Doze). Garanta que tem a isenção ativa.';

  @override
  String get ignoreBatteryLimits => 'Ignorar Limites de Bateria';

  @override
  String get exemptionActive => 'Isenção Ativa!';

  @override
  String get permRevocationTitle => '3. Revogação de Permissões';

  @override
  String get permRevocationDesc =>
      'No Android 11+, o sistema remove permissões a aplicações \"não usadas\". Vá às definições normais da aplicação Jotta e desative o botão \"Remover permissões se a app não for usada\".';

  @override
  String get forceStopTitle => '4. O Perigo de \"Forçar Paragem\"';

  @override
  String get forceStopDesc =>
      'Deslizar a app para a fechar nas janelas recentes é perfeitamente seguro. Contudo, ir às definições e clicar em \"Forçar Paragem\" assassina o motor em background permanentemente até que volte a clicar no ícone do Jotta para o ressuscitar.';
}
