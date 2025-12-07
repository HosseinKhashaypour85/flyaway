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
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LocalStorage? localStorage;

  // token generator function
  final AppTokenGenerator appTokenGenerator = AppTokenGenerator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: IconButton(
              onPressed: () {
                LanguageBottomSheet().showLanguageSheet(context);
              },
              icon: Icon(Icons.language, color: primary2Color, size: 20.sp),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.sp),

                  // Welcome Title with gradient
                  _buildWelcomeHeader(),

                  SizedBox(height: 48.sp),

                  // Form Fields
                  _buildTextFieldSection(),

                  SizedBox(height: 36.sp),

                  // Submit Button
                  _buildSubmitButton(),

                  SizedBox(height: 40.sp),

                  // Additional Info
                  // _buildAdditionalInfo(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon decoration
        Container(
          width: 60.sp,
          height: 60.sp,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary2Color.withOpacity(0.1), primary2Color.withOpacity(0.2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.sp),
          ),
          child: Icon(
            Icons.person_add_alt_1,
            color: primary2Color,
            size: 32.sp,
          ),
        ),
        SizedBox(height: 24.sp),

        // Title
        Text(
          'AuthTitle'.tr,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'peyda',
            height: 1.2,
          ),
        ),
        SizedBox(height: 12.sp),
      ],
    );
  }

  Widget _buildTextFieldSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.sp),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(24.sp),
      child: Column(
        children: [
          _buildTextFieldWithLabel(
            controller: nameController,
            label: 'authName'.tr,
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'authNameRequired'.tr;
              }
              return null;
            },
          ),
          SizedBox(height: 20.sp),

          _buildTextFieldWithLabel(
            controller: lastNameController,
            label: 'authLastName'.tr,
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'authLastNameRequired'.tr;
              }
              return null;
            },
          ),
          SizedBox(height: 20.sp),

          _buildTextFieldWithLabel(
            controller: phoneController,
            label: 'authPhone'.tr,
            icon: Icons.phone_android,
            validator: (value) {
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithLabel({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.sp, bottom: 8.sp),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              fontFamily: 'kalameh',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(14.sp),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Row(
              children: [
                Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: BoxDecoration(
                    color: primary2Color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: primary2Color, size: 18.sp),
                ),
                SizedBox(width: 12.sp),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    validator: validator,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black,
                      fontFamily: 'kalameh',
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: label,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontFamily: 'kalameh',
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      final isLoading = authController.isLoading.value;

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.sp),
          boxShadow: [
            BoxShadow(
              color: primary2Color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 58.sp,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary2Color,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.sp),
              ),
              shadowColor: Colors.transparent,
            ),
            onPressed: isLoading ? null : _handleSubmit,
            child: isLoading
                ? SizedBox(
              width: 22.sp,
              height: 22.sp,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'authButton'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'peyda',
                  ),
                ),
                SizedBox(width: 8.sp),
                Icon(Icons.arrow_forward, size: 18.sp, color: Colors.white),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Widget _buildAdditionalInfo() {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Expanded(
  //             child: Divider(color: Colors.grey[300], thickness: 1),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 16.sp),
  //             child: Text(
  //               'authPrivacy'.tr,
  //               style: TextStyle(
  //                 fontSize: 12.sp,
  //                 color: Colors.grey[500],
  //                 fontFamily: 'kalameh',
  //               ),
  //             ),
  //           ),
  //           Expanded(
  //             child: Divider(color: Colors.grey[300], thickness: 1),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 20.sp),
  //       Container(
  //         padding: EdgeInsets.all(16.sp),
  //         decoration: BoxDecoration(
  //           color: Colors.green[50],
  //           borderRadius: BorderRadius.circular(12.sp),
  //           border: Border.all(color: Colors.green[100]!),
  //         ),
  //         child: Row(
  //           children: [
  //             Container(
  //               width: 36.sp,
  //               height: 36.sp,
  //               decoration: BoxDecoration(
  //                 color: Colors.green[100],
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(Icons.security, color: Colors.green[600], size: 18.sp),
  //             ),
  //             SizedBox(width: 12.sp),
  //             Expanded(
  //               child: Text(
  //                 'authPrivacyInfo'.tr,
  //                 style: TextStyle(
  //                   fontSize: 12.sp,
  //                   color: Colors.green[700],
  //                   fontFamily: 'kalameh',
  //                   height: 1.4,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      localStorage = await LocalStorage.getInstance();
      final setToken = await localStorage!.set(
        'token',
        appTokenGenerator.generateToken(),
      );
      final setName = await localStorage!.set('name', nameController.text);
      final setLastName = await localStorage!.set('lastName', lastNameController.text);
      final setPhone = await localStorage!.set('phone', phoneController.text);

      await authController.callAuthApiServices(
        nameController.text,
        lastNameController.text,
        phoneController.text,
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}