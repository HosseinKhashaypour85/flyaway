import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_theme_config/theme_service.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../app_change_lang_bottom_sheet/change_lang_bottom_sheet.dart';
import '../app_font_styles/app_font_styles.dart';

class AppAppBar {
  AppBar appBar(BuildContext context){
    final ThemeService themeService = ThemeService();
    return AppBar(backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 4,
      shadowColor: Colors.black26,
      actions: [
        // Theme toggle button with Obx
        Obx(() {
          final isDark = themeService.isDarkModeRx.value;
          return IconButton(
            onPressed: () {
              themeService.switchTheme();
            },
            icon: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
          );
        }),
        const Spacer(),
        Text(
          "flyaway".tr,
          style: AppFontStyles().FirstFontStyleWidget(20.sp, Colors.white),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => LanguageBottomSheet().showLanguageSheet(context),
          icon: const Icon(Icons.language, color: Colors.white),
        ),
      ],
    );
  }
}