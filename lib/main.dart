import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_theme_config/app_themes.dart';
import 'package:flyaway/features/auth_features/screen/auth_screen.dart';
import 'package:flyaway/features/home_features/screen/home_screen.dart';
import 'package:flyaway/features/intro_features/screen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'config/app_config/app_localization_config/language_service.dart';
import 'config/app_config/app_localization_config/translation.dart';
import 'config/app_config/app_theme_config/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final themeService = ThemeService();
  themeService.initTheme();

  final languageService = LanguageService();

  runApp(MyApp(themeService: themeService, languageService: languageService));
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;
  final LanguageService languageService;

  const MyApp({
    super.key,
    required this.themeService,
    required this.languageService,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        translations: AppTranslation(),
        locale: LanguageService().currentLocale,
        fallbackLocale: const Locale('fa', 'IR'),
        darkTheme: darkTheme,
        initialRoute: '/home',
        getPages: [
          GetPage(name: '/', page: () => const SplashScreen()),
          GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(name: '/auth', page: () => AuthScreen()),
        ],
      ),
    );
  }
}
