import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_app_bar/app_app_bar.dart';
import 'package:flyaway/config/app_config/app_change_lang_bottom_sheet/change_lang_bottom_sheet.dart';
import 'package:flyaway/config/app_config/app_elevatedbutton_config/app_button.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';
import 'package:flyaway/config/app_config/app_search_bar/app_search_bar.dart';
import 'package:flyaway/config/app_config/app_shapes/media_query.dart';
import 'package:flyaway/config/app_config/app_theme_config/app_themes.dart';
import 'package:flyaway/config/app_config/app_theme_config/theme_service.dart';
import 'package:flyaway/features/home_features/controller/home_controller.dart';
import 'package:flyaway/features/home_features/widget/shimmer_loading_widget.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../widget/category_maker_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ThemeService themeService = ThemeService();
  final HomeController homeController = Get.put(HomeController());
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    homeController.onInit();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppAppBar().appBar(context),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Expanded(flex: 2, child: SearchInput()),
            SizedBox(height: 10.h),

            // Tickets Section
            Expanded(
              flex: 8,
              child: Obx(() {
                final data = homeController.ticketRow.value;
                final isDark = themeService.isDarkModeRx.value;

                if (data == null) {
                  return Center(
                    child: ShimmerLoadingClass().shimmerTicketRows(),
                  );
                }

                if (data.items == null || data.items!.isEmpty) {
                  return Center(
                    child: ShimmerLoadingClass().shimmerTicketRows(),
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
                                    style: AppFontStyles().FirstFontStyleWidget(
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
                                      onPressed: () {
                                        if (index == 0) {
                                          Get.offNamed(
                                            '/buy_ticker',
                                            arguments: {
                                              'ticket_type': items.ticketTitle,
                                            },
                                          );
                                        } else if (index == 1) {
                                          print('item2');
                                        } else {
                                          print('item3');
                                        }
                                      },
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
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        Padding(padding: EdgeInsets.all(5.sp)),
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ShimmerLoadingClass().shimmerComments();
                    },
                  );
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
                final pageController = PageController(viewportFraction: 0.8);
                int currentPage = 0;

                Timer.periodic(const Duration(seconds: 3), (Timer timer) {
                  if (currentPage < comments.length - 1) {
                    currentPage++;
                  } else {
                    currentPage = 0;
                  }
                  if (pageController.hasClients) {
                    pageController.animateToPage(
                      currentPage,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                });

                // comments section
                return PageView.builder(
                  controller: pageController,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Container(
                        margin: EdgeInsets.only(right: 12.w),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12.sp),
                          boxShadow: const [
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
                                RatingBar.builder(
                                  itemSize: 16.w,
                                  initialRating:
                                      comment.rating?.toDouble() ?? 1,
                                  itemCount: 5,
                                  itemBuilder: (context, index) =>
                                      Icon(Icons.star, color: Colors.amber),
                                  onRatingUpdate: (value) {},
                                ),
                              ],
                            ),
                          ],
                        ),
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
