import 'package:flyaway/features/home_features/model/home_row_ticket_model.dart';
import 'package:flyaway/features/home_features/services/home_rows_ticket_api.dart';
import 'package:flyaway/features/home_features/services/home_show_comments_api.dart';
import 'package:get/get.dart';

import '../model/home_show_comments_model.dart';

class HomeController extends GetxController {
  final HomeRowsTicketApi homeRowsTicketApi = HomeRowsTicketApi();
  final HomeShowCommentsApi homeShowCommentsApi = HomeShowCommentsApi();

  var ticketRow = Rxn<HomeRowTicketModel>();
  var showComments = Rxn<HomeShowCommentsModel>();


  Future<HomeRowTicketModel?> loadTicketRowApi() async {
    ticketRow.value = await homeRowsTicketApi.callHomeRowsTicketApi();
    return ticketRow.value;
  }

  Future<HomeShowCommentsModel?>loadShowComments()async{
    showComments.value = await homeShowCommentsApi.callHomeCommentsApi();
    return showComments.value;
  }

  @override
  void onInit() {
    loadTicketRowApi();
    loadShowComments();
  }
}
