import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_colors/app_colors.dart';
import 'package:get/get.dart';

Widget categoryItems() {
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.airplanemode_active, 'title': 'airplane'.tr},
    {'icon': Icons.train, 'title': 'train'.tr},
    {'icon': Icons.directions_bus, 'title': 'bus'.tr},
    {'icon': Icons.hotel, 'title': 'hotel'.tr},
    {'icon': Icons.local_taxi, 'title': 'taxi'.tr},
  ];

  return SizedBox(
    height: 90.h,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      separatorBuilder: (context, index) => SizedBox(width: 12.w),
      itemBuilder: (context, index) {
        final category = categories[index];
        return Container(
          width: 80.w,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                category['icon'],
                color: primary2Color,
                size: 28.sp,
              ),
              SizedBox(height: 6.h),
              Text(
                category['title'],
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'peyda',
                  color: Colors.black
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    ),
  );
}