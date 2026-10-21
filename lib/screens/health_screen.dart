import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/native_cleaner_service.dart';
import '../widgets/soft_container.dart';
import '../theme/app_colors.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  bool _isIgnoringBattery = true;

  @override
  void initState() {
    super.initState();
    _checkHealth();
  }

  Future<void> _checkHealth() async {
    final isIgnBattery = await NativeCleanerService.isIgnoringBatteryOptimizations();
    setState(() {
      _isIgnoringBattery = isIgnBattery;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.healthCenterTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(
            l10n.healthCenterDesc,
            style: const TextStyle(color: AppColors.textLight, height: 1.4),
          ),
          const SizedBox(height: 25),
          
          SoftContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.rocket_launch, color: AppColors.primaryPurple),
                    const SizedBox(width: 10),
                    Text(l10n.autoStartTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textWhite)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.autoStartDesc,
                  style: const TextStyle(color: AppColors.textLight, fontSize: 13),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await NativeCleanerService.openAutoStartSettings();
                  },
                  child: Text(l10n.openAutoStartSettings, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SoftContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.battery_charging_full, color: _isIgnoringBattery ? AppColors.accentGreen : Colors.redAccent),
                    const SizedBox(width: 10),
                    Expanded(child: Text(l10n.batteryRestrictionsTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textWhite))),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.batteryRestrictionsDesc,
                  style: const TextStyle(color: AppColors.textLight, fontSize: 13),
                ),
                const SizedBox(height: 15),
                if (!_isIgnoringBattery)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      await NativeCleanerService.requestBatteryExemption();
                      await Future.delayed(const Duration(seconds: 2));
                      _checkHealth();
                    },
                    child: Text(l10n.ignoreBatteryLimits, style: const TextStyle(fontWeight: FontWeight.bold)),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accentGreen),
                    ),
                    child: Center(
                      child: Text(l10n.exemptionActive, style: const TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold)),
                    ),
                  )
              ],
            ),
          ),

          const SizedBox(height: 20),

          SoftContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.security_update_warning, color: Colors.orange),
                    const SizedBox(width: 10),
                    Text(l10n.permRevocationTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textWhite)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.permRevocationDesc,
                  style: const TextStyle(color: AppColors.textLight, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          SoftContainer(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.pan_tool, color: AppColors.textWhite),
                    const SizedBox(width: 10),
                    Text(l10n.forceStopTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textWhite)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.forceStopDesc,
                  style: const TextStyle(color: AppColors.textLight, fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
