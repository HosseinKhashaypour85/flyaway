import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

class LanguageService {
  static const String _keyLanguage = 'language';
  final GetStorage _box = GetStorage();

  /// زبان ذخیره‌شده را می‌خواند
  Locale get currentLocale {
    final langCode = _box.read(_keyLanguage) ?? 'fa';
    if (langCode == 'fa') {
      return const Locale('fa', 'IR');
    } else {
      return const Locale('en', 'US');
    }
  }

  /// تنظیم زبان جدید + ذخیره و آپدیت GetX
  Future<void> setLanguage(String langCode) async {
    await _box.write(_keyLanguage, langCode);
    if (langCode == 'fa') {
      Get.updateLocale(const Locale('fa', 'IR'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
  }

  /// تغییر دستی بین فارسی و انگلیسی
  Future<void> switchLanguage() async {
    if (currentLocale.languageCode == 'fa') {
      await setLanguage("en");
    } else {
      await setLanguage("fa");
    }
  }
}
