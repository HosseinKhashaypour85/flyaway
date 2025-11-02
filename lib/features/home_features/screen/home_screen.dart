import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_change_lang_bottom_sheet/change_lang_bottom_sheet.dart';
import 'package:flyaway/config/app_config/app_elevatedbutton_config/app_button.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';
import 'package:flyaway/config/app_config/app_search_bar/app_search_bar.dart';
import 'package:flyaway/config/app_config/app_shapes/media_query.dart';
import 'package:flyaway/config/app_config/app_theme_config/app_themes.dart';
import 'package:flyaway/config/app_config/app_theme_config/theme_service.dart';
import 'package:flyaway/features/home_features/controller/home_controller.dart';
import 'package:get/get.dart';

import '../widget/category_maker_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ThemeService themeService = ThemeService();
  final HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Expanded(
              flex: 2,
              child: SearchInput(),
            ),
            SizedBox(height: 10.h),

            // Tickets Section
            Expanded(
              flex: 8,
              child: Obx(() {
                final data = homeController.ticketRow.value;
                final isDark = themeService.isDarkModeRx.value;

                if (data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (data.items == null || data.items!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.airplane_ticket,
                          size: 64.w,
                          color: isDark
                              ? Colors.grey[600]
                              : Colors.grey.shade400,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'no_tickets_available'.tr,
                          style: AppFontStyles().FirstFontStyleWidget(
                            16.sp,
                            isDark ? Colors.grey[400]! : Colors.grey.shade600,
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
                        width: getWidth(context, 0.7),
                        height: 200.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.sp),
                          image: DecorationImage(
                            image: NetworkImage(items.imageUrl ?? ''),
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20.h,
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
                                    style: AppFontStyles()
                                        .FirstFontStyleWidget(
                                      13.sp,
                                      Colors.white,
                                    ),
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
            SizedBox(height: 15.h),

            // Categories
            categoryMaker(context),
            SizedBox(height: 20.h),

            // Comments Section
            Expanded(
              flex: 4,
              child: Obx(() {
                final isDark = themeService.isDarkModeRx.value;
                final cardColor = isDark
                    ? AppThemes().darkTheme.cardColor
                    : AppThemes().lightTheme.cardColor;
                final data = homeController.showComments.value;
                final comments = data?.comments ?? [];

                if (data == null) {
                  return Center(child: CircularProgressIndicator());
                }

                if (comments.isEmpty) {
                  return Center(
                    child: Text(
                      'no_comments_available'.tr,
                      style: AppFontStyles().FirstFontStyleWidget(
                        16.sp,
                        Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Container(
                      width: getWidth(context, 0.5.sp),
                      margin: EdgeInsets.only(right: 12.w),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12.sp),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.userName ?? 'Unknown',
                            style: AppFontStyles().FirstFontStyleWidget(
                              14.sp,
                              Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Expanded(
                            child: Text(
                              comment.comment ?? '',
                              style: AppFontStyles().FirstFontStyleWidget(
                                12.sp,
                                Colors.white,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16.w),
                              SizedBox(width: 4.w),
                              Text(
                                comment.rating?.toString() ?? '0',
                                style: AppFontStyles().FirstFontStyleWidget(
                                  12.sp,
                                  Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}