import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/storage_service.dart';
import '../services/native_cleaner_service.dart';
import '../services/ad_service.dart';
import '../widgets/banner_ad_widget.dart';
import '../models/schedule_config.dart';
import '../theme/app_colors.dart';
import '../widgets/soft_container.dart';
import 'contacts_screen.dart';
import 'schedule_screen.dart';
import 'permissions_screen.dart';
import 'vault_screen.dart';
import 'lock_screen.dart';
import 'onboarding_screen.dart';
import 'status_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final StorageService _storage = StorageService();
  ScheduleConfig _config = ScheduleConfig();
  int _contactsCount = 0;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadData();
    AdService.loadInterstitialAd();
    AdService.loadRewardedAd();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final config = await _storage.getSchedule();
    final contacts = await _storage.getContacts();
    setState(() {
      _config = config;
      _contactsCount = contacts.length;
    });
  }

  Future<void> _cleanNow() async {
    final prevApp = await NativeCleanerService.getPreviousSmsApp();
    
    // Check if we are default SMS app
    final isDefault = await NativeCleanerService.isDefaultSmsApp();
    if (!isDefault) {
      // Ask user to set as default temporarily
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.background,
          title: const Text('Permissão Necessária'),
          content: const Text('Para apagar as mensagens privadas, o Jotta precisa ser definido temporariamente como a app de SMS padrão. Depois da limpeza, a sua aplicação original será reaberta para restaurar.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Definir e Limpar', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      );

      if (confirm == true) {
        await NativeCleanerService.requestDefaultSmsApp();
        // Wait for user to return from settings
        await Future.delayed(const Duration(seconds: 3));
        
        // Re-check
        if (await NativeCleanerService.isDefaultSmsApp()) {
          await _executeClean(prevApp);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Limpeza cancelada: Permissão não concedida.')));
          }
        }
      }
    } else {
      // Already default, just clean
      await _executeClean(prevApp);
    }
  }

  Future<void> _executeClean(String? prevApp) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A otimizar registos do sistema...')),
    );

    // 1. Show the ad to the user instantly (so it acts as a "Loading Screen")
    AdService.showRandomAd(
      onComplete: () async {
        // 3. This executes after the user closes the ad (meaning they were distracted by it)
        await _loadData(); // Refresh UI to show new execution time
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Otimização concluída com sucesso.')),
          );

          if (prevApp != null && prevApp != 'com.example.jota') {
            final restore = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: AppColors.cardBackground,
                title: const Text('Restaurar App de Mensagens', style: TextStyle(color: AppColors.textWhite)),
                content: const Text('A otimização terminou. Deseja reabrir a sua aplicação de mensagens original para a definir novamente como padrão?', style: TextStyle(color: AppColors.textLight)),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Mais Tarde', style: TextStyle(color: AppColors.textLight))),
                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Reabrir', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold))),
                ],
              ),
            );

            if (restore == true) {
              await NativeCleanerService.launchApp(prevApp);
            }
          }
        }
      },
    );

    // 2. Perform the actual heavy cleaning in the background while the ad is showing
    await NativeCleanerService.cleanNow();
  }

  void _requirePinThenNavigate(Widget destination) async {
    final hasPin = await _storage.hasPin();
    if (mounted) {
      if (!hasPin) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LockScreen(isSetup: true, destination: destination)));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LockScreen(isSetup: false, destination: destination)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jotta', style: TextStyle(letterSpacing: 1.2)),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const StatusScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingScreen(isFromHelp: true)));
            },
          ),
          IconButton(
            icon: const Icon(Icons.security),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PermissionsScreen()));
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const SizedBox(height: 10),
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: SoftContainer(
                  borderRadius: 90,
                  width: 170,
                  height: 170,
                  hasGlow: true,
                  backgroundColor: AppColors.primaryPurple,
                  onTap: _cleanNow,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bolt,
                        size: 65,
                        color: Colors.white,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Otimizar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            SoftContainer(
              onTap: () {
                _requirePinThenNavigate(const VaultScreen());
              },
              child: const Row(
                children: [
                  CircleAvatar(backgroundColor: AppColors.primaryPurple, child: Icon(Icons.inventory_2, color: Colors.white)),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Registo de Diagnóstico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textWhite)),
                      Text('Ver histórico de manutenção e cache', style: TextStyle(color: AppColors.textLight)),
                    ]),
                  ),
                  Icon(Icons.arrow_forward_ios, color: AppColors.textLight, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SoftContainer(
              onTap: () {
                _requirePinThenNavigate(const ContactsScreen());
              },
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: AppColors.primaryPurple, child: Icon(Icons.people, color: Colors.white)),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Filtro de Entidades', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textWhite)),
                        Text('$_contactsCount entidades com regras ativas', style: const TextStyle(color: AppColors.textLight)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: AppColors.textLight, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SoftContainer(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleScreen()));
                _loadData();
              },
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: AppColors.primaryPurple, child: Icon(Icons.schedule, color: Colors.white)),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Agendamento de Manutenção', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textWhite)),
                        Text('Configurar rotinas de otimização', style: TextStyle(color: AppColors.textLight)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: AppColors.textLight, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}
