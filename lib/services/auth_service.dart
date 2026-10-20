import 'storage_service.dart';

class AuthService {
  final StorageService _storage = StorageService();

  Future<bool> checkPin(String inputPin) async {
    final storedPin = await _storage.getPin();
    return storedPin == inputPin;
  }

  Future<void> setupPin(String pin) async {
    await _storage.savePin(pin);
  }
}
