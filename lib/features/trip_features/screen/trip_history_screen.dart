
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_app_bar/app_app_bar.dart';
import 'package:flyaway/config/app_config/app_localization_config/en_US.dart';
import 'package:flyaway/config/app_config/app_localization_config/fa_IR.dart';
import 'package:flyaway/config/app_config/app_localization_config/language_service.dart';
import 'package:flyaway/config/app_config/app_shapes/media_query.dart';
import 'package:flyaway/config/app_config/app_theme_config/theme_service.dart';
import 'package:flyaway/config/app_config/change_datas_lang/change_datas_lang.dart';
import 'package:flyaway/features/trip_features/controller/trips_controller.dart';
import 'package:flyaway/features/trip_features/model/trips_history_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../home_features/widget/shimmer_loading_widget.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  final TripsController tripsController = Get.put(TripsController());
  final ThemeService themeService = ThemeService();
  final LanguageService languageService = Get.put(LanguageService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppAppBar().appBar(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tickets List
            Expanded(
              child: Obx(() {
                final data = tripsController.getAllTrips.value;
                final tickets = data?.tickets ?? [];

                if (data == null) {
                  return _buildLoadingShimmer();
                }

                if (tickets.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.blue,
                  onRefresh: () async {
                    await tripsController.getAllTrips();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      return _buildTicketCard(ticket, index);
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


  Widget _buildTicketCard(dynamic ticket, int index) {
    final changeDatasLang = ChangeDatasLang();
    final languageService = Get.find<LanguageService>();

    String _formatPrice(dynamic price) {
      if (price == null) return 'N/A';
      if (price is num) {
        return languageService.isPersian
            ? '${price.toStringAsFixed(0)} تومان'
            : '\$${price.toStringAsFixed(2)}';
      }
      return price.toString();
    }

    // تابع کمکی برای فرمت تاریخ
    String _formatDate(String? date) {
      if (date == null) return 'N/A';
      try {
        final parsedDate = DateTime.tryParse(date);
        if (parsedDate != null) {
          return languageService.isPersian
              ? '${parsedDate.year}/${parsedDate.month}/${parsedDate.day}'
              : '${parsedDate.month}/${parsedDate.day}/${parsedDate.year}';
        }
      } catch (e) {
        print('Error parsing date: $e');
      }
      return date;
    }

    // ویجت کمکی برای نمایش جزئیات
    Widget _buildDetailItem(IconData icon, String text) {
      return Column(
        children: [
          Icon(
            icon,
            color: Colors.blue[700],
            size: 16.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.blue[800],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      );
    }

    return Obx(() {
      final ticketType = changeDatasLang.trTicketType(ticket.ticketType?.toString() ?? 'Standard');
      final origin = _getTicketProperty(ticket, 'origin') ?? changeDatasLang.tr('Unknown');
      final destination = _getTicketProperty(ticket, 'destination') ?? changeDatasLang.tr('Unknown');
      final flightNumber = _getTicketProperty(ticket, 'flightNumber')?.toString();
      final ticketTime = _getTicketProperty(ticket, 'ticketTime');
      final buyerEmail = _getTicketProperty(ticket, 'buyer_email');

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadowColor: Colors.blue.withOpacity(0.2),
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.blue[100]!,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Header with ticket type and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue[600]!,
                            Colors.blue[800]!,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        ticketType,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.airplane_ticket_rounded,
                        color: Colors.blue[700],
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Route Information
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            origin,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            changeDatasLang.tr('Departure'),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.blue[600]!.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Airplane icon
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        children: [
                          Icon(
                            Icons.flight_takeoff_rounded,
                            color: Colors.blue[700],
                            size: 18.sp,
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            height: 1.h,
                            width: 40.w,
                            color: Colors.blue[200],
                          ),
                          SizedBox(height: 4.h),
                          Icon(
                            Icons.flight_land_rounded,
                            color: Colors.blue[700],
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            destination,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            changeDatasLang.tr('Arrival'),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.blue[600]!.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Flight Details
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.blue[50]!.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.blue[100]!,
                    ),
                  ),
                  child: Container(
                    child: Text('data'),
                  ),
                ),

                SizedBox(height: 12.h),

                // Price and Action
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       changeDatasLang.tr('Total Price'),
                //       style: TextStyle(
                //         fontSize: 14.sp,
                //         color: Colors.blue[800]!.withOpacity(0.8),
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //     Container(
                //       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                //       decoration: BoxDecoration(
                //         color: Colors.blue[50],
                //         borderRadius: BorderRadius.circular(8.r),
                //         border: Border.all(
                //           color: Colors.blue[200]!,
                //         ),
                //       ),
                //       child: Text(
                //         _formatPrice('price'),
                //         style: TextStyle(
                //           fontSize: 16.sp,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.blue[800],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }

// تابع کمکی برای دسترسی به خصوصیت‌های تیکت
  // تابع کمکی برای دسترسی به خصوصیت‌های تیکت
  dynamic _getTicketProperty(dynamic ticket, String property) {
    if (ticket == null) return null;

    // اگر تیکت یک Map است
    if (ticket is Map) {
      return ticket[property];
    }

    // اگر تیکت یک آبجکت است، از روش مستقیم استفاده کنید
    try {
      // روش امن برای دسترسی به propertyهای مختلف
      switch (property) {
        case 'origin':
          return ticket.origin ?? ticket.from ?? ticket.departureCity;
        case 'destination':
          return ticket.destination ?? ticket.to ?? ticket.arrivalCity;
        case 'departureDate':
          return ticket.departureDate ?? ticket.date ?? ticket.flightDate;
        case 'departureTime':
          return ticket.departureTime ?? ticket.time ?? ticket.flightTime;
        case 'flightNumber':
          return ticket.flightNumber ?? ticket.number ?? ticket.flightNo;
        case 'price':
          return ticket.price ?? ticket.cost ?? ticket.amount;
        case 'ticketType':
          return ticket.ticketType ?? ticket.type ?? ticket.classType;
        default:
        // سعی کنید از طریق [] به property دسترسی پیدا کنید
          try {
            return ticket[property];
          } catch (e) {
            // اگر باز هم خطا داد، null برگردانید
            return null;
          }
      }
    } catch (e) {
      print('Error accessing property $property: $e');
      return null;
    }
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue[200]!,
            ),
          ),
          child: Icon(
            icon,
            size: 14.sp,
            color: Colors.blue[700],
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          text,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.blue[800]!.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: ShimmerLoadingClass().shimmerComments(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.airplane_ticket_rounded,
              size: 60.sp,
              color: Colors.blue[400],
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No Trips Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your trip history will appear here',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.blue[600]!.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[600]!,
                  Colors.blue[800]!,
                ],
              ),
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Text(
              'Book Your First Flight',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to safely access ticket properties


  dynamic _getProperty(dynamic object, String propertyName) {
    try {
      switch (propertyName) {
        case 'ticketType':
          return object.ticketType;
        case 'origin':
          return object.origin ?? object.departureCity ?? object.fromCity;
        case 'destination':
          return object.destination ?? object.arrivalCity ?? object.toCity;
        case 'departureDate':
          return object.departureDate ?? object.date ?? object.flightDate;
        case 'departureTime':
          return object.departureTime ?? object.time ?? object.flightTime;
        case 'flightNumber':
          return object.flightNumber ?? object.number;
        case 'price':
          return object.price ?? object.totalPrice ?? object.amount;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '\$0';
    if (price is num) {
      return '\$${price.toStringAsFixed(2)}';
    }
    if (price is String) {
      return '\$$price';
    }
    return '\$0';
  }
}