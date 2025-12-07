import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flyaway/config/app_config/app_app_bar/app_app_bar.dart';
import 'package:flyaway/config/app_config/app_colors/app_colors.dart';
import 'package:flyaway/config/app_config/app_font_styles/app_font_styles.dart';
import 'package:flyaway/config/app_config/app_price_format/app_price_format.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../config/app_config/app_shared_prefences/app_secure_storage.dart';
import '../controller/trips_controller.dart';
import '../model/trips_history_model.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  final TripsController _controller = Get.put(TripsController());

  @override
  void initState() {
    super.initState();
    // 重新加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reloadTrips();
    });
  }

  Future<void> _reloadTrips() async {
    final localStorage = await LocalStorage.getInstance();
    final phone = await localStorage?.get('phone');
    if (phone != null) {
      await _controller.loadAllTrips(phone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar().appBar(context),
      body: Column(
        children: [
          // Trip history list
          Expanded(
            child: Obx(() {
              final trips = _controller.trips.value?.tickets;

              if (trips == null) {
                return _buildLoadingState();
              }

              if (trips.isEmpty) {
                return _buildEmptyState();
              }

              return _buildTripList(trips);
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reloadTrips,
        tooltip: 'Refresh',
        backgroundColor: primary2Color,
        child: const Icon(Icons.refresh , color: Colors.white,),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primary2Color,),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.airplanemode_inactive, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No trips found',
            style: AppFontStyles().FirstFontStyleWidget(14.sp, Colors.black),
          ),
          const SizedBox(height: 8),
          Text(
            'You haven\'t booked any trips yet',
            style: AppFontStyles().FirstFontStyleWidget(11.sp, Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.toNamed('/book-flight'),
            child: Text('Book a Flight', style: AppFontStyles().FirstFontStyleWidget(11.sp, Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTripList(List<Tickets> trips) {
    return RefreshIndicator(
      onRefresh: _reloadTrips,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final ticket = trips[index];
          return _buildTripCard(ticket);
        },
      ),
    );
  }

  Widget _buildTripCard(Tickets ticket) {
    // Parse date time
    DateTime? ticketDateTime;
    String formattedDate = 'N/A';
    String formattedTime = 'N/A';

    try {
      if (ticket.ticketTime != null && ticket.ticketTime!.isNotEmpty) {
        ticketDateTime = DateTime.parse(ticket.ticketTime!);
        formattedDate = DateFormat('MMM dd, yyyy').format(ticketDateTime);
        formattedTime = DateFormat('HH:mm').format(ticketDateTime);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    // Determine status based on date

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.blue.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${ticket.origin ?? 'N/A'} → ${ticket.destination ?? 'N/A'}',
                    style: AppFontStyles().FirstFontStyleWidget(14.sp, Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Trip ID
            if (ticket.id != null)
              _buildTripDetailRow(
                icon: Icons.confirmation_number,
                title: 'ticketId'.tr,
                value: '#${ticket.id}',
              ),

            // Passenger count
            _buildTripDetailRow(
              icon: Icons.person,
              title: 'passengers'.tr,
              value: '${ticket.passengersAmount ?? 1}',
            ),



            // Amount paid
            if (ticket.amountPaid != null && ticket.amountPaid!.isNotEmpty)
              _buildTripDetailRow(
                icon: Icons.attach_money,
                title: 'amountPaid'.tr,
                value: formatNumber(int.parse(ticket.amountPaid!)),
              ),

            const Divider(height: 20),

            // Action buttons
          ],
        ),
      ),
    );
  }

  Widget _buildTripDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Text(
                  '$title: ',
                  style: AppFontStyles().FirstFontStyleWidget(11.sp, Colors.grey.shade600),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: AppFontStyles().FirstFontStyleWidget(11.sp, Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _viewTicketDetails(Tickets ticket) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              'Ticket Details',
              style: AppFontStyles().FirstFontStyleWidget(15.sp, Colors.black),
            ),

            const SizedBox(height: 16),

            _buildDetailItem('Ticket ID', '#${ticket.id}'),
            _buildDetailItem('From', ticket.origin ?? 'N/A'),
            _buildDetailItem('To', ticket.destination ?? 'N/A'),
            _buildDetailItem('Passenger Email', ticket.buyerEmail ?? 'N/A'),
            _buildDetailItem('Passenger Phone', ticket.buyerPhone ?? 'N/A'),
            _buildDetailItem('Passengers', '${ticket.passengersAmount ?? 1}'),
            _buildDetailItem('Ticket Type', ticket.ticketType ?? 'N/A'),
            _buildDetailItem('Amount', '${ticket.amountPaid} تومان'),

            if (ticket.ticketTime != null && ticket.ticketTime!.isNotEmpty)
              _buildDetailItem(
                'Date & Time',
                DateFormat('yyyy-MM-dd HH:mm').format(
                    DateTime.parse(ticket.ticketTime!)
                ),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: Text('Close', style: AppFontStyles().FirstFontStyleWidget(11.sp, Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$title:',
              style: AppFontStyles().FirstFontStyleWidget(11.sp, Colors.grey.shade700),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: AppFontStyles().FirstFontStyleWidget(11.sp, Colors.black)),
          ),
        ],
      ),
    );
  }
}