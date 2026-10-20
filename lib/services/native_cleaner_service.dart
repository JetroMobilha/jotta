import 'package:flutter/services.dart';
import 'storage_service.dart';
import '../models/schedule_config.dart';

class NativeCleanerService {
  static const MethodChannel _channel = MethodChannel('com.example.jota/privacy_cleaner');

  static Future<bool> isDefaultSmsApp() async {
    try {
      final bool isDefault = await _channel.invokeMethod('isDefaultSmsApp');
      return isDefault;
    } on PlatformException catch (_) {
      return false;
    }
  }

  static Future<bool> hasCallScreeningRole() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasCallScreeningRole');
      return result ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  static Future<bool> requestCallScreeningRole() async {
    try {
      final result = await _channel.invokeMethod<bool>('requestCallScreeningRole');
      return result ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  static Future<bool> hasCallLogPermission() async {
    try {
      final bool hasPerm = await _channel.invokeMethod('hasCallLogPermission');
      return hasPerm;
    } on PlatformException catch (_) {
      return false;
    }
  }

  static Future<void> requestCallLogPermission() async {
    try {
      await _channel.invokeMethod('requestCallLogPermission');
    } on PlatformException catch (_) {}
  }

  static Future<void> requestDefaultSmsApp() async {
    try {
      await _channel.invokeMethod('requestDefaultSmsApp');
    } on PlatformException catch (_) {
      // Handle error
    }
  }

  static Future<String?> getPreviousSmsApp() async {
    try {
      return await _channel.invokeMethod<String>('getPreviousSmsApp');
    } on PlatformException catch (_) {
      return null;
    }
  }

  static Future<bool> launchApp(String packageName) async {
    try {
      final result = await _channel.invokeMethod<bool>('launchApp', {'package': packageName});
      return result ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  static Future<bool> makeCall(String phoneNumber) async {
    try {
      final result = await _channel.invokeMethod<bool>('makeCall', {'number': phoneNumber});
      return result ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  static Future<List<Map<String, String>>> getRecentCalls() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod('getRecentCalls');
      return result.map((e) => Map<String, String>.from(e as Map)).toList();
    } on PlatformException catch (_) {
      return [];
    }
  }

  static Future<void> cleanNow() async {
    try {
      final StorageService storage = StorageService();
      final contacts = await storage.getContacts();
      final targets = contacts.map((c) => c.phoneNumber).toList();

      await _channel.invokeMethod('cleanNow', {'targets': targets});
      
      // Update last execution time
      final schedule = await storage.getSchedule();
      await storage.saveSchedule(schedule.copyWith(lastExecution: DateTime.now()));
    } on PlatformException catch (_) {
      // Handle error
    }
  }

  static Future<void> scheduleBackgroundCleanup(ScheduleConfig config) async {
    try {
      await _channel.invokeMethod('scheduleTasks', config.toJson());
    } catch (_) {}
  }

  static Future<void> cancelBackgroundCleanup() async {
    try {
      await _channel.invokeMethod('cancelTasks');
    } catch (_) {}
  }
}
