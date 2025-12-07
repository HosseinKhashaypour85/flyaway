import 'package:dio/dio.dart';

import '../../../config/app_config/app_urls_config/app_urls_config.dart';

class TripApiServices {
  Future<Response?> callTripsHistoryApi(String phone) async {
    final Dio dio = Dio();
    try {
      return await dio.get(
        AppUrlsConfig.getAllTrips,
        queryParameters: {"phone": phone},
      );
    } on DioException catch (e) {
      print("⚠️ خطا دریافت لیست سفرها: ${e.response?.data}");
      return e.response;
    }
  }

}
