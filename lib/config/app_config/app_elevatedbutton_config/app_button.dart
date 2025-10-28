import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_shapes/media_query.dart';
import '../app_colors/app_colors.dart';
import '../app_font_styles/app_font_styles.dart';
class AppButton {
  /// دکمه عمومی
  static Widget general({
    required String text,
    required VoidCallback onPressed,
    Color backgroundColor = primary2Color,
    double widthFactor = 0.8, // درصد از عرض صفحه
    double heightFactor = 0.05, // درصد از ارتفاع صفحه
    double borderRadius = 10,
    TextStyle? textStyle,
  }) {
    return Builder(
      builder: (context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          fixedSize: Size(
            getWidth(context, widthFactor),
            getHeight(context, heightFactor)
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style:
              textStyle ??
              AppFontStyles().FirstFontStyleWidget(14.sp, Colors.white),
        ),
      ),
    );
  }
}
