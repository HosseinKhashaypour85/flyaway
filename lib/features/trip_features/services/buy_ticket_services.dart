import 'package:dio/dio.dart';

import '../../../config/app_config/app_urls_config/app_urls_config.dart';

class BuyTicketServices {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ),
  );

  Future<Response?> callBuyTicketApi({
    required String id,
    required String buyerEmail,
    required String origin,
    required String destination,
    required String ticketTime,
    required int amountPaid,
    required String ticketType,
    required int passengersAmount,
    required String buyerPhone,
  }) async {
    try {
      final response = await _dio.post(
        AppUrlsConfig.buyTicket,
        data: {
          'id': id,
          'buyer_email': buyerEmail,
          'buyer_phone': buyerPhone,
          'origin': origin,
          'destination': destination,
          'ticket_time': ticketTime,
          'amount_paid': amountPaid,
          'ticket_type': ticketType,
          'passengers_amount': passengersAmount,
        },
      );

      return response;
    } on DioException catch (e) {
      print("❌ Buy Ticket API Error → ${e.response?.data}");
      return e.response;
    }
  }
}
