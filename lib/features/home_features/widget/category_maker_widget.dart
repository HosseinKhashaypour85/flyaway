import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/app_config/app_font_styles/app_font_styles.dart';
import 'category_items_widget.dart';

Widget categoryMaker(BuildContext context) {
  final textTheme = Theme.of(context).textTheme;
  return Column(
    children: [
      Text(
        'categories_text'.tr,
        style: TextStyle(
          fontSize: 13.sp,
          color: textTheme.bodyLarge?.color,
          fontFamily: 'peyda',
        ),
      ),
      SizedBox(height: 5.h),
      categoryItems(),
    ],
  );
}
