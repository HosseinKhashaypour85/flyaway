import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageService extends GetxController {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  static const String _keyLanguage = 'language';
  final GetStorage _box = GetStorage();

  final RxString currentLang = 'fa'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final savedLang = _box.read(_keyLanguage) ?? 'fa';
    currentLang.value = savedLang;
  }

  Locale get currentLocale {
    return currentLang.value == 'fa'
        ? const Locale('fa', 'IR')
        : const Locale('en', 'US');
  }

  Future<void> setLanguage(String langCode) async {
    await _box.write(_keyLanguage, langCode);
    currentLang.value = langCode;
    Get.updateLocale(
      langCode == 'fa' ? const Locale('fa', 'IR') : const Locale('en', 'US'),
    );
  }

  Future<void> switchLanguage() async {
    if (currentLang.value == 'fa') {
      await setLanguage('en');
    } else {
      await setLanguage('fa');
    }
  }

  String get currentLanguageName {
    return currentLang.value == 'fa' ? 'فارسی' : 'English';
  }

  bool get isPersian => currentLang.value == 'fa';
}