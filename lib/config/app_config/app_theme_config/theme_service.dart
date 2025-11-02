import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_themes.dart';
import 'package:flutter/material.dart';

class ThemeService {
  static const String _keyIsDark = 'isDarkMode';
  final GetStorage _box = GetStorage();

  RxBool isDarkModeRx = false.obs;

  bool get isDarkMode => _box.read(_keyIsDark) ?? false;

  Future<void> saveTheme(bool isDark) async {
    await _box.write(_keyIsDark, isDark);
    isDarkModeRx.value = isDark;
  }

  Future<void> switchTheme() async {
    final newIsDark = !isDarkMode;
    await saveTheme(newIsDark);
    _applyTheme(newIsDark);
  }

  void _applyTheme(bool isDark) {
    if (isDark) {
      Get.changeTheme(AppThemes().darkTheme);
    } else {
      Get.changeTheme(AppThemes().lightTheme);
    }
  }

  void initTheme() {
    isDarkModeRx.value = isDarkMode;
    _applyTheme(isDarkMode);
  }
}
