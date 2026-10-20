import 'package:flutter/material.dart';
import '../models/schedule_config.dart';
import '../services/storage_service.dart';
import '../services/native_cleaner_service.dart';
import '../widgets/soft_container.dart';
import '../widgets/banner_ad_widget.dart';
import '../theme/app_colors.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final StorageService _storage = StorageService();
  ScheduleConfig _config = ScheduleConfig();
  bool _isLoading = true;

  final List<int> _intervals = [15, 30, 60, 120, 360, 720, 1440];

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _storage.getSchedule();
    setState(() {
      _config = config;
      _isLoading = false;
    });
  }

  Future<void> _updateConfig(ScheduleConfig newConfig) async {
    setState(() {
      _config = newConfig;
    });

    await _storage.saveSchedule(newConfig);
    
    if (newConfig.callLogEnabled || newConfig.smsEnabled) {
      await NativeCleanerService.scheduleBackgroundCleanup(newConfig);
    } else {
      await NativeCleanerService.cancelBackgroundCleanup();
    }
  }

  String _formatInterval(int minutes) {
    if (minutes < 60) return '$minutes minutos';
    if (minutes == 60) return '1 hora';
    if (minutes < 1440) return '${minutes ~/ 60} horas';
    return '1 dia';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendamento')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              SoftContainer(
                child: SwitchListTile(
                  activeColor: AppColors.primaryPurple,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Otimização de Pings (Chamadas)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
                  subtitle: const Text('Silencioso e contínuo', style: TextStyle(color: AppColors.textLight)),
                  value: _config.callLogEnabled,
                  onChanged: (val) {
                    _updateConfig(_config.copyWith(callLogEnabled: val));
                  },
                ),
              ),
              if (_config.callLogEnabled) ...[
                const SizedBox(height: 10),
                SoftContainer(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [15, 30, 60].map((interval) => RadioListTile<int>(
                      activeColor: AppColors.primaryPurple,
                      title: Text('A cada ${_formatInterval(interval)}', style: const TextStyle(color: AppColors.textWhite)),
                      value: interval,
                      groupValue: _config.callLogIntervalMinutes,
                      onChanged: (val) {
                        if (val != null) _updateConfig(_config.copyWith(callLogIntervalMinutes: val));
                      },
                    )).toList(),
                  )
                ),
              ],
              const SizedBox(height: 25),
              SoftContainer(
                child: SwitchListTile(
                  activeColor: AppColors.primaryPurple,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Otimização de Pacotes (SMS)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
                  subtitle: const Text('Seguro (requer notificação)', style: TextStyle(color: AppColors.textLight)),
                  value: _config.smsEnabled,
                  onChanged: (val) {
                    _updateConfig(_config.copyWith(smsEnabled: val));
                  },
                ),
              ),
              if (_config.smsEnabled) ...[
                const SizedBox(height: 10),
                SoftContainer(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    children: [15, 30, 60, 120, 360, 720, 1440].map((interval) => RadioListTile<int>(
                      activeColor: AppColors.primaryPurple,
                      title: Text('A cada ${_formatInterval(interval)}', style: const TextStyle(color: AppColors.textWhite)),
                      value: interval,
                      groupValue: _config.smsIntervalMinutes,
                      onChanged: (val) {
                        if (val != null) _updateConfig(_config.copyWith(smsIntervalMinutes: val));
                      },
                    )).toList(),
                  )
                ),
                const SizedBox(height: 10),
                SoftContainer(
                  child: SwitchListTile(
                    activeColor: AppColors.primaryPurple,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Alertas de Atraso', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
                    subtitle: const Text('Emite som se não limpar ao fim de 30m', style: TextStyle(color: AppColors.textLight)),
                    value: _config.smsReminderEnabled,
                    onChanged: (val) {
                      _updateConfig(_config.copyWith(smsReminderEnabled: val));
                    },
                  ),
                ),
              ],
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text('Retenção de Diagnóstico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textWhite)),
              ),
              SoftContainer(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    RadioListTile<int>(
                      activeColor: AppColors.primaryPurple,
                      title: const Text('Não Guardar (Eliminar direto)', style: TextStyle(color: AppColors.textWhite)),
                      value: 0,
                      groupValue: _config.vaultRetentionDays,
                      onChanged: (val) {
                        if (val != null) _updateConfig(_config.copyWith(vaultRetentionDays: val));
                      },
                    ),
                    RadioListTile<int>(
                      activeColor: AppColors.primaryPurple,
                      title: const Text('1 Dia', style: TextStyle(color: AppColors.textWhite)),
                      value: 1,
                      groupValue: _config.vaultRetentionDays,
                      onChanged: (val) {
                        if (val != null) _updateConfig(_config.copyWith(vaultRetentionDays: val));
                      },
                    ),
                    RadioListTile<int>(
                      activeColor: AppColors.primaryPurple,
                      title: const Text('7 Dias (Recomendado)', style: TextStyle(color: AppColors.textWhite)),
                      value: 7,
                      groupValue: _config.vaultRetentionDays,
                      onChanged: (val) {
                        if (val != null) _updateConfig(_config.copyWith(vaultRetentionDays: val));
                      },
                    ),
                    RadioListTile<int>(
                      activeColor: AppColors.primaryPurple,
                      title: const Text('30 Dias', style: TextStyle(color: AppColors.textWhite)),
                      value: 30,
                      groupValue: _config.vaultRetentionDays,
                      onChanged: (val) {
                        if (val != null) _updateConfig(_config.copyWith(vaultRetentionDays: val));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const BannerAdWidget(),
            ],
          ),
    );
  }
}
