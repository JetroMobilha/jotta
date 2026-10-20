import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import '../widgets/soft_container.dart';

class LockScreen extends StatefulWidget {
  final bool isSetup;
  final Widget? destination;
  
  static bool isShowing = false;

  const LockScreen({super.key, this.isSetup = false, this.destination});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    LockScreen.isShowing = true;
  }

  @override
  void dispose() {
    LockScreen.isShowing = false;
    super.dispose();
  }

  void _navigateToDestination() {
    if (widget.destination != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.destination!),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onKeyPress(String val) async {
    if (_pin.length < 4) {
      setState(() {
        _pin += val;
        _errorMsg = '';
      });
    }

    if (_pin.length == 4) {
      if (widget.isSetup) {
        if (!_isConfirming) {
          setState(() {
            _confirmPin = _pin;
            _pin = '';
            _isConfirming = true;
          });
        } else {
          if (_pin == _confirmPin) {
            await _authService.setupPin(_pin);
            _navigateToDestination();
          } else {
            setState(() {
              _pin = '';
              _confirmPin = '';
              _isConfirming = false;
              _errorMsg = 'Os PINs não coincidem. Tente novamente.';
            });
          }
        }
      } else {
        // Unlock mode
        final isValid = await _authService.checkPin(_pin);
        if (isValid) {
          _navigateToDestination();
        } else {
          setState(() {
            _pin = '';
            _errorMsg = 'PIN Incorreto';
          });
        }
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  Widget _buildDot(int index) {
    bool isFilled = index < _pin.length;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? AppColors.primaryPurple : AppColors.cardBackground,
        border: Border.all(color: AppColors.primaryPurple, width: 2),
      ),
    );
  }

  Widget _buildKeypadButton(String txt, {VoidCallback? onPressed, IconData? icon}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SoftContainer(
          borderRadius: 40,
          backgroundColor: AppColors.cardBackground,
          onTap: onPressed ?? () => _onKeyPress(txt),
          child: SizedBox(
            height: 60,
            child: Center(
              child: icon != null
                  ? Icon(icon, color: AppColors.textWhite, size: 28)
                  : Text(txt, style: const TextStyle(fontSize: 28, color: AppColors.textWhite, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.isSetup
        ? (_isConfirming ? 'Confirme o PIN' : 'Crie um PIN (4 dígitos)')
        : 'Confirme a Identidade do Sistema';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SoftContainer(
              borderRadius: 50,
              padding: const EdgeInsets.all(20),
              backgroundColor: AppColors.primaryPurple,
              child: const Icon(Icons.lock_outline, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Text(title, style: const TextStyle(fontSize: 22, color: AppColors.textWhite, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) => _buildDot(index)),
            ),
            const SizedBox(height: 20),
            if (_errorMsg.isNotEmpty)
              Text(_errorMsg, style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Row(children: ['1','2','3'].map((e) => _buildKeypadButton(e)).toList()),
                  Row(children: ['4','5','6'].map((e) => _buildKeypadButton(e)).toList()),
                  Row(children: ['7','8','9'].map((e) => _buildKeypadButton(e)).toList()),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      _buildKeypadButton('0'),
                      _buildKeypadButton('', icon: Icons.backspace_outlined, onPressed: _onDelete),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
