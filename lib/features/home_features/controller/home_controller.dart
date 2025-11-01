import 'package:flyaway/features/home_features/model/home_row_ticket_model.dart';
import 'package:flyaway/features/home_features/services/home_rows_ticket_api.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HomeRowsTicketApi homeRowsTicketApi = HomeRowsTicketApi();
  var ticketRow = Rxn<HomeRowTicketModel>();

  Future<HomeRowTicketModel?> loadTicketRowApi() async {
    ticketRow.value = await homeRowsTicketApi.callHomeRowsTicketApi();
    return ticketRow.value;
  }

  @override
  void onInit() {
    loadTicketRowApi();
  }
}
