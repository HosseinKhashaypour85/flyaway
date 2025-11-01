import 'package:dio/dio.dart';
import 'package:flyaway/config/app_config/app_call_api_dio/app_call_api.dart';
import 'package:flyaway/config/app_config/app_urls_config/app_urls_config.dart';
import 'package:flyaway/features/home_features/model/home_row_ticket_model.dart';

class HomeRowsTicketApi {
  final Dio dio = DioClient().dio;

  Future<HomeRowTicketModel?> callHomeRowsTicketApi() async {
    try {
      final Response response = await dio.get(AppUrlsConfig.homeRowsTicket);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return HomeRowTicketModel.fromJson(response.data);
      } else {
        print('❌ خطا در پاسخ سرور: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('⚠️ خطا در ارتباط با سرور: $e');
      return null;
    }
  }
}
