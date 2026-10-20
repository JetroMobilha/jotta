import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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

    setState(() {
      _hasCallLog = hasCallLog;
      _hasContacts = hasContacts;
      _isDefaultSms = isDefaultSms;
      _hasNotification = hasNotif;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissões')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Para que o Jotta consiga apagar as informações de forma automática, necessita de conceder os seguintes acessos:',
            style: TextStyle(fontSize: 16, color: AppColors.textWhite, height: 1.4),
          ),
          const SizedBox(height: 25),
          SoftContainer(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.phone, color: _hasCallLog ? AppColors.accentGreen : Colors.redAccent),
              title: const Text('Registo de Chamadas', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              subtitle: Text(_hasCallLog ? 'Acesso Concedido' : 'Necessário para otimizar pings de rede.', style: const TextStyle(color: AppColors.textLight)),
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
                      child: const Text('Conceder', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          SoftContainer(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.contacts, color: _hasContacts ? AppColors.accentGreen : Colors.redAccent),
              title: const Text('Contactos', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              subtitle: Text(_hasContacts ? 'Acesso Concedido' : 'Adicionar números da lista.', style: const TextStyle(color: AppColors.textLight)),
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
                      child: const Text('Conceder', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          SoftContainer(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.sms, color: _isDefaultSms ? AppColors.accentGreen : Colors.redAccent),
              title: const Text('Gestão de SMS', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              subtitle: Text(_isDefaultSms ? 'Padrão Definido' : 'Permissão para otimização de pacotes.', style: const TextStyle(color: AppColors.textLight)),
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
                      child: const Text('Definir', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ),
          ),
          const SizedBox(height: 15),
          SoftContainer(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.notifications_active, color: _hasNotification ? AppColors.accentGreen : Colors.redAccent),
              title: const Text('Notificações', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              subtitle: Text(_hasNotification ? 'Acesso Concedido' : 'Alertas para otimização de pacotes.', style: const TextStyle(color: AppColors.textLight)),
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
                      child: const Text('Conceder', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
            ),
          ),
          const SizedBox(height: 30),
          const SoftContainer(
            backgroundColor: AppColors.cardBackground,
            child: Text(
              'Nota sobre SMS: Continuará a receber notificações das mensagens normalmente. Pode reverter esta configuração nas definições do telemóvel a qualquer momento.',
              style: TextStyle(color: AppColors.textWhite, height: 1.4),
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
