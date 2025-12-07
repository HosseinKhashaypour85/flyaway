import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../config/app_config/app_elevatedbutton_config/app_button.dart';
import '../../../config/app_config/app_font_styles/app_font_styles.dart';
import '../../../config/app_config/app_price_format/app_price_format.dart';
import '../../payment_features/screen/payment_screen.dart';
import '../controller/profile_controller.dart';

Widget showModalContent(String phone) {
  final ProfileController profileController = Get.put(ProfileController());

  final List<int> priceChips = [50000, 100000, 150000, 200000, 250000];

  RxString amountText = ''.obs;
  final TextEditingController controller = TextEditingController();

  return FractionallySizedBox(
    heightFactor: 0.65,
    child: Column(
      children: [
        SizedBox(height: 20.sp),

        Obx(() => Text(
          formatNumber(profileController.walletCount.value),
          style: AppFontStyles().FirstFontStyleWidget(13.sp, Colors.black),
        )),

        SizedBox(height: 10),

        Padding(
          padding: EdgeInsets.all(8.sp),
          child: Obx(() => TextField(
            keyboardType: TextInputType.number,
            controller: controller..text = amountText.value,
            onChanged: (value) => amountText.value = value,
            decoration: InputDecoration(
              labelText: "countField".tr,
              labelStyle: AppFontStyles().FirstFontStyleWidget(12.sp, Colors.black),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

            ),
          )),
        ),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: priceChips.map((price) {
            return Obx(() => FilterChip(
              label: Text(formatNumber(price)),
              selected: amountText.value == price.toString(),
              onSelected: (_) {
                amountText.value = price.toString();
                controller.text = amountText.value;
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: amountText.value == price.toString()
                    ? Colors.white
                    : Colors.black,
              ),
            ));
          }).toList(),
        ),

        Spacer(),

        Padding(
          padding: EdgeInsets.only(bottom: 40.sp),
          child: AppButton.general(
            text: "افزایش موجودی",
            onPressed: () async {
              if (amountText.value.isEmpty) {
                Get.snackbar("خطا", "لطفاً مبلغ را وارد کنید");
                return;
              }

              final int amount = int.parse(amountText.value);

              final result = await Get.to(() => PaymentPage(amount: amount));

              if (result != null) {
                await profileController.addAmountToWallet(phone, amount);
                Get.back();
                Get.snackbar("موفقیت", "موجودی با موفقیت بروزرسانی شد");
              }
            },
          ),
        ),
      ],
    ),
  );
}
