import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';
import 'package:flyaway/features/auth_features/services/auth_api_services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthApiServices _authApiServices = AuthApiServices();
  RxBool isLoading = false.obs;
  RxBool isOtpLoading = false.obs; // Add this line

  Future<void> callAuthApiServices(
      String firstName,
      String lastName,
      String phone,
      ) async {
    isLoading.value = true;
    try {
      final response = await _authApiServices.callAuthApiServices(
        firstName,
        lastName,
        phone,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          '',
          '',
          titleText: Text(
            'otpSuccess'.tr,
            style: TextStyle(
              fontFamily: 'kalameh',
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'fillOtpCode'.tr,
            style: AppFontStyles().FirstFontStyleWidget(14.sp, Colors.white),
          ),
          icon: const Icon(Icons.check_circle, color: Colors.green),
          snackPosition: SnackPosition.TOP,
        );
        Get.offAllNamed('/confirm-otp' , arguments: {
          'phone' : phone
        });
      }
    } catch (e) {
      print("❌ error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> callConfirmOtp(String phone, String code) async {
    isOtpLoading.value = true; // Use it here
    try {
      final response = await _authApiServices.callConfirmOtp(phone, code);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          '',
          '',
          titleText: Text(
            'authSuccessLogin'.tr,
            style: TextStyle(
              fontFamily: 'kalameh',
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
          messageText: Text(
            'authSuccessLoginTextMsg'.tr,
            style: AppFontStyles().FirstFontStyleWidget(14.sp, Colors.white),
          ),
          icon: const Icon(Icons.check_circle, color: Colors.green),
          snackPosition: SnackPosition.TOP,
        );
        Get.offAllNamed('/bottomNav');
      }
    } on DioException catch (e) {
      Get.snackbar(
        'error'.tr,
        e.response?.data?['message'] ?? 'somethingWentWrong'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isOtpLoading.value = false; // Reset it here
    }
  }
}