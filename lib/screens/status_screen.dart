import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/schedule_config.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import '../widgets/soft_container.dart';
import '../widgets/banner_ad_widget.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final StorageService _storage = StorageService();
  ScheduleConfig _config = ScheduleConfig();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final config = await _storage.getSchedule();
    setState(() {
      _config = config;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isAnyActive = _config.callLogEnabled || _config.smsEnabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estado do Sistema'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      SoftContainer(
                        backgroundColor: isAnyActive ? AppColors.primaryPurple : AppColors.cardBackground,
                        child: Column(
                          children: [
                            Icon(
                              isAnyActive ? Icons.shield : Icons.shield_outlined,
                              size: 60,
                              color: isAnyActive ? Colors.white : AppColors.textLight,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              isAnyActive ? 'Otimização Ativa' : 'Otimização Inativa',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.textWhite,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pings: ${_config.callLogEnabled ? '${_config.callLogIntervalMinutes}m' : 'Desl.'} | Pacotes: ${_config.smsEnabled ? '${_config.smsIntervalMinutes ~/ 60}h' : 'Desl.'}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isAnyActive ? Colors.white70 : AppColors.textLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 25, color: Colors.white24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Última otimização:',
                                  style: TextStyle(color: AppColors.textWhite),
                                ),
                                Text(
                                  _config.lastExecution != null
                                      ? DateFormat('dd/MM/yy HH:mm').format(_config.lastExecution!)
                                      : 'Nunca',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      const SoftContainer(
                        backgroundColor: AppColors.cardBackground,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: AppColors.primaryPurple),
                                SizedBox(width: 10),
                                Text(
                                  'Como funciona a Otimização',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textWhite),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'O jota executa rotinas de manutenção em segundo plano para manter o sistema limpo e rápido.',
                              style: TextStyle(color: AppColors.textWhite, height: 1.4),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '• Pings de Rede (Chamadas): Otimizados automaticamente no tempo programado.\n• Pacotes de Texto (SMS): Geram notificações para execução rápida via app.',
                              style: TextStyle(color: AppColors.textLight, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: BannerAdWidget(),
                ),
              ],
            ),
    );
  }
}
