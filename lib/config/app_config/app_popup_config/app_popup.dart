import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';
import 'package:get/get.dart';

class AppPopup extends StatefulWidget {
  const AppPopup({super.key});

  @override
  State<AppPopup> createState() => _AppPopupState();
}

class _AppPopupState extends State<AppPopup> {
  String? selectedValue;
  List<String> options = ['airplane'.tr, 'train'.tr, 'bus'.tr, 'taxi'.tr];

  @override
  Widget build(BuildContext context) {
    final argument = Get.arguments;
    final ticketType = argument['ticket_type'.tr];
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: DropdownButton(
        hint: Text(ticketType , style: AppFontStyles().FirstFontStyleWidget(14.sp, Colors.grey),),
        value: selectedValue,
        items: options.map((option) {
          return DropdownMenuItem(value: option, child: Text(option));
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
      ),
    );
  }
}
