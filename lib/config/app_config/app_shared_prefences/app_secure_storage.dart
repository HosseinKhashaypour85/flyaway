import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static LocalStorage? _instance;
  late SharedPreferences preferences;

  LocalStorage._();

  static Future<LocalStorage> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorage._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    preferences = await SharedPreferences.getInstance();
  }

  dynamic get(String key) {
    final value = preferences.get(key);
    if (value is int || value is bool || value is double || value is String) {
      return value;
    }
    return null;
  }

  Future<bool> set(String key, dynamic value) async {
    if (value is bool) {
      return await preferences.setBool(key, value);
    }
    if (value is int) {
      return await preferences.setInt(key, value);
    }
    if (value is double) {
      return await preferences.setDouble(key, value);
    }
    if (value is String) {
      return await preferences.setString(key, value);
    }
    return Future.value(false);
  }

  Future<void> clear() async {
    await preferences.clear();
  }
}
