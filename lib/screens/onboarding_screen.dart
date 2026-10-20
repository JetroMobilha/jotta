import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/soft_container.dart';
import '../widgets/banner_ad_widget.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isFromHelp;
  const OnboardingScreen({super.key, this.isFromHelp = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final StorageService _storage = StorageService();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Proteção & Privacidade',
      'description': 'O jota ajuda a eliminar automaticamente o histórico de chamadas e mensagens SMS dos contactos que adicionar à sua lista de filtros.',
      'icon': Icons.shield,
      'color': AppColors.primaryPurple,
    },
    {
      'title': 'Cofre Temporário',
      'description': 'Antes de apagar os registos do telemóvel, o jota guarda uma cópia de segurança no seu Cofre interno, permitindo-lhe rever ou apagar definitivamente quando quiser.',
      'icon': Icons.inventory_2,
      'color': AppColors.primaryPurple,
    },
    {
      'title': 'Limitações do Android',
      'description': 'As chamadas são limpas em segundo plano. Para as SMS, receberá uma notificação para autorizar a troca temporária da app padrão e efetuar a limpeza rápida.',
      'icon': Icons.info_outline,
      'color': AppColors.primaryPurple,
    },
  ];

  void _onFinish() async {
    if (!widget.isFromHelp) {
      await _storage.setOnboardingSeen();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _onFinish,
                  child: const Text(
                    'Saltar',
                    style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (idx) {
                  setState(() {
                    _currentPage = idx;
                  });
                },
                itemBuilder: (ctx, idx) {
                  final slide = _slides[idx];
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SoftContainer(
                          borderRadius: 60,
                          backgroundColor: slide['color'] as Color,
                          padding: const EdgeInsets.all(35),
                          child: Icon(
                            slide['icon'] as IconData,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide['title'] as String,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          slide['description'] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textLight,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 24 : 10,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: _currentPage == index ? AppColors.primaryPurple : AppColors.cardBackground,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: SoftContainer(
                backgroundColor: AppColors.primaryPurple,
                borderRadius: 30,
                onTap: _nextPage,
                child: Center(
                  child: Text(
                    _currentPage == _slides.length - 1 ? 'Começar' : 'Próximo',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: BannerAdWidget(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
