import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_theme_config/app_themes.dart';
import 'package:flyaway/features/auth_features/screen/auth_screen.dart';
import 'package:flyaway/features/home_features/screen/home_screen.dart';
import 'package:flyaway/features/intro_features/screen/splash_screen.dart';
import 'package:flyaway/features/public_features/screen/bottom_nav_screen.dart';
import 'package:flyaway/features/search_features/screen/search_screen.dart';
import 'package:flyaway/features/trip_features/screen/buy_ticket_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'config/app_config/app_localization_config/language_service.dart';
import 'config/app_config/app_localization_config/translation.dart';
import 'config/app_config/app_theme_config/theme_service.dart';
import 'features/trip_features/screen/trip_history_screen.dart';

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
        theme: AppThemes().lightTheme,
        translations: AppTranslation(),
        locale: LanguageService().currentLocale,
        fallbackLocale: const Locale('fa', 'IR'),
        darkTheme: AppThemes().darkTheme,
        initialRoute: '/bottomNav',
        themeMode: themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        getPages: [
          GetPage(name: '/', page: () => const SplashScreen()),
          GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(name: '/auth', page: () => AuthScreen()),
          GetPage(name: '/bottomNav', page: () => BottomNavBarScreen(),),
          GetPage(name: '/search', page: () => SearchScreen(),),
          GetPage(name: '/tripsHistory', page: () => TripHistoryScreen(),),
          GetPage(name: '/buy_ticket', page: () => BuyTicketScreen(),)
        ],
      ),
    );
  }
}
