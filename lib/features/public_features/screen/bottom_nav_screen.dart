import 'package:flutter/material.dart';
import 'package:flyaway/config/app_config/app_theme_config/app_themes.dart';
import 'package:flyaway/config/app_config/app_theme_config/theme_service.dart';
import 'package:flyaway/features/home_features/screen/home_screen.dart';
import 'package:flyaway/features/search_features/screen/search_screen.dart';
import 'package:flyaway/features/trip_features/screen/trip_history_screen.dart';
import 'package:get/get.dart';

import '../../../config/app_config/app_colors/app_colors.dart';
import '../controller/bottom_nav_controller.dart';

class BottomNavBarScreen extends StatelessWidget {
  BottomNavBarScreen({super.key});

  static const String screenId = 'bottomNav';

  final BottomNavController controller = Get.put(BottomNavController());
  final ThemeService themeService = ThemeService();

  final List<Widget> screenList = [
    HomeScreen(),
    SearchScreen(),
    TripHistoryScreen(),
    Container(color: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = themeService.isDarkModeRx.value;

    final bgColor = Theme.of(context).bottomNavigationBarTheme.backgroundColor;

    return Obx(() {
      return Scaffold(
        body: screenList[controller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: bgColor,
          type: BottomNavigationBarType.fixed,
          // selectedItemColor: Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          // unselectedItemColor: Colors.black,
          selectedLabelStyle: const TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'peyda',
          ),
          unselectedLabelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'peyda',
          ),
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          items: [
            BottomNavigationBarItem(
              label: 'bottom_nav_home'.tr,
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "bottom_nav_search".tr,
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              label: 'bottom_nav_trips'.tr,
              icon: Icon(Icons.airplane_ticket_outlined),
              activeIcon: Icon(Icons.airplane_ticket),
            ),
            BottomNavigationBarItem(
              label: 'bottom_nav_profile'.tr,
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
            ),
          ],
        ),
      );
    });
  }
}
