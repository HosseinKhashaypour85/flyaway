import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_change_lang_bottom_sheet/change_lang_bottom_sheet.dart';
import 'package:flyaway/config/app_config/app_colors/app_colors.dart';
import 'package:flyaway/config/app_config/app_elevatedbutton_config/app_button.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';
import 'package:flyaway/config/app_config/app_shapes/border_radius.dart';
import 'package:flyaway/config/app_config/app_shapes/media_query.dart';
import 'package:flyaway/features/home_features/controller/home_controller.dart';
import 'package:get/get.dart';

import '../model/home_row_ticket_model.dart';
import '../services/home_rows_ticket_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    homeController.onInit();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        elevation: 4,
        shadowColor: Colors.black26,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Expanded(
              child: Obx(() {
                final data = homeController.ticketRow.value;
                if (data == null || data.items == null || data.items!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.airplane_ticket,
                          size: 64.w,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'no_tickets_available'.tr,
                          style: AppFontStyles().FirstFontStyleWidget(
                            16.sp,
                            Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox(
                  height: 200.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: data.items!.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final items = data.items![index];
                      return Container(
                        width: 300.w, // عرض بنر، بزرگ‌تر برای حس تمام‌صفحه
                        height: 200.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.sp),
                          image: DecorationImage(
                            image: NetworkImage(items.imageUrl ?? ''),
                            // تصویر پس‌زمینه
                            fit: BoxFit.cover, // پوشش کامل
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // گرادیان تیره برای خوانایی متن (اختیاری، از پایین)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.sp),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.6),
                                      // تیره‌تر در پایین
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // متن overlay
                            Positioned(
                              bottom: 20.h, // از پایین
                              left: 16.w,
                              right: 16.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Text(
                                      items.ticketTitle ?? 'Flights',
                                      style: AppFontStyles()
                                          .FirstFontStyleWidget(
                                            14.sp,
                                            Colors.white,
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Explore_global_destinations'.tr,
                                    style: AppFontStyles().FirstFontStyleWidget(13.sp, Colors.white)
                                  ),
                                  SizedBox(height: 8.h),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 32.h,
                                    child: AppButton.general(
                                      text: 'view_available_tickets'.tr,
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
