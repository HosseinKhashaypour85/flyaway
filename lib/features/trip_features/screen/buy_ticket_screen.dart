import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_colors/app_colors.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';
import 'package:get/get.dart';
import 'package:flyaway/features/trip_features/controller/buy_ticket_controller.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../payment_features/screen/payment_screen.dart';
import '../widget/counter_text_animation_widget.dart';

class BuyTicketScreen extends StatefulWidget {
  const BuyTicketScreen({super.key});

  @override
  State<BuyTicketScreen> createState() => _BuyTicketScreenState();
}

class _BuyTicketScreenState extends State<BuyTicketScreen> {
  final BuyTicketController ticketController = Get.put(BuyTicketController());
  final Random _random = Random();
  String? ticketType;

  // ------------------------------------------------------
  //   لیست شهرهای ایران
  // ------------------------------------------------------
  final List<String> iranCities = [
    'تهران',
    'مشهد',
    'اصفهان',
    'شیراز',
    'تبریز',
    'کرج',
    'اهواز',
    'قم',
    'کرمانشاه',
    'ارومیه',
    'رشت',
    'زاهدان',
    'همدان',
    'کرمان',
    'یزد',
    'اردبیل',
    'بندرعباس',
    'اسلامشهر',
    'زنجان',
    'سنندج',
    'قزوین',
    'خرم‌آباد',
    'گرگان',
    'ساری',
    'کاشان',
    'ملارد',
    'گلستان',
    'دزفول',
    'بوشهر',
    'بروجرد',
    'نجف‌آباد',
    'بابلسر',
    'آمل',
    'قائم‌شهر',
    'پاکدشت',
    'ورامین',
    'سبزوار',
    'خوی',
    'سمنان',
    'شاهرود',
    'مراغه',
    'بجنورد',
    'شاهین‌شهر',
    'مرودشت',
    'بندر ماهشهر',
    'کیش',
    'قشم',
    'رامسر',
    'لارستان',
    'ایلام'
  ];

  String? selectedOrigin;
  String? selectedDestination;
  final TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    ticketType = arguments['ticket_type'];
  }

  int passengersCount = 1;

  // ------------------------------------------------------
  //   تابع هوشمند برای محاسبه قیمت کل به صورت رندوم
  // ------------------------------------------------------
  int get totalPrice {
    if (!fieldsFilled) return 0; // اگر فیلدها پر نباشند قیمت صفر

    // محاسبه قیمت پایه به صورت رندوم بر اساس مقادیر ورودی
    int calculatedBasePrice = _calculateRandomBasePrice();

    // اعمال ضریب مسافر
    return calculatedBasePrice * passengersCount;
  }

  // ------------------------------------------------------
  //   محاسبه قیمت پایه به صورت رندوم و پویا
  // ------------------------------------------------------
  int _calculateRandomBasePrice() {
    int basePrice = 0;

    // قیمت پایه رندوم بین 500,000 تا 2,000,000 تومان
    basePrice = 500000 + _random.nextInt(1500001);

    // اعمال ضریب بر اساس نوع بلیط
    if (ticketType != null) {
      switch (ticketType) {
        case 'business':
          basePrice = (basePrice * (1.5 + _random.nextDouble() * 0.5)).round(); // 50% تا 100% افزایش
          break;
        case 'first_class':
          basePrice = (basePrice * (2.0 + _random.nextDouble() * 1.0)).round(); // 100% تا 200% افزایش
          break;
        case 'economy':
        default:
          basePrice = (basePrice * (0.8 + _random.nextDouble() * 0.4)).round(); // 20% کاهش تا 20% افزایش
          break;
      }
    }

    // اعمال ضریب بر اساس مسیر
    if (selectedOrigin != null && selectedDestination != null) {
      double routeMultiplier = _calculateRouteMultiplier(
          selectedOrigin!,
          selectedDestination!
      );
      basePrice = (basePrice * routeMultiplier).round();
    }

    // گرد کردن به نزدیک‌ترین 10,000
    basePrice = (basePrice ~/ 10000) * 10000;

    return basePrice;
  }

  // ------------------------------------------------------
  //   محاسبه ضریب مسیر بر اساس شهرهای انتخاب شده
  // ------------------------------------------------------
  double _calculateRouteMultiplier(String origin, String destination) {
    double multiplier = 1.0;

    // ضریب بر اساس فاصله فرضی بین شهرها
    if (_isLongDistanceRoute(origin, destination)) {
      multiplier += 0.5; // 50% افزایش برای مسافت طولانی
    } else if (_isMediumDistanceRoute(origin, destination)) {
      multiplier += 0.2; // 20% افزایش برای مسافت متوسط
    }

    // ضریب بر اساس شهرهای توریستی
    final touristCities = ['کیش', 'قشم', 'مشهد', 'شیراز', 'اصفهان'];
    if (touristCities.contains(origin) || touristCities.contains(destination)) {
      multiplier += 0.3;
    }

    // کمی رندوم‌سازی نهایی
    multiplier += _random.nextDouble() * 0.2 - 0.1; // ±10%

    return multiplier.clamp(0.7, 2.5); // محدود کردن بین 0.7 تا 2.5
  }

  // ------------------------------------------------------
  //   تشخیص مسافت طولانی
  // ------------------------------------------------------
  bool _isLongDistanceRoute(String origin, String destination) {
    final longDistancePairs = [
      {'تهران', 'بندرعباس'}, {'مشهد', 'اهواز'}, {'تبریز', 'بوشهر'},
      {'تهران', 'زاهدان'}, {'مشهد', 'بندرعباس'}, {'اصفهان', 'ارومیه'}
    ];

    return longDistancePairs.any((pair) =>
    (pair.contains(origin) && pair.contains(destination))
    );
  }

  // ------------------------------------------------------
  //   تشخیص مسافت متوسط
  // ------------------------------------------------------
  bool _isMediumDistanceRoute(String origin, String destination) {
    final mediumDistancePairs = [
      {'تهران', 'مشهد'}, {'تهران', 'شیراز'}, {'تهران', 'تبریز'},
      {'اصفهان', 'مشهد'}, {'شیراز', 'مشهد'}, {'تبریز', 'مشهد'}
    ];

    return mediumDistancePairs.any((pair) =>
    (pair.contains(origin) && pair.contains(destination))
    );
  }

  // ------------------------------------------------------
  //   چک کردن پر بودن فیلدها
  // ------------------------------------------------------
  bool get fieldsFilled =>
      selectedOrigin != null &&
          selectedDestination != null &&
          selectedOrigin != selectedDestination &&
          timeController.text.isNotEmpty;

  // ------------------------------------------------------
  //   ریست کردن قیمت وقتی فیلدها تغییر می‌کنند
  // ------------------------------------------------------
  void _onFieldChanged() {
    setState(() {
      // قیمت به صورت خودکار با getter محاسبه می‌شود
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCityDropdownCard(
              title: "origin".tr,
              hintText: "originDesc".tr,
              icon: Icons.trip_origin,
              value: selectedOrigin,
              onChanged: (String? newValue) {
                setState(() {
                  selectedOrigin = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            _buildCityDropdownCard(
              title: "destination".tr,
              hintText: "destinationDesc".tr,
              icon: Icons.location_on,
              value: selectedDestination,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDestination = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            _buildTimePickerCard(),
            const SizedBox(height: 20),

            _buildPassengersCard(),
            const SizedBox(height: 32),

            // ------------------------------------------------------
            //   نمایش قیمت با انیمیشن فقط وقتی فیلدها پر باشند
            // ------------------------------------------------------
            if (fieldsFilled) _buildPriceSection(),

            // نمایش پیام وقتی فیلدها پر نیستند
            if (!fieldsFilled) _buildFillFieldsMessage(),

            const SizedBox(height: 20),

            _buildBuyButton(),
            const SizedBox(height: 20),

            // _buildStatusSection(),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------
  //                      APP BAR
  // ------------------------------------------------------

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        "select_your_ticket_info".tr,
        style: AppFontStyles().FirstFontStyleWidget(18, Colors.white),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: primary2Color,
      foregroundColor: Colors.white,
    );
  }

  // ------------------------------------------------------
  //                    DROPDOWN CARD FOR CITIES
  // ------------------------------------------------------

  Widget _buildCityDropdownCard({
    required String title,
    required String hintText,
    required IconData icon,
    required String? value,
    required Function(String?) onChanged,
  }) {
    return Card(
      elevation: 3,
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primary2Color, size: 20), // تغییر رنگ آیکون به primary2Color
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppFontStyles().FirstFontStyleWidget(16, Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primary2Color.withOpacity(0.5)), // تغییر border به primary2Color
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      hintText,
                      style: AppFontStyles().FirstFontStyleWidget(14, Colors.grey[600]!),
                    ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(Icons.arrow_drop_down, color: primary2Color), // تغییر رنگ آیکون به primary2Color
                  ),
                  dropdownColor: Colors.white,
                  style: AppFontStyles().FirstFontStyleWidget(14, Colors.black),
                  selectedItemBuilder: (BuildContext context) {
                    return iranCities.map<Widget>((String city) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          city,
                          style: AppFontStyles().FirstFontStyleWidget(14, primary2Color), // تغییر رنگ متن انتخاب شده به primary2Color
                        ),
                      );
                    }).toList();
                  },
                  items: iranCities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          city,
                          style: AppFontStyles().FirstFontStyleWidget(14, Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------
  //                    TIME PICKER
  // ------------------------------------------------------

  Widget _buildTimePickerCard() {
    return Card(
      elevation: 3,
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time_rounded, color: primary2Color), // تغییر رنگ آیکون به primary2Color
                const SizedBox(width: 8),
                Text(
                  "travelTime".tr,
                  style: AppFontStyles().FirstFontStyleWidget(16, Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeController,
              readOnly: true,
              onTap: () async {
                Jalali? picked = await showPersianDatePicker(
                  context: context,
                  initialDate: Jalali.now(),
                  firstDate: Jalali(1380, 1),
                  lastDate: Jalali(1500, 12),
                );

                if (picked != null) {
                  setState(() {
                    timeController.text = picked.formatCompactDate();
                  });
                }
              },
              decoration: InputDecoration(
                hintText: "travelTimeDesc".tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primary2Color), // تغییر border به primary2Color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primary2Color, width: 2), // تغییر border focus به primary2Color
                ),
                hintStyle: AppFontStyles().FirstFontStyleWidget(12.sp, Colors.grey[700]),
                suffixIcon: Icon(Icons.calendar_month, color: primary2Color), // تغییر رنگ آیکون به primary2Color
              ),
            )
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------
  //                PASSENGERS SELECTOR
  // ------------------------------------------------------

  Widget _buildPassengersCard() {
    return Card(
      elevation: 3,
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.people_alt_rounded, color: primary2Color), // تغییر رنگ آیکون به primary2Color
                const SizedBox(width: 8),
                Text("passengers".tr,
                    style: AppFontStyles().FirstFontStyleWidget(16, Colors.black)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "passengersDesc".tr,
                  style: AppFontStyles().FirstFontStyleWidget(14, Colors.grey[600]!),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: primary2Color.withOpacity(0.3)), // تغییر border به primary2Color
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (passengersCount > 1) {
                            setState(() {
                              passengersCount--;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.remove_circle,
                          color: passengersCount > 1
                              ? primary2Color // تغییر رنگ به primary2Color
                              : Colors.grey[400],
                        ),
                      ),
                      Text(
                        passengersCount.toString(),
                        style: AppFontStyles().FirstFontStyleWidget(18, Colors.black),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            passengersCount++;
                          });
                        },
                        icon: Icon(Icons.add_circle, color: primary2Color), // تغییر رنگ به primary2Color
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // نمایش قیمت پایه برای هر مسافر
            if (fieldsFilled) ...[
              const SizedBox(height: 12),
              Text(
                "قیمت پایه برای هر مسافر: ${_formatPrice(totalPrice ~/ passengersCount)} تومان",
                style: AppFontStyles().FirstFontStyleWidget(12, primary2Color), // تغییر رنگ به primary2Color
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------
  //                  فرمت کردن قیمت برای نمایش
  // ------------------------------------------------------
  String _formatPrice(int price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)} میلیون';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)} هزار';
    }
    return price.toString();
  }

  // ------------------------------------------------------
  //                  PRICE ANIMATION
  // ------------------------------------------------------

  Widget _buildPriceSection() {
    return Column(
      children: [
        Text(
          "totalPrice".tr,
          style: AppFontStyles().FirstFontStyleWidget(16, Colors.grey[700]!),
        ),
        const SizedBox(height: 8),
        CounterTextAnimationWidget(
          value: totalPrice,
          textStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primary2Color, // تغییر رنگ قیمت به primary2Color
          ),
          duration: const Duration(milliseconds: 800),
        ),
        const SizedBox(height: 4),
        Text(
          "Tomans".tr,
          style: AppFontStyles().FirstFontStyleWidget(14, Colors.grey[600]!),
        ),
        const SizedBox(height: 8),
        Text(
          "نوع بلیط: ${_getTicketTypeName(ticketType)}",
          style: AppFontStyles().FirstFontStyleWidget(12, primary2Color), // تغییر رنگ به primary2Color
        ),
        if (selectedOrigin != null && selectedDestination != null) ...[
          const SizedBox(height: 4),
          Text(
            "مسیر: $selectedOrigin → $selectedDestination",
            style: AppFontStyles().FirstFontStyleWidget(12, primary2Color), // تغییر رنگ به primary2Color
          ),
        ],
      ],
    );
  }

  // ------------------------------------------------------
  //   گرفتن نام نوع بلیط
  // ------------------------------------------------------
  String _getTicketTypeName(String? type) {
    switch (type) {
      case 'business':
        return 'بیزینس';
      case 'first_class':
        return 'فرست کلاس';
      case 'economy':
        return 'اکونومی';
      default:
        return 'معمولی';
    }
  }

  // ------------------------------------------------------
  //                  MESSAGE FOR EMPTY FIELDS
  // ------------------------------------------------------

  Widget _buildFillFieldsMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.orange[700]),
              const SizedBox(width: 8),
              Text(
                "لطفا اطلاعات زیر را تکمیل کنید:",
                style: AppFontStyles().FirstFontStyleWidget(14, Colors.orange[700]!),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (selectedOrigin == null)
            Text("• مبداء را انتخاب کنید", style: AppFontStyles().FirstFontStyleWidget(12, Colors.orange[600]!)),
          if (selectedDestination == null)
            Text("• مقصد را انتخاب کنید", style: AppFontStyles().FirstFontStyleWidget(12, Colors.orange[600]!)),
          if (selectedOrigin == selectedDestination && selectedOrigin != null)
            Text("• مبداء و مقصد نمی‌توانند یکسان باشند", style: AppFontStyles().FirstFontStyleWidget(12, Colors.red[600]!)),
          if (timeController.text.isEmpty)
            Text("• تاریخ سفر را انتخاب کنید", style: AppFontStyles().FirstFontStyleWidget(12, Colors.orange[600]!)),
        ],
      ),
    );
  }

  // ------------------------------------------------------
  //                  BUY BUTTON
  // ------------------------------------------------------

  Widget _buildBuyButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: fieldsFilled ? primary2Color : Colors.grey[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          onPressed: ticketController.isLoading.value || !fieldsFilled
              ? null
              : () async {
            /// ----------------------------------------
            /// 1) اول خرید بلیت از سرور
            /// ----------------------------------------
            final result = await ticketController.buyTicket(
              id: "1",
              buyerEmail: "test@gmail.com", // TODO: ایمیل کاربر
              origin: selectedOrigin!,
              destination: selectedDestination!,
              ticketTime: timeController.text,
              amountPaid: totalPrice,
              ticketType: ticketType!,
              passengersAmount: passengersCount,
            );

            if (result == null) {
              Get.snackbar(
                "Error",
                ticketController.errorMessage.value,
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            /// ----------------------------------------
            /// 2) رفتن به صفحه PaymentPage
            /// ----------------------------------------
            final paymentUrl = await Get.to(
                  () => PaymentPage(amount: totalPrice),
            );

            /// اگر کاربر برگشت بدون پرداخت:
            if (paymentUrl == null) {
              Get.snackbar(
                "Payment Cancelled",
                "The payment process was not completed.",
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            /// ----------------------------------------
            /// 3) نتیجه پرداخت از دیپ‌لینک
            /// ----------------------------------------
            final uri = Uri.parse(paymentUrl);
            final status = uri.queryParameters['status'];
            final tracking = uri.queryParameters['trackingCode'] ?? "000";

            ticketController.paymentStatus.value = status ?? "";
            ticketController.trackingCode.value = tracking;

            /// ----------------------------------------
            /// 4) اگر پرداخت موفق بود: PDF بساز
            /// ----------------------------------------
            if (status == "success") {
              /// *** نکته کلیدی ***
              /// قبل از ساخت PDF باید WebView کامل از حافظه خارج شود
              /// تا پکیج printing با WebView تداخل نکند
              Get.back(); // PaymentPage را حذف می‌کنیم
              await Future.delayed(const Duration(milliseconds: 250));

              final pdfFile = await ticketController.generateTicketPdf(
                buyerEmail: "test@gmail.com",
                origin: selectedOrigin!,
                destination: selectedDestination!,
                ticketTime: timeController.text,
                amountPaid: totalPrice,
                ticketType: ticketType!,
                passengersAmount: passengersCount,
                trackingCode: tracking,
              );

              if (pdfFile != null) {
                /// ----------------------------------------
                /// 5) نمایش / اشتراک PDF
                /// ----------------------------------------
                Future.microtask(() async {
                  await ticketController.sharePdfFile(pdfFile);
                });
              } else {
                Get.snackbar(
                  "Error",
                  "Could not generate PDF file.",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            }

            /// اگر پرداخت ناموفق بود:
            else {
              Get.snackbar(
                "Payment Failed",
                "Your payment was canceled or failed.",
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },

          child: ticketController.isLoading.value
              ? const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              Text(
                "buyTicket".tr,
                style: AppFontStyles()
                    .FirstFontStyleWidget(16, Colors.white),
              ),
            ],
          ),
        ),
      );
    });
  }





  // ------------------------------------------------------
  //                    STATUS MESSAGE
  // ------------------------------------------------------

  // Widget _buildStatusSection() {
  //   return Obx(() {
  //     // اگر API خطا داد
  //     if (ticketController.errorMessage.value.isNotEmpty) {
  //       return _statusCard(
  //         icon: Icons.error,
  //         title: "Error",
  //         message: ticketController.errorMessage.value,
  //         color: Colors.red,
  //       );
  //     }
  //
  //     // اگر پرداخت موفق بود
  //     if (ticketController.paymentStatus.value == "success") {
  //       return _statusCard(
  //         icon: Icons.check_circle,
  //         title: "Purchase Successful!",
  //         message: "Your payment was completed successfully.",
  //         color: Colors.green,
  //       );
  //     }
  //
  //     // اگر پرداخت ناموفق بود
  //     if (ticketController.paymentStatus.value == "failed") {
  //       return _statusCard(
  //         icon: Icons.cancel,
  //         title: "Payment Failed!",
  //         message: "Your payment was canceled or failed.",
  //         color: Colors.orange,
  //       );
  //     }
  //
  //     // در وضعیت عادی چیزی نشان نده
  //     return const SizedBox();
  //   });
  // }

  Widget _statusCard({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppFontStyles()
                        .FirstFontStyleWidget(16, color.withOpacity(0.9))),
                const SizedBox(height: 4),
                Text(message,
                    style: AppFontStyles()
                        .FirstFontStyleWidget(14, color.withOpacity(0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}