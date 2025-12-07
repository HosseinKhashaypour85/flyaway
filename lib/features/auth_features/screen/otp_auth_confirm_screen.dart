import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';

import '../controller/auth_controller.dart';

class OtpAuthConfirmScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpAuthConfirmScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpAuthConfirmScreen> createState() => _OtpAuthConfirmScreenState();
}

class _OtpAuthConfirmScreenState extends State<OtpAuthConfirmScreen> {
  final AuthController _authController = Get.put(AuthController());
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final Color primaryBlue = const Color(0xFF2196F3);
  final Color lightBlue = const Color(0xFFE3F2FD);
  final Color darkBlue = const Color(0xFF1976D2);

  @override
  void initState() {
    super.initState();
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && _otpControllers[i].text.isEmpty) {
          if (i > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
          }
        }
      });
    }
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < _otpControllers.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }

    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    if (_isOtpComplete()) {
      _submitOtp();
    }
  }

  bool _isOtpComplete() {
    for (var controller in _otpControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  String _getOtpCode() {
    return _otpControllers.map((c) => c.text).join();
  }

  void _submitOtp() {
    final otpCode = _getOtpCode();
    if (otpCode.length == 6) { // Changed from 4 to 6
      _authController.callConfirmOtp(widget.phoneNumber, otpCode);
    }
  }

  void _resendOtp() {
    // Implement resend OTP logic here
    Get.snackbar(
      'otpResent'.tr,
      'newOtpSent'.tr,
      backgroundColor: primaryBlue,
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                'verifyPhone'.tr,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                  fontFamily: 'kalameh',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'enterOtpSentTo'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                widget.phoneNumber,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
              SizedBox(height: 40.h),

              // OTP Input Fields - CHANGED FROM 4 TO 6
              Center(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50.w,
                        height: 60.h,
                        child: TextField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: lightBlue,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryBlue.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(
                                color: primaryBlue,
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: primaryBlue),
                            ),
                          ),
                          onChanged: (value) => _onOtpChanged(value, index),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),

              SizedBox(height: 30.h),

              // Timer and Resend OTP
              Center(
                child: Column(
                  children: [
                    Text(
                      'didntReceiveCode'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'resendOtpIn'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        TweenAnimationBuilder<Duration>(
                          duration: const Duration(minutes: 2),
                          tween: Tween(
                            begin: const Duration(minutes: 2),
                            end: Duration.zero,
                          ),
                          onEnd: () {
                            print('Timer ended');
                          },
                          builder: (BuildContext context, Duration value, Widget? child) {
                            final minutes = value.inMinutes;
                            final seconds = value.inSeconds % 60;
                            return Text(
                              '$minutes:${seconds.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: primaryBlue,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: _resendOtp,
                      child: Text(
                        'resendOtp'.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Verify Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _isOtpComplete() && !_authController.isOtpLoading.value
                      ? _submitOtp
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: primaryBlue.withOpacity(0.5),
                  ),
                  child: _authController.isOtpLoading.value
                      ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                      : Text(
                    'verify'.tr,
                    style: AppFontStyles().FirstFontStyleWidget(13.sp, Colors.white)
                  ),
                ),
              )),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}