import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/target_contact.dart';
import '../models/schedule_config.dart';
import '../models/vault_item.dart';

class StorageService {
  static const String _contactsKey = 'privacy_contacts';
  static const String _scheduleKey = 'privacy_schedule';
  static const String _pinKey = 'app_pin';
  static const String _vaultKey = 'privacy_vault';
  static const String _onboardingKey = 'has_seen_onboarding';

  // --- Onboarding ---
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  // --- Contacts ---

  Future<void> saveContacts(List<TargetContact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(contacts.map((c) => c.toJson()).toList());
    await prefs.setString(_contactsKey, data);
  }

  Future<List<TargetContact>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_contactsKey);
    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => TargetContact.fromJson(json)).toList();
  }

  Future<void> addContact(TargetContact contact) async {
    final contacts = await getContacts();
    contacts.add(contact);
    await saveContacts(contacts);
  }

  Future<void> removeContact(String id) async {
    final contacts = await getContacts();
    contacts.removeWhere((c) => c.id == id);
    await saveContacts(contacts);
  }

  Future<void> saveSchedule(ScheduleConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(config.toJson());
    await prefs.setString(_scheduleKey, data);
  }

  Future<ScheduleConfig> getSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_scheduleKey);
    if (data == null) return ScheduleConfig();

    return ScheduleConfig.fromJson(jsonDecode(data));
  }

  // Auth related
  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
  }

  Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey);
  }

  Future<bool> hasPin() async {
    final pin = await getPin();
    return pin != null && pin.isNotEmpty;
  }

  // --- Vault ---
  Future<List<VaultItem>> getVaultItems() async {
    final prefs = await SharedPreferences.getInstance();
    // SharedPreferences in Android might update this from Kotlin Worker
    await prefs.reload(); 
    
    final String? data = prefs.getString(_vaultKey);
    if (data == null || data.isEmpty) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((json) => VaultItem.fromJson(json)).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteVaultItemsByPhone(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_vaultKey);
    if (data == null || data.isEmpty) return;

    try {
      final List<dynamic> jsonList = jsonDecode(data);
      final List<VaultItem> items = jsonList.map((json) => VaultItem.fromJson(json)).toList();
      
      items.removeWhere((item) => item.phoneNumber == phoneNumber);
      
      final String newData = jsonEncode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_vaultKey, newData);
    } catch (e) {
      // Ignorar erros na gravação se houver corrupção JSON
    }
  }

  Future<void> deleteVaultItemById(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_vaultKey);
    if (data == null || data.isEmpty) return;

    try {
      final List<dynamic> jsonList = jsonDecode(data);
      final List<VaultItem> items = jsonList.map((json) => VaultItem.fromJson(json)).toList();
      
      items.removeWhere((item) => item.id == id);
      
      final String newData = jsonEncode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_vaultKey, newData);
    } catch (e) {
      // Ignorar erros na gravação
    }
  }

  Future<void> clearVault() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_vaultKey);
  }
}
