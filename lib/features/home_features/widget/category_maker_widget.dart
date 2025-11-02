import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/app_config/app_font_styles/app_font_styles.dart';
import 'category_items_widget.dart';

Widget categoryMaker() {
  return Column(
    children: [
      Text(
        'categories_text'.tr,
        style: AppFontStyles().FirstFontStyleWidget(14.sp, Colors.black),
      ),
      SizedBox(height: 5.h,),
      categoryItems(),
    ],
  );
}