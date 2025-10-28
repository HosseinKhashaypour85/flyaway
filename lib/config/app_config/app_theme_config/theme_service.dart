import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

import 'app_themes.dart';

class ThemeService {
  static const String _keyIsDark = 'isDarkMode';
  final GetStorage _box = GetStorage();

  // خواندن مقدار ذخیره‌شده، اگر وجود نداشت false (Light) برمی‌گرداند
  bool get isDarkMode => _box.read(_keyIsDark) ?? false;

  // مقدار را نگهداری می‌کند
  Future<void> saveTheme(bool isDark) async {
    await _box.write(_keyIsDark, isDark);
  }

  // سوئیچ کردن تم (و ذخیره)
  Future<void> switchTheme() async {
    final newIsDark = !isDarkMode;
    await saveTheme(newIsDark);
    _applyTheme(newIsDark);
  }

  // اعمال تم روی Get
  void _applyTheme(bool isDark) {
    if (isDark) {
      Get.changeTheme(darkTheme);
    } else {
      Get.changeTheme(lightTheme);
    }
  }

  // فراخوانی اولیه برای تنظیم تم هنگام استارت اپ
  void initTheme() {
    _applyTheme(isDarkMode);
  }
}
