import 'package:get/get.dart';
import '../services/buy_ticket_services.dart';

class BuyTicketController extends GetxController {
  final BuyTicketServices _service = BuyTicketServices();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<Map<String, dynamic>?> buyTicket({
    required String id,
    required String buyerEmail,
    required String origin,
    required String destination,
    required String ticketTime,
    required int amountPaid,
    required String ticketType,
    required int passengersAmount,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _service.callBuyTicketApi(
        id: id,
        buyerEmail: buyerEmail,
        origin: origin,
        destination: destination,
        ticketTime: ticketTime,
        amountPaid: amountPaid,
        ticketType: ticketType,
        passengersAmount: passengersAmount,
      );

      isLoading.value = false;

      // اگر Null یا StatusCode خراب بود
      if (response == null) {
        errorMessage.value = "Server not responding!";
        return null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // خرید موفق → دیتا را برگردان
        return response.data;
      } else {
        errorMessage.value = response.data?["message"] ?? "Request failed!";
        return null;
      }

    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      return null;
    }
  }
}
