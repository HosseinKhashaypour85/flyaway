import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_colors/app_colors.dart';
import 'package:flyaway/config/app_config/app_elevatedbutton_config/app_button.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';
import 'package:flyaway/config/app_config/app_shapes/border_radius.dart';
import 'package:flyaway/config/app_config/app_shapes/media_query.dart';
import 'package:flyaway/config/app_config/app_shared_prefences/app_secure_storage.dart';
import 'package:flyaway/features/payment_features/screen/payment_screen.dart';
import 'package:flyaway/features/profile_features/controller/profile_controller.dart';
import 'package:get/get.dart';
import '../../../config/app_config/app_price_format/app_price_format.dart';
import '../widget/show_modal_bottom_sheet_widget.dart';

class AddWalletCount extends StatefulWidget {
  const AddWalletCount({super.key});

  @override
  State<AddWalletCount> createState() => _AddWalletCountState();
}

class _AddWalletCountState extends State<AddWalletCount> {
  final ProfileController profileController = Get.put(ProfileController());
  LocalStorage? storage;
  String? phone;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    storage = await LocalStorage.getInstance();
    phone = await storage!.get("phone");
    if (phone != null) {
      await profileController.getWalletCount(phone!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'paymentsMethod'.tr,
          style: AppFontStyles().FirstFontStyleWidget(16.sp, Colors.white),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.sp),
            Center(
              child: Container(
                width: getAllWidth(context) - 10.sp,
                child: Card(
                  elevation: 4,
                  color: primary2Color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        height: 140,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "yourBalance".tr,
                                style: AppFontStyles().FirstFontStyleWidget(
                                  16.sp, Colors.white,
                                ),
                              ),

                              Obx(() => Text(
                                formatNumber(profileController.walletCount.value),
                                style: AppFontStyles().FirstFontStyleWidget(
                                  14.sp, Colors.white,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Spacer(),

            Padding(
              padding: EdgeInsets.only(bottom: 10.sp),
              child: AppButton.general(
                text: 'addCount'.tr,
                onPressed: () {
                  if (phone != null) {
                    showModalBottomSheetWidget(context, phone!);
                  } else {
                    Get.snackbar("خطا", "شماره موبایل یافت نشد");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




