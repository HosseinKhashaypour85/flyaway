import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_colors/app_colors.dart';
import 'package:flyaway/config/app_config/app_localization_config/language_service.dart';
import 'package:flyaway/config/app_config/app_shapes/border_radius.dart';
import 'package:flyaway/config/app_config/app_shapes/media_query.dart';
import 'package:flyaway/config/app_config/app_shared_prefences/app_secure_storage.dart';
import 'package:flyaway/config/app_config/app_textfield_widgets/email_textfield_widget.dart';
import 'package:flyaway/config/app_config/app_textfield_widgets/textformfield_widget.dart';
import 'package:flyaway/features/auth_features/widget/icon_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../config/app_config/app_font_styles/app_font_styles.dart';
import 'package:get/get.dart';

import '../../../config/app_config/app_token_generator/app_token_generator.dart';
import '../controller/auth_controller.dart';
import '../../../config/app_config/app_change_lang_bottom_sheet/change_lang_bottom_sheet.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LanguageService languageService = Get.put(LanguageService());
  final AuthController authController = Get.put(AuthController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  LocalStorage? localStorage;

  // token generator function
  final AppTokenGenerator appTokenGenerator = AppTokenGenerator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          iconButtonWidget(() {
            LanguageBottomSheet().showLanguageSheet(context);
          }, Icon(Icons.language)),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.sp),
            Center(
              child: Text(
                'AuthTitle'.tr,
                style: AppFontStyles().FirstFontStyleWidget(
                  14.sp,
                  Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // CustomTextField(controller: emailController, labelText: 'email')
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: BlueEmailTextField(
                    controller: nameController,
                    hintText: 'authName'.tr,
                    icon: Icon(Icons.email, color: Colors.blueAccent),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: BlueEmailTextField(
                    controller: lastNameController,
                    hintText: 'authLastName'.tr,
                    icon: Icon(Icons.email, color: Colors.blueAccent),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: BlueEmailTextField(
                    controller: emailController,
                    hintText: 'authEmail'.tr,
                    icon: Icon(Icons.email, color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 10.sp),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary2Color,
                  fixedSize: Size(
                    getWidth(context, 0.8.sp),
                    getHeight(context, 0.05.sp),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: getBorderRadiusFunc(10),
                  ),
                ),
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      lastNameController.text.isEmpty ||
                      emailController.text.isEmpty) {
                    Get.snackbar(
                      '',
                      '',
                      titleText: Text(
                        'authSnackBarErrorWarn'.tr,
                        style: TextStyle(
                          fontFamily: 'peyda',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                      messageText: Text(
                        'authSnackBarError'.tr,
                        style: TextStyle(
                          fontFamily: 'kalameh',
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(Icons.error, color: Colors.white),
                      backgroundColor: Colors.red,
                      snackPosition: SnackPosition.TOP,
                    );
                    return;
                  } else {
                    localStorage = await LocalStorage.getInstance();
                    final setToken = await localStorage!.set(
                      'token',
                      appTokenGenerator.generateToken(),
                    );
                    await authController.callAuthApiServices(
                      nameController.text,
                      lastNameController.text,
                      emailController.text,
                    );
                  }
                },
                child: Text(
                  'authButton'.tr,
                  style: AppFontStyles().FirstFontStyleWidget(
                    14.sp,
                    Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
