import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flyaway/config/app_config/app_colors/app_colors.dart';
import 'package:flyaway/config/app_config/app_images_config/app_images.dart';
import 'package:flyaway/features/intro_features/controller/splash_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController splashController = Get.put(SplashController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Center(child: FadeInUp(child: Image.asset(AppImages.logoUrl)))],
        ),
      ),
    );
  }
}
