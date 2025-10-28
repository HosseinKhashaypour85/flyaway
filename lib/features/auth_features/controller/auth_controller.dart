import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/features/auth_features/services/auth_api_services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{
  final AuthApiServices _authApiServices = AuthApiServices();

  Future<void> callAuthApiServices(String firstName, String lastName, String email) async {
    try {
      final response = await _authApiServices.callAuthApiServices(
        firstName,
        lastName,
        email,
      );
      if(response.statusCode == 200 || response.statusCode == 201){
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
          icon: const Icon(Icons.check_circle, color: Colors.green),
          // backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
    } catch (e) {
      print("❌ error: $e");
    }
  }
}
